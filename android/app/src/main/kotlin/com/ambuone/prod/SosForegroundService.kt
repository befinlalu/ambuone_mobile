package com.ambuone.prod

import android.app.*
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import android.graphics.BitmapFactory
import android.os.Handler
import android.os.Looper
import android.util.Log

class SosForegroundService : Service() {

    companion object {
        const val CHANNEL_ID = "sos_foreground_channel"
        const val NOTIFICATION_ID = 999
        private const val PREF_NAME = "SosPrefs"
        private const val KEY_IS_ENABLED = "is_sos_enabled"

        // Helper to set state
        fun setServiceEnabled(context: Context, enabled: Boolean) {
            val prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
            prefs.edit().putBoolean(KEY_IS_ENABLED, enabled).apply()
        }

        // Helper to check state
        fun isServiceEnabled(context: Context): Boolean {
            val prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
            return prefs.getBoolean(KEY_IS_ENABLED, false)
        }
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        handler.post(heartbeat)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        setServiceEnabled(this, true)

        val lockIntent = Intent(this, LockScreenActivity::class.java)
        lockIntent.flags =
            Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP

        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            lockIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val deleteIntent = Intent(this, SosNotificationDismissedReceiver::class.java)
        val deletePendingIntent = PendingIntent.getBroadcast(
            this,
            0,
            deleteIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )


        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setLargeIcon(
                BitmapFactory.decodeResource(resources, R.mipmap.ic_launcher)
            )
            .setContentTitle("AmbuOne Emergency SOS Active")
            .setContentText("Tap to open SOS screen")
            .setCategory(NotificationCompat.CATEGORY_CALL)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setOngoing(true)
            .setAutoCancel(false)
            .setOnlyAlertOnce(true)
            .setContentIntent(pendingIntent)
            .setDeleteIntent(deletePendingIntent)
            .build()

        startForeground(NOTIFICATION_ID, notification)

        return START_STICKY
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        Log.d("SosService", "Task Removed - Restarting")
        
        if (isServiceEnabled(this)) {
            val restartIntent = Intent(applicationContext, SosRestartReceiver::class.java)
            sendBroadcast(restartIntent)
        }
        
        super.onTaskRemoved(rootIntent)
    }

    override fun onDestroy() {
        handler.removeCallbacks(heartbeat)
        stopForeground(true)
        
        // Only restart if the USER wants it enabled
        if (isServiceEnabled(this)) {
            val restartIntent = Intent(this, SosRestartReceiver::class.java)
            sendBroadcast(restartIntent)
        }
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Emergency SOS",
                NotificationManager.IMPORTANCE_HIGH
            )
            channel.lockscreenVisibility =
                NotificationCompat.VISIBILITY_PUBLIC

            val manager =
                getSystemService(Context.NOTIFICATION_SERVICE)
                        as NotificationManager

            manager.createNotificationChannel(channel)
        }
    }

    private val handler = Handler(Looper.getMainLooper())
        private val heartbeat = object : Runnable {
            override fun run() {
                handler.postDelayed(this, 15 * 60 * 1000)
        }
    }
}
