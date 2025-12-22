package com.ambuone.prod

import android.app.KeyguardManager
import android.content.Context
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class LockScreenActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Show over lock screen
        setShowWhenLocked(true)
        setTurnScreenOn(true)

        val keyguardManager =
            getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager

        keyguardManager.requestDismissKeyguard(this, null)
    }

    override fun getInitialRoute(): String {
        return "/lock-sos"
    }
}
