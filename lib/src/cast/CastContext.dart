import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../MethodNames.dart';
import 'SessionManager.dart';

class CastContext {
  final ValueNotifier<CastState> state = ValueNotifier(CastState.unavailable);
  final MethodChannel _channel;

  CastContext(this._channel);

  void showCastChooserDialog() {
    _channel.invokeMethod(PlatformMethodNames.showCastDialog);
  }

  void onCastStateChanged(dynamic arguments) {
    int castState = arguments;
    state.value = CastState.values[castState];
  }

  SessionManager _sessionManager;
  SessionManager get sessionManager {
    if (_sessionManager == null) {
      _sessionManager = SessionManager(_channel);
    }
    return _sessionManager;
  }
}

enum CastState {
  idle, // 0
  unavailable, // 1
  unconnected, // 2
  connecting, // 3
  connected, // 4
}