package com.ambuone.prod

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class SosNotificationDismissedReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent?) {
        Log.d("SOS_FLOW", "SOS notification dismissed")

        if (SosForegroundService.shouldRestart) {
            val restartIntent =
                Intent(context, SosForegroundService::class.java)
            context.startService(restartIntent)
        }
    }
}
