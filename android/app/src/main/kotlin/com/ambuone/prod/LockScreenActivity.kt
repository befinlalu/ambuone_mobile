package com.ambuone.prod

import android.app.KeyguardManager
import android.content.Context
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class LockScreenActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setShowWhenLocked(true)     // show over lock
        setTurnScreenOn(true)       // wake screen

    }

    override fun getInitialRoute(): String {
        return "/lock-sos"
    }
}

