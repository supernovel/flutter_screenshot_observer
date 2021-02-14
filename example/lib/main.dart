import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:screenshot_observer/screenshot_observer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _screenshotState = 'Initialize...';

  @override
  void initState() {
    super.initState();
    ScreenshotObserver.initialize();
    ScreenshotObserver.addListener(() {
      setState(() {
        _screenshotState = 'On screenshot.';
      });
    });

    _screenshotState = 'Listening...';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Screenshot observer example app'),
        ),
        body: Center(
          child: Text(_screenshotState),
        ),
      ),
    );
  }
}
