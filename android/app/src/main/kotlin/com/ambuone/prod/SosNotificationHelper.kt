package com.ambuone.prod

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat

object SosNotificationHelper {

    private const val CHANNEL_ID = "sos_channel"

    fun show(context: Context) {
        val intent = Intent(context, LockScreenActivity::class.java)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                       Intent.FLAG_ACTIVITY_CLEAR_TOP

        val pendingIntent = PendingIntent.getActivity(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val manager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Emergency SOS",
                NotificationManager.IMPORTANCE_HIGH
            )
            channel.lockscreenVisibility =
                NotificationCompat.VISIBILITY_PUBLIC
            manager.createNotificationChannel(channel)
        }

        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("Emergency SOS")
            .setContentText("Tap to open SOS")
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_CALL)
            .setFullScreenIntent(pendingIntent, true) // 🔥 KEY
            .setAutoCancel(true)
            .build()

        manager.notify(101, notification)
    }
}
