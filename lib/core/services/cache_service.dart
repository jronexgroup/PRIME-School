import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  static const String _topicsBox = 'topics_cache';
  static const String _audioBox = 'audio_cache';
  static const String _settingsBox = 'settings_cache';

  Future<void> initialize() async {
    await Hive.initFlutter();

    await Hive.openBox(_topicsBox);
    await Hive.openBox(_audioBox);
    await Hive.openBox(_settingsBox);
  }

  // Topic Content Cache
  Future<void> cacheTopicContent(String topicId, Map<String, dynamic> content) async {
    final box = Hive.box(_topicsBox);
    await box.put(topicId, content);
  }

  Map<String, dynamic>? getTopicContent(String topicId) {
    final box = Hive.box(_topicsBox);
    return box.get(topicId);
  }

  Future<void> removeTopicCache(String topicId) async {
    final box = Hive.box(_topicsBox);
    await box.delete(topicId);
  }

  // Audio Cache
  Future<void> cacheAudioPath(String topicId, String path) async {
    final box = Hive.box(_audioBox);
    await box.put(topicId, path);
  }

  String? getAudioPath(String topicId) {
    final box = Hive.box(_audioBox);
    return box.get(topicId);
  }

  // Settings Cache
  Future<void> cacheSetting(String key, dynamic value) async {
    final box = Hive.box(_settingsBox);
    await box.put(key, value);
  }

  dynamic getSetting(String key) {
    final box = Hive.box(_settingsBox);
    return box.get(key);
  }

  // Storage Info
  int getTopicCacheCount() {
    return Hive.box(_topicsBox).length;
  }

  int getAudioCacheCount() {
    return Hive.box(_audioBox).length;
  }

  Future<void> clearAllCache() async {
    await Hive.box(_topicsBox).clear();
    await Hive.box(_audioBox).clear();
  }

  Future<void> clearAudioCache() async {
    await Hive.box(_audioBox).clear();
  }
}
