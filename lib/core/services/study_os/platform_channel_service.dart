import 'package:flutter/services.dart';

class PlatformChannelService {
  static const _studyModeChannel = MethodChannel('com.jronex.prime_school/study_mode');
  static const _appBlockerChannel = MethodChannel('com.jronex.prime_school/app_blocker');
  static const _usageStatsChannel = MethodChannel('com.jronex.prime_school/usage_stats');
  static const _permissionChannel = MethodChannel('com.jronex.prime_school/permissions');

  // --- Study Mode ---

  Future<bool> startLockTask() async {
    try {
      return await _studyModeChannel.invokeMethod('startLockTask') as bool? ?? false;
    } catch (_) { return false; }
  }

  Future<bool> stopLockTask() async {
    try {
      return await _studyModeChannel.invokeMethod('stopLockTask') as bool? ?? false;
    } catch (_) { return false; }
  }

  Future<bool> isInLockTaskMode() async {
    try {
      return await _studyModeChannel.invokeMethod('isInLockTaskMode') as bool? ?? false;
    } catch (_) { return false; }
  }

  Future<bool> setImmersiveMode(bool enabled) async {
    try {
      return await _studyModeChannel.invokeMethod('setImmersiveMode', {'enabled': enabled}) as bool? ?? false;
    } catch (_) { return false; }
  }

  // --- App Blocker ---

  Future<String?> getForegroundApp() async {
    try {
      return await _appBlockerChannel.invokeMethod<String>('getForegroundApp');
    } catch (_) { return null; }
  }

  Future<bool> goHome() async {
    try {
      return await _appBlockerChannel.invokeMethod('goHome') as bool? ?? false;
    } catch (_) { return false; }
  }

  Future<bool> launchApp(String packageName) async {
    try {
      return await _appBlockerChannel.invokeMethod('launchApp', {'packageName': packageName}) as bool? ?? false;
    } catch (_) { return false; }
  }

  // --- Usage Stats ---

  Future<Map<String, dynamic>> getUsageStats(int days) async {
    try {
      return await _usageStatsChannel.invokeMethod('getUsageStats', {'days': days}) as Map<String, dynamic>? ?? {};
    } catch (_) { return {}; }
  }

  // --- Permissions ---

  Future<bool> isAccessibilityServiceEnabled() async {
    try {
      return await _permissionChannel.invokeMethod('isAccessibilityServiceEnabled') as bool? ?? false;
    } catch (_) { return false; }
  }

  Future<void> openAccessibilitySettings() async {
    try { await _permissionChannel.invokeMethod('openAccessibilitySettings'); } catch (_) {}
  }

  Future<void> openUsageAccessSettings() async {
    try { await _permissionChannel.invokeMethod('openUsageAccessSettings'); } catch (_) {}
  }

  Future<void> openNotificationAccessSettings() async {
    try { await _permissionChannel.invokeMethod('openNotificationAccessSettings'); } catch (_) {}
  }

  Future<void> openOverlaySettings() async {
    try { await _permissionChannel.invokeMethod('openOverlaySettings'); } catch (_) {}
  }

  Future<bool> hasUsageStatsPermission() async {
    try { return await _permissionChannel.invokeMethod('hasUsageStatsPermission') as bool? ?? false; } catch (_) { return false; }
  }

  Future<bool> hasOverlayPermission() async {
    try { return await _permissionChannel.invokeMethod('hasOverlayPermission') as bool? ?? false; } catch (_) { return false; }
  }
}
