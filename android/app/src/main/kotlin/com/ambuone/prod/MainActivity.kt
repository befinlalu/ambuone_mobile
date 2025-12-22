package com.ambuone.prod

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "lock_sos"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {

                "enableLockSos" -> {
                    LockSosShortcut.request(this)
                    result.success(true)
                }

                "showSosNotification" -> {
                    SosNotificationHelper.show(this)
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }
    }
}
