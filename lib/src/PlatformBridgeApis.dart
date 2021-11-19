// Autogenerated from Pigeon (v1.0.8), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name
// @dart = 2.12
import 'dart:async';
import 'dart:typed_data' show Uint8List, Int32List, Int64List, Float64List;

import 'package:flutter/foundation.dart' show WriteBuffer, ReadBuffer;
import 'package:flutter/services.dart';

enum StreamType {
  invalid,
  none,
  buffered,
  live,
}

enum MediaType {
  generic,
  movie,
  tvShow,
  musicTrack,
  photo,
  audiobookChapter,
  user,
}

enum TrackType {
  unknown,
  text,
  audio,
  video,
}

enum TrackSubtype {
  unknown,
  none,
  subtitles,
  captions,
  descriptions,
  chapters,
  metadata,
}

class MediaLoadRequestData {
  bool? shouldAutoplay;
  int? currentTime;
  MediaInfo? mediaInfo;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['shouldAutoplay'] = shouldAutoplay;
    pigeonMap['currentTime'] = currentTime;
    pigeonMap['mediaInfo'] = mediaInfo == null ? null : mediaInfo!.encode();
    return pigeonMap;
  }

  static MediaLoadRequestData decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return MediaLoadRequestData()
      ..shouldAutoplay = pigeonMap['shouldAutoplay'] as bool?
      ..currentTime = pigeonMap['currentTime'] as int?
      ..mediaInfo = pigeonMap['mediaInfo'] != null
          ? MediaInfo.decode(pigeonMap['mediaInfo']!)
          : null;
  }
}

class MediaInfo {
  String? contentId;
  StreamType? streamType;
  String? contentType;
  MediaMetadata? mediaMetadata;
  List<MediaTrack?>? mediaTracks;
  int? streamDuration;
  String? customDataAsJson;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['contentId'] = contentId;
    pigeonMap['streamType'] = streamType == null ? null : streamType!.index;
    pigeonMap['contentType'] = contentType;
    pigeonMap['mediaMetadata'] = mediaMetadata == null ? null : mediaMetadata!.encode();
    pigeonMap['mediaTracks'] = mediaTracks;
    pigeonMap['streamDuration'] = streamDuration;
    pigeonMap['customDataAsJson'] = customDataAsJson;
    return pigeonMap;
  }

  static MediaInfo decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return MediaInfo()
      ..contentId = pigeonMap['contentId'] as String?
      ..streamType = pigeonMap['streamType'] != null
          ? StreamType.values[pigeonMap['streamType']! as int]
          : null
      ..contentType = pigeonMap['contentType'] as String?
      ..mediaMetadata = pigeonMap['mediaMetadata'] != null
          ? MediaMetadata.decode(pigeonMap['mediaMetadata']!)
          : null
      ..mediaTracks = (pigeonMap['mediaTracks'] as List<Object?>?)?.cast<MediaTrack?>()
      ..streamDuration = pigeonMap['streamDuration'] as int?
      ..customDataAsJson = pigeonMap['customDataAsJson'] as String?;
  }
}

class MediaMetadata {
  MediaType? mediaType;
  List<WebImage?>? webImages;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['mediaType'] = mediaType == null ? null : mediaType!.index;
    pigeonMap['webImages'] = webImages;
    return pigeonMap;
  }

  static MediaMetadata decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return MediaMetadata()
      ..mediaType = pigeonMap['mediaType'] != null
          ? MediaType.values[pigeonMap['mediaType']! as int]
          : null
      ..webImages = (pigeonMap['webImages'] as List<Object?>?)?.cast<WebImage?>();
  }
}

class WebImage {
  String? url;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['url'] = url;
    return pigeonMap;
  }

  static WebImage decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return WebImage()
      ..url = pigeonMap['url'] as String?;
  }
}

class MediaTrack {
  int? id;
  TrackType? trackType;
  String? name;
  TrackSubtype? trackSubtype;
  String? contentId;
  String? language;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['id'] = id;
    pigeonMap['trackType'] = trackType == null ? null : trackType!.index;
    pigeonMap['name'] = name;
    pigeonMap['trackSubtype'] = trackSubtype == null ? null : trackSubtype!.index;
    pigeonMap['contentId'] = contentId;
    pigeonMap['language'] = language;
    return pigeonMap;
  }

  static MediaTrack decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return MediaTrack()
      ..id = pigeonMap['id'] as int?
      ..trackType = pigeonMap['trackType'] != null
          ? TrackType.values[pigeonMap['trackType']! as int]
          : null
      ..name = pigeonMap['name'] as String?
      ..trackSubtype = pigeonMap['trackSubtype'] != null
          ? TrackSubtype.values[pigeonMap['trackSubtype']! as int]
          : null
      ..contentId = pigeonMap['contentId'] as String?
      ..language = pigeonMap['language'] as String?;
  }
}

