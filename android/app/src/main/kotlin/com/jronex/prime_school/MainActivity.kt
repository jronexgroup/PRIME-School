package com.jronex.prime_school

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.os.Build
import android.view.View
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val STUDY_MODE_CHANNEL = "com.jronex.prime_school/study_mode"
    private val APP_BLOCKER_CHANNEL = "com.jronex.prime_school/app_blocker"
    private val USAGE_STATS_CHANNEL = "com.jronex.prime_school/usage_stats"
    private val PERMISSION_CHANNEL = "com.jronex.prime_school/permissions"
    private val OCR_CHANNEL = "com.jronex.prime_school/ocr"

    private var _lockTaskEngaged = false
    private var _flutterEngine: FlutterEngine? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        _flutterEngine = flutterEngine

        // Study Mode (Lock Task, Immersive Mode)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, STUDY_MODE_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startLockTask" -> {
                        try {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                                startLockTask()
                                _lockTaskEngaged = true
                            }
                            result.success(true)
                        } catch (e: Exception) {
                            _lockTaskEngaged = false
                            result.success(false)
                        }
                    }
                    "stopLockTask" -> {
                        try {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                                stopLockTask()
                            }
                            _lockTaskEngaged = false
                            result.success(true)
                        } catch (e: Exception) {
                            result.success(false)
                        }
                    }
                    "isInLockTaskMode" -> {
                        val isLocked = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            val am = getSystemService(Context.ACTIVITY_SERVICE) as android.app.ActivityManager
                            am.lockTaskModeState != android.app.ActivityManager.LOCK_TASK_MODE_NONE
                        } else {
                            false
                        }
                        result.success(isLocked)
                    }
                    "reengageLockTask" -> {
                        try {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP && _lockTaskEngaged) {
                                startLockTask()
                            }
                            result.success(true)
                        } catch (e: Exception) {
                            result.success(false)
                        }
                    }
                    "setImmersiveMode" -> {
                        val enabled = call.argument<Boolean>("enabled") ?: false
                        if (enabled) {
                            window.decorView.systemUiVisibility = (
                                View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                                or View.SYSTEM_UI_FLAG_FULLSCREEN
                                or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                                or View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                                or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                                or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                            )
                        } else {
                            window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_VISIBLE
                        }
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }

        // App Blocker (Accessibility-based detection)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, APP_BLOCKER_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getForegroundApp" -> {
                        result.success(StudyAccessibilityService.lastForegroundPackage)
                    }
                    "goHome" -> {
                        try {
                            val intent = android.content.Intent(android.content.Intent.ACTION_MAIN)
                            intent.addCategory(android.content.Intent.CATEGORY_HOME)
                            intent.flags = android.content.Intent.FLAG_ACTIVITY_NEW_TASK
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            result.success(false)
                        }
                    }
                    "launchApp" -> {
                        val packageName = call.argument<String>("packageName")
                        if (packageName != null) {
                            try {
                                val intent = packageManager.getLaunchIntentForPackage(packageName)
                                if (intent != null) {
                                    startActivity(intent)
                                    result.success(true)
                                } else {
                                    result.success(false)
                                }
                            } catch (e: Exception) {
                                result.success(false)
                            }
                        } else {
                            result.success(false)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        // Usage Stats
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, USAGE_STATS_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getUsageStats" -> {
                        val days = call.argument<Int>("days") ?: 7
                        try {
                            val usm = getSystemService(Context.USAGE_STATS_SERVICE) as android.app.usage.UsageStatsManager
                            val cal = java.util.Calendar.getInstance()
                            cal.add(java.util.Calendar.DAY_OF_YEAR, -days)
                            val stats = usm.queryUsageStats(
                                android.app.usage.UsageStatsManager.INTERVAL_DAILY,
                                cal.timeInMillis,
                                System.currentTimeMillis()
                            )
                            val resultMap = java.util.HashMap<String, Any>()
                            if (stats != null) {
                                for (stat in stats) {
                                    val pkg = stat.packageName ?: continue
                                    val time = stat.totalTimeInForeground
                                    if (time > 0) {
                                        resultMap[pkg] = time
                                    }
                                }
                            }
                            result.success(resultMap)
                        } catch (e: Exception) {
                            result.success(java.util.HashMap<String, Any>())
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        // Permissions
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PERMISSION_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isAccessibilityServiceEnabled" -> {
                        val enabled = StudyAccessibilityService.isRunning
                        result.success(enabled)
                    }
                    "openAccessibilitySettings" -> {
                        try {
                            startActivity(android.content.Intent(android.provider.Settings.ACTION_ACCESSIBILITY_SETTINGS))
                        } catch (_: Exception) {}
                        result.success(true)
                    }
                    "openUsageAccessSettings" -> {
                        try {
                            startActivity(android.content.Intent(android.provider.Settings.ACTION_USAGE_ACCESS_SETTINGS))
                        } catch (_: Exception) {}
                        result.success(true)
                    }
                    "openNotificationAccessSettings" -> {
                        try {
                            startActivity(android.content.Intent(android.provider.Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS))
                        } catch (_: Exception) {}
                        result.success(true)
                    }
                    "openOverlaySettings" -> {
                        try {
                            startActivity(android.content.Intent(android.provider.Settings.ACTION_MANAGE_OVERLAY_PERMISSION))
                        } catch (_: Exception) {}
                        result.success(true)
                    }
                    "hasUsageStatsPermission" -> {
                        val granted = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                            val usm = getSystemService(Context.USAGE_STATS_SERVICE) as android.app.usage.UsageStatsManager
                            val cal = java.util.Calendar.getInstance()
                            cal.add(java.util.Calendar.DAY_OF_YEAR, -1)
                            val stats = usm.queryUsageStats(
                                android.app.usage.UsageStatsManager.INTERVAL_DAILY,
                                cal.timeInMillis,
                                System.currentTimeMillis()
                            )
                            stats != null && stats.size > 0
                        } else true
                        result.success(granted)
                    }
                    "hasOverlayPermission" -> {
                        val granted = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            android.provider.Settings.canDrawOverlays(this)
                        } else true
                        result.success(granted)
                    }
                    else -> result.notImplemented()
                }
            }

        // OCR
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, OCR_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "recognizeText" -> {
                        val imagePath = call.argument<String>("imagePath")
                        if (imagePath != null) {
                            try {
                                val text = OcrHelper.recognizeText(this, imagePath)
                                result.success(text)
                            } catch (e: Exception) {
                                result.success("Error: ${e.message}")
                            }
                        } else {
                            result.success(null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        // User pressed Home or Recents during lock task mode
        if (_lockTaskEngaged) {
            // Re-engage lock task to bring user back
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    startLockTask()
                }
            } catch (_: Exception) {}

            // Notify Flutter side about the exit attempt
            _flutterEngine?.dartExecutor?.binaryMessenger?.let {
                MethodChannel(it, STUDY_MODE_CHANNEL).invokeMethod("onUserLeaveAttempt", null)
            }
        }
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        // Re-engage lock task when window regains focus
        if (hasFocus && _lockTaskEngaged) {
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    startLockTask()
                }
            } catch (_: Exception) {}
        }
    }
}
