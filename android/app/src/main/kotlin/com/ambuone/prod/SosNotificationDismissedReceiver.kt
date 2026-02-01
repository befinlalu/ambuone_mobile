package com.ambuone.prod

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class SosNotificationDismissedReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        Log.d("SosDismissReceiver", "Notification dismissed by user")

        // Check the new "Service Enabled" flag instead of the old 'shouldRestart' variable
        if (SosForegroundService.isServiceEnabled(context)) {
            Log.d("SosDismissReceiver", "SOS is supposed to be ON. Triggering restart.")
            
            // Trigger the Watchdog to restart the service
            val restartIntent = Intent(context, SosRestartReceiver::class.java)
            context.sendBroadcast(restartIntent)
        } else {
             Log.d("SosDismissReceiver", "SOS is OFF. Doing nothing.")
        }
    }
}