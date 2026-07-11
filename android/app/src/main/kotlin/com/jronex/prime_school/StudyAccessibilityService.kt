package com.jronex.prime_school

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.Intent
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class StudyAccessibilityService : AccessibilityService() {
    companion object {
        var isRunning = false
            private set
        var lastForegroundPackage: String? = null
            private set

        // Blocked app package names
        val blockedPackages = setOf(
            "com.instagram.android",
            "com.facebook.katana",
            "com.facebook.orca",
            "com.google.android.youtube",
            "com.android.chrome",
            "com.android.vending",
            "com.twitter.android",
            "com.reddit.frontpage",
            "com.snapchat.android",
            "com.zhiliaoapp.musically",
            "com.spotify.music",
            "com.tencent.ig",
            "com.mojang.minecraftpe",
            "com.supercell.clashofclans",
            "com.supercell.brawlstars",
            "com.roblox.client"
        )
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        isRunning = true
        Log.d("StudyOS", "AccessibilityService connected")

        val info = AccessibilityServiceInfo().apply {
            eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED or
                         AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED
            feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
            notificationTimeout = 100
            flags = AccessibilityServiceInfo.FLAG_REPORT_VIEW_IDS
        }
        serviceInfo = info
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        when (event.eventType) {
            AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED -> {
                val packageName = event.packageName?.toString()
                if (packageName != null && packageName != "com.jronex.prime_school") {
                    lastForegroundPackage = packageName

                    // Check if this is a blocked app
                    if (blockedPackages.contains(packageName)) {
                        Log.d("StudyOS", "Blocked app detected: $packageName")
                        // Navigation to home will be triggered from Flutter side
                        // to avoid ANR from accessibility service
                    }
                }
            }
        }
    }

    override fun onInterrupt() {
        Log.d("StudyOS", "AccessibilityService interrupted")
    }

    override fun onDestroy() {
        super.onDestroy()
        isRunning = false
        Log.d("StudyOS", "AccessibilityService destroyed")
    }
}
