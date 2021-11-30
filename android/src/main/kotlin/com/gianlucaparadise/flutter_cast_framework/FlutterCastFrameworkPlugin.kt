package com.gianlucaparadise.flutter_cast_framework

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent
import androidx.lifecycle.ProcessLifecycleOwner
import com.gianlucaparadise.flutter_cast_framework.cast.CastDialogOpener
import com.gianlucaparadise.flutter_cast_framework.cast.MessageCastingChannel
import com.gianlucaparadise.flutter_cast_framework.media.getFlutterMediaInfo
import com.gianlucaparadise.flutter_cast_framework.media.getMediaLoadRequestData
import com.google.android.gms.cast.MediaError
import com.google.android.gms.cast.MediaStatus.PLAYER_STATE_UNKNOWN
import com.google.android.gms.cast.framework.CastContext
import com.google.android.gms.cast.framework.CastSession
import com.google.android.gms.cast.framework.SessionManager
import com.google.android.gms.cast.framework.SessionManagerListener
import com.google.android.gms.cast.framework.media.RemoteMediaClient
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


class FlutterCastFrameworkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, LifecycleObserver {
    companion object {
        const val TAG = "AndroidCastPlugin"

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val plugin = FlutterCastFrameworkPlugin()
            plugin.onAttachedToEngine(registrar.context(), registrar.messenger())
        }
    }

    init {
        ProcessLifecycleOwner.get().lifecycle.addObserver(this)
    }

    //region FlutterPlugin interface
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onAttachedToEngine")
        onAttachedToEngine(binding.applicationContext, binding.binaryMessenger)
    }

    private fun onAttachedToEngine(applicationContext: Context, messenger: BinaryMessenger) {
        this.applicationContext = applicationContext

        castApi = MyApi()
        PlatformBridgeApis.CastHostApi.setup(messenger, castApi)

        val castFlutterApi = PlatformBridgeApis.CastFlutterApi(messenger)
        flutterApi = castFlutterApi

        mMessageCastingChannel = MessageCastingChannel(castFlutterApi)

        CastContext.getSharedInstance(applicationContext).addCastStateListener { i ->
            Log.d(TAG, "Cast state changed: $i")
            flutterApi?.onCastStateChanged(i.toLong()) { }
        }

        mSessionManager = CastContext.getSharedInstance(applicationContext).sessionManager
        mCastSession = mSessionManager.currentCastSession
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onDetachedFromEngine")
        applicationContext = null;
        mMessageCastingChannel = null
    }
    //endregion

    //region ActivityAware
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d(TAG, "onAttachedToActivity")
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        Log.d(TAG, "onDetachedFromActivityForConfigChanges")
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        Log.d(TAG, "onReattachedToActivityForConfigChanges")
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        Log.d(TAG, "onDetachedFromActivity")
        activity = null
    }
    //endregion

    private lateinit var mSessionManager: SessionManager
    private val mSessionManagerListener = CastSessionManagerListener()
    private val remoteMediaClientListener = RemoteMediaClientListener()

    private var castApi: PlatformBridgeApis.CastHostApi? = null
    private var flutterApi: PlatformBridgeApis.CastFlutterApi? = null
    private var applicationContext: Context? = null
    private var activity: Activity? = null

    private var mMessageCastingChannel: MessageCastingChannel? = null

    private var mCastSession: CastSession? = null
        set(value) {
            Log.d(TAG, "Updating mCastSession - castSession changed: ${field != value}")
            // if (field == value) return // Despite the instances are the same, I need to re-attach the listener to every new session instance

            val oldSession = field
            field = value

            remoteMediaClient = value?.remoteMediaClient
            flutterApi?.getSessionMessageNamespaces(getOnNamespaceResult(oldSession, newSession = value))
        }

    private var remoteMediaClient: RemoteMediaClient? = null
        set(value) {
            Log.d(TAG, "Updating remoteMediaClient - remoteMediaClient changed: ${field != value}")

            field?.unregisterCallback(remoteMediaClientListener)
            value?.registerCallback(remoteMediaClientListener)

            // Amount of time in milliseconds between subsequent updates
            val periodMs = 1000L
            field?.removeProgressListener(remoteMediaClientListener)
            value?.addProgressListener(remoteMediaClientListener, periodMs)

            field = value
        }

    //region LifecycleObserver
    @OnLifecycleEvent(Lifecycle.Event.ON_CREATE)
    fun onCreate() {
        Log.d(TAG, "App: ON_CREATE")
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_RESUME)
    fun onResume() {
        Log.d(TAG, "App: ON_RESUME")
        mSessionManager.addSessionManagerListener(mSessionManagerListener, CastSession::class.java)
        mCastSession = mSessionManager.currentCastSession

        val context = applicationContext
        if (context == null) {
            Log.d(TAG, "App: ON_RESUME - missing context")
            return
        }
        val castState = CastContext.getSharedInstance(context).castState
        flutterApi?.onCastStateChanged(castState.toLong()) { }
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_PAUSE)
    fun onPause() {
        Log.d(TAG, "App: ON_PAUSE")
        mSessionManager.removeSessionManagerListener(
                mSessionManagerListener,
                CastSession::class.java
        )
        // I can't set this to null because I need the cast session to send commands from notification
        // mCastSession = null
    }
    //endregion

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.d(TAG, "onMethodCall - ${call.method} not implemented")
        result.notImplemented()
    }

    private inner class RemoteMediaClientListener : RemoteMediaClient.Callback(), RemoteMediaClient.ProgressListener {
        override fun onStatusUpdated() {
            Log.d(TAG, "RemoteMediaClient - onStatusUpdated")
            super.onStatusUpdated()
            val playerStateRaw = remoteMediaClient?.playerState ?: PLAYER_STATE_UNKNOWN
            flutterApi?.onStatusUpdated(playerStateRaw.toLong()) { }
        }

        override fun onMetadataUpdated() {
            Log.d(TAG, "RemoteMediaClient - onMetadataUpdated")
            super.onMetadataUpdated()
            flutterApi?.onMetadataUpdated { }
        }

        override fun onQueueStatusUpdated() {
            Log.d(TAG, "RemoteMediaClient - onQueueStatusUpdated")
            super.onQueueStatusUpdated()
            flutterApi?.onQueueStatusUpdated { }
        }

        override fun onPreloadStatusUpdated() {
            Log.d(TAG, "RemoteMediaClient - onPreloadStatusUpdated")
            super.onPreloadStatusUpdated()
            flutterApi?.onPreloadStatusUpdated { }
        }

        override fun onSendingRemoteMediaRequest() {
            Log.d(TAG, "RemoteMediaClient - onSendingRemoteMediaRequest")
            super.onSendingRemoteMediaRequest()
            flutterApi?.onSendingRemoteMediaRequest { }
        }

        override fun onAdBreakStatusUpdated() {
            Log.d(TAG, "RemoteMediaClient - onAdBreakStatusUpdated")
            super.onAdBreakStatusUpdated()
            flutterApi?.onAdBreakStatusUpdated { }
        }

        override fun onMediaError(error: MediaError?) {
            Log.d(TAG, "RemoteMediaClient - onMediaError $error")
            super.onMediaError(error)
            flutterApi?.onMediaError { }
        }

        override fun onProgressUpdated(progressMs: Long, durationMs: Long) {
            Log.d(TAG, "RemoteMediaClient - onProgressUpdated progress: $progressMs duration: $durationMs")
            flutterApi?.onProgressUpdated(progressMs, durationMs) { }
        }
    }

    private inner class MyApi : PlatformBridgeApis.CastHostApi {
        override fun sendMessage(message: PlatformBridgeApis.CastMessage?) {
            mMessageCastingChannel?.sendMessage(mCastSession, message)
        }

        override fun showCastDialog() {
            val context = applicationContext
            val activity = activity
            if (context == null || activity == null) {
                Log.d(TAG, "showCastDialog - missing context")
                return
            }

            CastDialogOpener.showCastDialog(context, activity)
        }

        override fun loadMediaLoadRequestData(request: PlatformBridgeApis.MediaLoadRequestData?) {
            if (request == null) return

            val remoteMediaClient: RemoteMediaClient = remoteMediaClient ?: return

            val mediaLoadRequest = getMediaLoadRequestData(request)
            remoteMediaClient.load(mediaLoadRequest)
        }

        override fun getMediaInfo(): PlatformBridgeApis.MediaInfo {
            val remoteMediaClient: RemoteMediaClient = remoteMediaClient
                    ?: return PlatformBridgeApis.MediaInfo()

            val hostMediaInfo = remoteMediaClient.mediaInfo ?: return PlatformBridgeApis.MediaInfo()

            return getFlutterMediaInfo(hostMediaInfo)
        }

        override fun play() {
            val remoteMediaClient: RemoteMediaClient = remoteMediaClient ?: return
            remoteMediaClient.play()
        }

        override fun pause() {
            val remoteMediaClient: RemoteMediaClient = remoteMediaClient ?: return
            remoteMediaClient.pause()
        }

        override fun stop() {
            val remoteMediaClient: RemoteMediaClient = remoteMediaClient ?: return
            remoteMediaClient.stop()
        }
    }

    private fun getOnNamespaceResult(oldSession: CastSession?, newSession: CastSession?) = PlatformBridgeApis.CastFlutterApi.Reply<MutableList<String>> { namespaces ->
        Log.d(TAG, "Updating mCastSession - getOnNamespaceResult - param: $namespaces")
        if (oldSession == null && newSession == null) return@Reply // nothing to do here
        if (namespaces == null || !namespaces.any()) return@Reply  // nothing to do here

        namespaces.forEach { namespace ->
            try {
                oldSession?.removeMessageReceivedCallbacks(namespace)
                newSession?.setMessageReceivedCallbacks(namespace, mMessageCastingChannel)
            } catch (e: java.lang.Exception) {
                Log.e(TAG, "Updating mCastSession - Exception while creating channel", e)
            }
        }
    }

    private inner class CastSessionManagerListener : SessionManagerListener<CastSession> {
        private var TAG = "SessionManagerListenerImpl"

        override fun onSessionSuspended(session: CastSession?, p1: Int) {
            Log.d(TAG, "onSessionSuspended")
            flutterApi?.onSessionSuspended { }
        }

        override fun onSessionStarting(session: CastSession?) {
            Log.d(TAG, "onSessionStarting")
            flutterApi?.onSessionStarting { }

            mCastSession = session
        }

        override fun onSessionResuming(session: CastSession?, p1: String?) {
            Log.d(TAG, "onSessionResuming")
            flutterApi?.onSessionResuming { }

            mCastSession = session
        }

        override fun onSessionEnding(session: CastSession?) {
            Log.d(TAG, "onSessionEnding")
            flutterApi?.onSessionEnding { }
        }

        override fun onSessionStartFailed(session: CastSession?, p1: Int) {
            Log.d(TAG, "onSessionStartFailed")
            flutterApi?.onSessionStartFailed { }
        }

        override fun onSessionResumeFailed(session: CastSession?, p1: Int) {
            Log.d(TAG, "onSessionResumeFailed")
            flutterApi?.onSessionResumeFailed { }
        }

        override fun onSessionStarted(session: CastSession, sessionId: String) {
            Log.d(TAG, "onSessionStarted")
            flutterApi?.onSessionStarted { }

            mCastSession = session
        }

        override fun onSessionResumed(session: CastSession, wasSuspended: Boolean) {
            Log.d(TAG, "onSessionResumed")
            flutterApi?.onSessionResumed { }

            mCastSession = session
        }

        override fun onSessionEnded(session: CastSession, error: Int) {
            Log.d(TAG, "onSessionEnded")
            flutterApi?.onSessionEnded { }
        }
    }
}
