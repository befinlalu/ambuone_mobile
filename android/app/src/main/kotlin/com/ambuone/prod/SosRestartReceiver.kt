package com.ambuone.prod

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log

class SosRestartReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        // CHECK: Did the user actually want this running?
        if (!SosForegroundService.isServiceEnabled(context)) {
            Log.d("SosRestartReceiver", "User disabled SOS. Not restarting.")
            return
        }

        Log.d("SosRestartReceiver", "Restarting SOS Service from Watchdog")
        val serviceIntent = Intent(context, SosForegroundService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(serviceIntent)
        } else {
            context.startService(serviceIntent)
        }
    }
}