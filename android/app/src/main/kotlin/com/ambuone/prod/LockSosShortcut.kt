package com.ambuone.prod

import android.content.Context
import android.content.Intent
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.graphics.drawable.Icon
import android.os.Build

object LockSosShortcut {

    fun request(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            val shortcutManager =
                context.getSystemService(ShortcutManager::class.java)

            if (shortcutManager.isRequestPinShortcutSupported) {

                val intent = Intent(context, LockScreenActivity::class.java)
                intent.action = Intent.ACTION_VIEW

                val shortcut = ShortcutInfo.Builder(context, "lock_sos")
                    .setShortLabel("SOS")
                    .setLongLabel("Emergency SOS")
                    .setIcon(
                        Icon.createWithResource(
                            context,
                            R.mipmap.ic_launcher
                        )
                    )
                    .setIntent(intent)
                    .build()

                shortcutManager.requestPinShortcut(shortcut, null)
            }
        }
    }
}
