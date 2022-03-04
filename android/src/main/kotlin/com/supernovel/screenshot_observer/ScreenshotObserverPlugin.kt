package com.supernovel.screenshot_observer

import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent
import androidx.lifecycle.ProcessLifecycleOwner
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


class ScreenshotObserverPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, LifecycleObserver {
  private var channel: MethodChannel? = null
  private var handler: Handler? = null
  private var context: Context? = null
  private var screenshotObserver: ScreenshotObserver? = null

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    //Log.d(TAG, "onMethodCall: ");
    when {
        call.method.equals("initialize") -> {
          handler = Handler(Looper.getMainLooper())
          screenshotObserver = context?.contentResolver?.let {
            ScreenshotObserver(it, object : ScreenshotObserver.Listener {
              override fun onScreenshot(path: String?) {
                channel?.invokeMethod("onScreenshot", null)
              }
            })
          }
          screenshotObserver?.observe()
          result.success("initialize")
        }
        call.method.equals("dispose") -> {
          screenshotObserver?.unobserve()
          screenshotObserver = null
          result.success("dispose")
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.getBinaryMessenger(), "screenshot_observer")
    channel?.setMethodCallHandler(this)
    context = binding.getApplicationContext()
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel?.setMethodCallHandler(null)
  }

  @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
  fun onAppBackgrounded() {
    if (screenshotObserver != null) {
      screenshotObserver?.unobserve()
    }
  }

  @OnLifecycleEvent(Lifecycle.Event.ON_START)
  fun onAppForegrounded() {
    if (screenshotObserver != null) {
      screenshotObserver?.observe()
    }
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    ProcessLifecycleOwner.get().lifecycle.addObserver(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {}
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}
  override fun onDetachedFromActivity() {
    ProcessLifecycleOwner.get().lifecycle.removeObserver(this)
  }
}
