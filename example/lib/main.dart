import 'package:flutter/material.dart';

import 'package:screenshot_observer/screenshot_observer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _screenshotState = 'Initialize...';

  @override
  void initState() {
    super.initState();
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
