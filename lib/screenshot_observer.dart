import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenshotObserver {
  static const MethodChannel _channel =
      const MethodChannel('screenshot_observer');
  static VoidCallback? _listener;
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (!_initialized) {
      await requestPermission();
      await _channel.invokeMethod('initialize');
      _channel.setMethodCallHandler(_handleMethod);
      _initialized = true;
    }
  }

  static Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      final isGranted = await Permission.storage.isGranted;
      if (!isGranted) {
        await Permission.storage.request();
      }
    }
  }

  static void addListener(VoidCallback listener) async {
    if (!_initialized) {
      await initialize();
    }
    _listener = listener;
  }

  static Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onScreenshot':
        _listener?.call();
        _listener = null;
        break;
      default:
        throw ('method not defined');
    }
  }

  /// Remove listeners.
  static Future<void> dispose() async {
    _listener = null;
    await _channel.invokeMethod('dispose');
  }
}
