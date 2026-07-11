package com.jronex.prime_school

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log

class StudyNotificationListener : NotificationListenerService() {
    companion object {
        var isConnected = false
            private set

        private val distractingPackages = setOf(
            "com.instagram.android",
            "com.facebook.katana",
            "com.twitter.android",
            "com.reddit.frontpage",
            "com.snapchat.android",
            "com.zhiliaoapp.musically",
            "com.tencent.ig",
            "com.mojang.minecraftpe",
            "com.supercell.clashofclans",
            "com.supercell.brawlstars"
        )
    }

    override fun onListenerConnected() {
        super.onListenerConnected()
        isConnected = true
        Log.d("StudyOS", "NotificationListener connected")
    }

    override fun onListenerDisconnected() {
        super.onListenerDisconnected()
        isConnected = false
        Log.d("StudyOS", "NotificationListener disconnected")
    }

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        if (sbn == null) return

        val packageName = sbn.packageName
        if (distractingPackages.contains(packageName)) {
            Log.d("StudyOS", "Distracting notification from: $packageName")
            // Can cancel the notification to reduce distractions
            // cancelNotification(sbn.key)
        }
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification?) {
        // Notification was dismissed
    }
}
