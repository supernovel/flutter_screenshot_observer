# screenshot_observer

Handle screenshot event.

## getting started

First, add the `screenshot_observer` package to your pubspec dependencies

Initialize observer

```dart
ScreenshotObserver.initialize();
```

Add screenshot event listener

```dart
ScreenshotObserver.addListener(() {
   // TODO. handler
});
```

Dispose resource

```dart
ScreenshotObserver.dispose();
```