class CastMessage {
  String? namespace;
  String? message;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['namespace'] = namespace;
    pigeonMap['message'] = message;
    return pigeonMap;
  }

  static CastMessage decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return CastMessage()
      ..namespace = pigeonMap['namespace'] as String?
      ..message = pigeonMap['message'] as String?;
  }
}

class _CastHostApiCodec extends StandardMessageCodec {
  const _CastHostApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CastMessage) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else 
    if (value is MediaInfo) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else 
    if (value is MediaLoadRequestData) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else 
    if (value is MediaMetadata) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else 
    if (value is MediaTrack) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else 
    if (value is WebImage) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else 
{
      super.writeValue(buffer, value);
    }
  }
  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:       
        return CastMessage.decode(readValue(buffer)!);
      
      case 129:       
        return MediaInfo.decode(readValue(buffer)!);
      
      case 130:       
        return MediaLoadRequestData.decode(readValue(buffer)!);
      
      case 131:       
        return MediaMetadata.decode(readValue(buffer)!);
      
      case 132:       
        return MediaTrack.decode(readValue(buffer)!);
      
      case 133:       
        return WebImage.decode(readValue(buffer)!);
      
      default:      
        return super.readValueOfType(type, buffer);
      
    }
  }
}

class CastHostApi {
  /// Constructor for [CastHostApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  CastHostApi({BinaryMessenger? binaryMessenger}) : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _CastHostApiCodec();

  Future<void> sendMessage(CastMessage arg_message) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.CastHostApi.sendMessage', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object>[arg_message]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> showCastDialog() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.CastHostApi.showCastDialog', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> loadMediaLoadRequestData(MediaLoadRequestData arg_request) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.CastHostApi.loadMediaLoadRequestData', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object>[arg_request]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }
}

class _CastFlutterApiCodec extends StandardMessageCodec {
  const _CastFlutterApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CastMessage) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else 
{
      super.writeValue(buffer, value);
    }
  }
  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:       
        return CastMessage.decode(readValue(buffer)!);
      
      default:      
        return super.readValueOfType(type, buffer);
      
    }
  }
}
abstract class CastFlutterApi {
  static const MessageCodec<Object?> codec = _CastFlutterApiCodec();

  List<String?> getSessionMessageNamespaces();
  void onCastStateChanged(int castState);
  void onMessageReceived(CastMessage message);
  void onSessionStarting();
  void onSessionStarted();
  void onSessionStartFailed();
  void onSessionEnding();
  void onSessionEnded();
  void onSessionResuming();
  void onSessionResumed();
  void onSessionResumeFailed();
  void onSessionSuspended();
  void onStatusUpdated();
  void onMetadataUpdated();
  void onQueueStatusUpdated();
  void onPreloadStatusUpdated();
  void onSendingRemoteMediaRequest();
  void onAdBreakStatusUpdated();
  void onMediaError();
  static void setup(CastFlutterApi? api) {
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.getSessionMessageNamespaces', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          final List<String?> output = api.getSessionMessageNamespaces();
          return output;
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.onCastStateChanged', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.CastFlutterApi.onCastStateChanged was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_castState = args[0] as int?;
          assert(arg_castState != null, 'Argument for dev.flutter.pigeon.CastFlutterApi.onCastStateChanged was null, expected non-null int.');
          api.onCastStateChanged(arg_castState!);
          return;
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.onMessageReceived', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.CastFlutterApi.onMessageReceived was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final CastMessage? arg_message = args[0] as CastMessage?;
          assert(arg_message != null, 'Argument for dev.flutter.pigeon.CastFlutterApi.onMessageReceived was null, expected non-null CastMessage.');
          api.onMessageReceived(arg_message!);
          return;
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.onSessionStarting', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onSessionStarting();
          return;
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.onSessionStarted', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onSessionStarted();
          return;
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.onSessionStartFailed', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onSessionStartFailed();
          return;
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.onSessionEnding', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onSessionEnding();
          return;
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.onSessionEnded', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onSessionEnded();
          return;
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.onSessionResuming', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onSessionResuming();
          return;
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.onSessionResumed', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onSessionResumed();
          return;
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.onSessionResumeFailed', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onSessionResumeFailed();
          return;
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.onSessionSuspended', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onSessionSuspended();
          return;
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.onStatusUpdated', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onStatusUpdated();
          return;
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.onMetadataUpdated', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onMetadataUpdated();
          return;
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.onQueueStatusUpdated', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onQueueStatusUpdated();
          return;
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.onPreloadStatusUpdated', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onPreloadStatusUpdated();
          return;
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.onSendingRemoteMediaRequest', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onSendingRemoteMediaRequest();
          return;
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.onAdBreakStatusUpdated', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onAdBreakStatusUpdated();
          return;
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.CastFlutterApi.onMediaError', codec);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.onMediaError();
          return;
        });
      }
    }
  }
}
