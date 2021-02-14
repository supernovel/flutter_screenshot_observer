import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenshotObserver {
  static const MethodChannel _channel =
      const MethodChannel('screenshot_observer');
  static List<VoidCallback> _listeners = [];

  static Future<void> initialize() async {
    if (Platform.isAndroid) {
      final isGranted = await Permission.storage.isGranted;

      if (!isGranted) {
        await Permission.storage.request();
      }
    }
    _channel.setMethodCallHandler(_handleMethod);
    await _channel.invokeMethod('initialize');
  }

  static void addListener(VoidCallback listener) {
    assert(listener != null, 'A non-null listener must be provided.');
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
