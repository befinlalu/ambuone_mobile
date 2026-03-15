package com.ambuone.prod

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import android.text.TextUtils
import android.util.Log
import android.view.KeyEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "lock_sos"

    // In-app triple press state (screen on, app in foreground/background)
    // AccessibilityService handles screen-off and app-closed cases
    private var volumeDownPressCount = 0
    private var lastVolumeDownTime = 0L
    private val VOLUME_PRESS_TIMEOUT = 2000L

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {

                // ── SOS service ───────────────────────────────────────────
                "startSosService" -> {
                    Log.d("SOS_FLOW", "startSosService received")
                    // Use shared constant — prevents pref name mismatch bug
                    getSharedPreferences(SosForegroundService.PREF_NAME, MODE_PRIVATE)
                        .edit()
                        .putBoolean(SosForegroundService.KEY_SERVICE_ENABLED, true)
                        .apply()
                    startForegroundService(
                        Intent(this, SosForegroundService::class.java)
                    )
                    result.success(true)
                }

                "stopSosService" -> {
                    SosForegroundService.setServiceEnabled(this, false)
                    getSharedPreferences(SosForegroundService.PREF_NAME, MODE_PRIVATE)
                        .edit()
                        .putBoolean(SosForegroundService.KEY_SERVICE_ENABLED, false)
                        .putBoolean(SosForegroundService.KEY_VOLUME_ENABLED, false)
                        .apply()
                    stopService(Intent(this, SosForegroundService::class.java))
                    result.success(true)
                }

                // ── Battery optimization ──────────────────────────────────
                "requestBatteryOptimization" -> {
                    val pm = getSystemService(PowerManager::class.java)
                    if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                        startActivity(
                            Intent(
                                Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
                            ).apply {
                                data = Uri.parse("package:$packageName")
                            }
                        )
                    }
                    result.success(true)
                }

                // ── Volume button toggle ──────────────────────────────────
                "setVolumeButtonEnabled" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    getSharedPreferences(SosForegroundService.PREF_NAME, MODE_PRIVATE)
                        .edit()
                        .putBoolean(SosForegroundService.KEY_VOLUME_ENABLED, enabled)
                        .apply()
                    Log.d("SOS_FLOW", "Volume button enabled: $enabled")
                    result.success(true)
                }

                // ── Home screen widget ────────────────────────────────────
                "pinSosWidget" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        val appWidgetManager =
                            getSystemService(AppWidgetManager::class.java)
                        val provider =
                            ComponentName(this, SosWidgetProvider::class.java)

                        if (appWidgetManager.isRequestPinAppWidgetSupported) {
                            val successCallback = PendingIntent.getBroadcast(
                                this, 0,
                                Intent(this, SosWidgetProvider::class.java),
                                PendingIntent.FLAG_UPDATE_CURRENT or
                                        PendingIntent.FLAG_IMMUTABLE
                            )
                            appWidgetManager.requestPinAppWidget(
                                provider, null, successCallback
                            )
                            result.success(true)
                        } else {
                            result.error(
                                "NOT_SUPPORTED",
                                "Pinning not supported on this launcher",
                                null
                            )
                        }
                    } else {
                        result.error(
                            "VERSION_LOW",
                            "Requires Android 8.0+",
                            null
                        )
                    }
                }

                // ── Accessibility service check ────────────────────────────
                "isAccessibilityServiceEnabled" -> {
                    result.success(isAccessibilityServiceEnabled(this))
                }

                "openAccessibilitySettings" -> {
                    startActivity(
                        Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS).apply {
                            flags = Intent.FLAG_ACTIVITY_NEW_TASK
                        }
                    )
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }
    }

    // ── In-app volume triple press ────────────────────────────────────────────
    // Fires when screen is ON and MainActivity is active/backgrounded.
    // Does NOT fire screen-off — that is handled by SosAccessibilityService.
    override fun dispatchKeyEvent(event: KeyEvent): Boolean {
        val prefs = getSharedPreferences(SosForegroundService.PREF_NAME, MODE_PRIVATE)
        val volumeEnabled = prefs.getBoolean(SosForegroundService.KEY_VOLUME_ENABLED, false)
        val sosEnabled = prefs.getBoolean(SosForegroundService.KEY_SERVICE_ENABLED, false)

        if (volumeEnabled && sosEnabled &&
            event.keyCode == KeyEvent.KEYCODE_VOLUME_DOWN &&
            event.action == KeyEvent.ACTION_DOWN
        ) {
            val now = System.currentTimeMillis()
            if (now - lastVolumeDownTime > VOLUME_PRESS_TIMEOUT) {
                volumeDownPressCount = 0
            }
            lastVolumeDownTime = now
            volumeDownPressCount++

            Log.d("SOS_FLOW", "Volume down #$volumeDownPressCount")

            if (volumeDownPressCount >= 3) {
                volumeDownPressCount = 0
                Log.d("SOS_FLOW", "Triple press — launching SOS")
                startActivity(
                    Intent(this, LockScreenActivity::class.java).apply {
                        addFlags(
                            Intent.FLAG_ACTIVITY_NEW_TASK or
                            Intent.FLAG_ACTIVITY_CLEAR_TOP
                        )
                    }
                )
                return true
            }
            // Consume press 1 & 2 to prevent volume bar from animating
            return true
        }

        return super.dispatchKeyEvent(event)
    }

    // ── Accessibility check ───────────────────────────────────────────────────
    // Checks the system's enabled services list for our specific service.
    // TextUtils.SimpleStringSplitter is more reliable than contains() because
    // it handles cases where another service name contains our package name.
    private fun isAccessibilityServiceEnabled(context: Context): Boolean {
        val service =
            "${context.packageName}/${SosAccessibilityService::class.java.canonicalName}"
        val enabledServices = Settings.Secure.getString(
            context.contentResolver,
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
        ) ?: return false

        val splitter = TextUtils.SimpleStringSplitter(':')
        splitter.setString(enabledServices)
        while (splitter.hasNext()) {
            if (splitter.next().equals(service, ignoreCase = true)) return true
        }
        return false
    }
}