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
    
    // WakeLock to keep the CPU "warm" and responsive to key events
    private var serviceWakeLock: PowerManager.WakeLock? = null

    private val keepAliveHandler = Handler(Looper.getMainLooper())
    private val keepAlive = object : Runnable {
        override fun run() {
            try {
                // Safely renew the 10-minute lock every 5 minutes to prevent Play Store battery flags
                serviceWakeLock?.acquire(10 * 60 * 1000L)
                
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
        
        // Initialize WakeLock with a 10-minute timeout
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        serviceWakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "AmbuOne::ServiceWakeLock").apply {
            setReferenceCounted(false)
            acquire(10 * 60 * 1000L) 
        }

        val info = AccessibilityServiceInfo().apply {
            eventTypes = AccessibilityEvent.TYPES_ALL_MASK
            feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
            flags = AccessibilityServiceInfo.FLAG_REQUEST_FILTER_KEY_EVENTS
            notificationTimeout = 0
        }
        serviceInfo = info
        keepAliveHandler.post(keepAlive)
        Log.d("SosAccessibility", "Service connected — WakeLock + Keep-alive active")
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

            // CRITICAL FIX: Return false so the user can still adjust their volume normally
            return false 
        }

        return false
    }

    private fun triggerVibration() {
        try {
            val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vibratorManager = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
                vibratorManager.defaultVibrator
            } else {
                @Suppress("DEPRECATION")
                getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vibrator.vibrate(VibrationEffect.createOneShot(500, VibrationEffect.DEFAULT_AMPLITUDE))
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
        
        // Force screen wake up only if it's currently off
        if (!pm.isInteractive) {
            @Suppress("DEPRECATION")
            val wl = pm.newWakeLock(
                PowerManager.SCREEN_BRIGHT_WAKE_LOCK or
                PowerManager.ACQUIRE_CAUSES_WAKEUP or
                PowerManager.ON_AFTER_RELEASE,
                "ambuone:sos_wake"
            )
            wl.acquire(3000L)
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