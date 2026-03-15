package com.ambuone.prod

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.Intent
import android.os.PowerManager
import android.util.Log
import android.view.KeyEvent
import android.view.accessibility.AccessibilityEvent

class SosAccessibilityService : AccessibilityService() {

    private var clickCount = 0
    private var firstClickTime: Long = 0
    private val PRESS_TIMEOUT = 2000L

    // ── FIX 1: onServiceConnected ─────────────────────────────────────────────
    // This is the most critical fix. Without it, Android never sets
    // FLAG_REQUEST_FILTER_KEY_EVENTS, so key events are only delivered
    // opportunistically (screen on, app active). Setting it here guarantees
    // delivery even when the screen is off or the app is closed.
    override fun onServiceConnected() {
        super.onServiceConnected()
        val info = AccessibilityServiceInfo().apply {
            eventTypes = AccessibilityEvent.TYPES_ALL_MASK
            feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
            flags = AccessibilityServiceInfo.FLAG_REQUEST_FILTER_KEY_EVENTS
            notificationTimeout = 0
        }
        serviceInfo = info
        Log.d("SosAccessibility", "Service connected — key filter active")
    }

    override fun onKeyEvent(event: KeyEvent): Boolean {
        if (event.keyCode == KeyEvent.KEYCODE_VOLUME_DOWN &&
            event.action == KeyEvent.ACTION_DOWN
        ) {
            // Check if volume trigger is enabled in prefs
            val prefs = getSharedPreferences(
                SosForegroundService.PREF_NAME, MODE_PRIVATE
            )
            if (!prefs.getBoolean(SosForegroundService.KEY_VOLUME_ENABLED, false)) {
                // Feature disabled — pass event through normally
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
                launchSosPage()
            }

            // ── FIX 2: return true ────────────────────────────────────────
            // Consuming the event prevents the volume bar from showing and
            // stops some OEMs from re-routing the event to their own handlers
            // (which can interfere with delivery on the next press).
            return true
        }

        return false
    }

    private fun launchSosPage() {
        // Wake the screen first if it is off — otherwise startActivity
        // is silently dropped on some OEMs (Xiaomi, OPPO) when the
        // display is completely off.
        val pm = getSystemService(PowerManager::class.java)
        if (!pm.isInteractive) {
            @Suppress("DEPRECATION")
            val wl = pm.newWakeLock(
                PowerManager.SCREEN_BRIGHT_WAKE_LOCK or
                PowerManager.ACQUIRE_CAUSES_WAKEUP or
                PowerManager.ON_AFTER_RELEASE,
                "ambuone:sos_wake"
            )
            wl.acquire(3000L) // hold for 3s — enough for activity to launch
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

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {}
    override fun onInterrupt() {}
}