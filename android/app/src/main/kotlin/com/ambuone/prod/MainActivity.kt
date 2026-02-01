package com.ambuone.prod

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity : FlutterActivity() {

    private val CHANNEL = "lock_sos"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {

                "startSosService" -> {
                    Log.d("SOS_FLOW", "startSosService received in MainActivity")
                    val intent = Intent(this, SosForegroundService::class.java)
                    startForegroundService(intent)
                    result.success(true)
                }

                "stopSosService" -> {
                    // 1. Tell the system we are stopping intentionally
                    SosForegroundService.setServiceEnabled(this, false)

                    // 2. Actually stop the service
                    val intent = Intent(this, SosForegroundService::class.java)
                    stopService(intent)
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }
    }
}

