package com.ambuone.prod

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.view.KeyEvent
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class SosAccessibilityService : AccessibilityService() {

    private var clickCount = 0
    private var firstClickTime: Long = 0

    override fun onKeyEvent(event: KeyEvent): Boolean {
        val keyCode = event.keyCode
        val action = event.action

        // We only care about the Volume Down button being pressed down
        if (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN && action == KeyEvent.ACTION_DOWN) {
            val currentTime = System.currentTimeMillis()

            // If this is the first click, or if the 2-second window has expired, reset
            if (clickCount == 0 || (currentTime - firstClickTime) > 2000) {
                clickCount = 1
                firstClickTime = currentTime
                Log.d("SosAccessibility", "First click detected")
            } else {
                clickCount++
                Log.d("SosAccessibility", "Click count: $clickCount")
            }

            // Check if we hit the goal
            if (clickCount == 3) {
                Log.d("SosAccessibility", "Pattern Matched! Launching SOS")
                launchSosPage()
                clickCount = 0 // Reset after trigger
            }
        }

        // Return false to allow the system to still adjust volume 
        // (or true if you want to "hijack" the button completely)
        return super.onKeyEvent(event)
    }

    private fun launchSosPage() {
        val intent = Intent(this, LockScreenActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or 
                    Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        startActivity(intent)
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {}
    override fun onInterrupt() {}
}