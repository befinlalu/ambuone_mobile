package com.ambuone.prod

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.Context
import android.content.Intent
import android.os.*
import android.util.Log
import android.view.KeyEvent
import android.view.accessibility.AccessibilityEvent

class SosAccessibilityService : AccessibilityService() {

    private var clickCount = 0
    private var firstClickTime: Long = 0
    private val PRESS_TIMEOUT = 2000L

    // PARTIAL_WAKE_LOCK — keeps CPU running so key events are not dropped
    // when the device is in deep sleep. Without this, on Xiaomi/OPPO the
    // CPU can be in a state where it takes 300-500ms to wake up on a key
    // event, causing the first press to be missed and breaking the count.
    private var serviceWakeLock: PowerManager.WakeLock? = null

    // Keep-alive — two purposes:
    // 1. Reacquires the wakelock before it expires (every 5 min, wakelock lasts 10 min)
    // 2. Does a small amount of work (pref read) to reset OEM idle timers
    //    — MIUI and ColorOS track process activity and freeze idle processes
    private val keepAliveHandler = Handler(Looper.getMainLooper())
    private val keepAlive = object : Runnable {
        override fun run() {
            try {
                // Reacquire before expiry — wakelock set to 10min, ping every 5min
                if (serviceWakeLock?.isHeld == false) {
                    serviceWakeLock?.acquire(10 * 60 * 1000L)
                    Log.d("SosAccessibility", "WakeLock reacquired")
                }

                // Read pref — forces process activity, resets OEM idle timer
                val prefs = getSharedPreferences(
                    SosForegroundService.PREF_NAME, MODE_PRIVATE
                )
                val enabled = prefs.getBoolean(
                    SosForegroundService.KEY_VOLUME_ENABLED, false
                )
                Log.d("SosAccessibility", "Keep-alive — volume enabled: $enabled")
            } catch (e: Exception) {
                Log.e("SosAccessibility", "Keep-alive error: ${e.message}")
            }
            keepAliveHandler.postDelayed(this, 5 * 60 * 1000L)
        }
    }

    override fun onServiceConnected() {
        super.onServiceConnected()

        // Set FLAG_REQUEST_FILTER_KEY_EVENTS — critical for screen-off delivery
        val info = AccessibilityServiceInfo().apply {
            eventTypes = AccessibilityEvent.TYPES_ALL_MASK
            feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
            flags = AccessibilityServiceInfo.FLAG_REQUEST_FILTER_KEY_EVENTS
            notificationTimeout = 0
        }
        serviceInfo = info

        // Acquire wakelock with 10min timeout — keep-alive reacquires every 5min
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        serviceWakeLock = pm.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "AmbuOne::AccessibilityWakeLock"
        ).apply {
            setReferenceCounted(false) // single acquire/release, not counted
            acquire(10 * 60 * 1000L)
        }

        // Start keep-alive immediately
        keepAliveHandler.post(keepAlive)

        Log.d("SosAccessibility", "Service connected — WakeLock + keep-alive active")
    }

    override fun onKeyEvent(event: KeyEvent): Boolean {
        if (event.keyCode == KeyEvent.KEYCODE_VOLUME_DOWN &&
            event.action == KeyEvent.ACTION_DOWN
        ) {
            val prefs = getSharedPreferences(
                SosForegroundService.PREF_NAME, MODE_PRIVATE
            )
            if (!prefs.getBoolean(SosForegroundService.KEY_VOLUME_ENABLED, false)) {
                return false
            }

            val currentTime = System.currentTimeMillis()

            if (clickCount == 0 || (currentTime - firstClickTime) > PRESS_TIMEOUT) {
                clickCount = 1
                firstClickTime = currentTime
                Log.d("SosAccessibility", "Press 1")
            } else {
                clickCount++
                Log.d("SosAccessibility", "Press $clickCount")
            }

            if (clickCount >= 3) {
                Log.d("SosAccessibility", "Triple press — launching SOS")
                clickCount = 0
                triggerVibration()
                launchSosPage()
            }

            return true
        }

        return false
    }

    private fun triggerVibration() {
        try {
            val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vm = getSystemService(Context.VIBRATOR_MANAGER_SERVICE)
                        as VibratorManager
                vm.defaultVibrator
            } else {
                @Suppress("DEPRECATION")
                getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vibrator.vibrate(
                    VibrationEffect.createOneShot(
                        500, VibrationEffect.DEFAULT_AMPLITUDE
                    )
                )
            } else {
                @Suppress("DEPRECATION")
                vibrator.vibrate(500)
            }
        } catch (e: Exception) {
            Log.e("SosAccessibility", "Vibration error: ${e.message}")
        }
    }

    private fun launchSosPage() {
        val pm = getSystemService(PowerManager::class.java)

        // Only acquire screen wakelock if screen is off — no-op if already on
        if (!pm.isInteractive) {
            @Suppress("DEPRECATION")
            pm.newWakeLock(
                PowerManager.SCREEN_BRIGHT_WAKE_LOCK or
                PowerManager.ACQUIRE_CAUSES_WAKEUP or
                PowerManager.ON_AFTER_RELEASE,
                "ambuone:sos_screen_wake"
            ).acquire(3000L)
        }

        val intent = Intent(this, LockScreenActivity::class.java).apply {
            addFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or
                Intent.FLAG_ACTIVITY_CLEAR_TOP
            )
        }
        startActivity(intent)
    }

    override fun onDestroy() {
        keepAliveHandler.removeCallbacks(keepAlive)
        if (serviceWakeLock?.isHeld == true) {
            serviceWakeLock?.release()
        }
        super.onDestroy()
        Log.d("SosAccessibility", "Service destroyed — WakeLock released")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {}
    override fun onInterrupt() {}
}