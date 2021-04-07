import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ScreenshotObserver {
  static const MethodChannel _channel =
      const MethodChannel('screenshot_observer');
  static List<VoidCallback> _listeners = [];

  static Future<void> initialize() async {
    _channel.setMethodCallHandler(_handleMethod);
    await _channel.invokeMethod('initialize');
  }

  static void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  static Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onScreenshot':
        for (final listener in _listeners) {
          listener();
        }
        break;
      default:
        throw ('method not defined');
    }
  }

  /// Remove listeners.
  static Future<void> dispose() async {
    _listeners.clear();
    await _channel.invokeMethod('dispose');
  }
}
