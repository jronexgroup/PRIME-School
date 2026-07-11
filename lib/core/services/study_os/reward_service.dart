import 'package:hive/hive.dart';
import '../../models/reward.dart';
import '../../constants/achievement_definitions.dart';
import '../../models/study_session.dart';

class RewardService {
  static const _boxName = 'user_reward';
  late Box _box;
  UserReward _reward = UserReward();
  UserReward get reward => _reward;

  final List<String> _newlyUnlocked = [];
  List<String> get newlyUnlocked => _newlyUnlocked;

  Future<void> initialize() async {
    _box = await Hive.openBox(_boxName);
    final saved = _box.get('reward') as Map<String, dynamic>?;
    if (saved != null) {
      _reward = UserReward.fromJson(saved);
    }
  }

  Future<void> _save() async {
    await _box.put('reward', _reward.toJson());
  }

  int calculateSessionXp(StudySession session) {
    int xp = session.actualDurationSeconds ~/ 60;  // 1 XP per minute
    if (session.completed) xp += 10;  // Completion bonus
    if (session.distractionCount == 0) xp += 15;  // Laser focus bonus
    if (session.faceDownBonus) xp += 20;  // Face-down bonus
    xp += session.pomodoroCycles * 5;  // 5 XP per pomodoro cycle
    return xp;
  }

  Future<void> rewardSession(StudySession session) async {
    _newlyUnlocked.clear();
    final xp = calculateSessionXp(session);
    session.xpEarned = xp;
    _reward.addXp(xp);
    await _updateStreak(session.startedAt);
    await _checkAchievements();
    await _save();
  }

  Future<void> _updateStreak(DateTime studyDate) async {
    final today = DateTime.now();
    final lastDate = _reward.lastStudyDate;

    if (lastDate == null) {
      _reward.streak = 1;
    } else {
      final diff = today.difference(lastDate).inDays;
      if (diff == 1) {
        _reward.streak++;
      } else if (diff > 1) {
        _reward.streak = 1;
      }
      // diff == 0: same day, don't change streak
    }
    _reward.lastStudyDate = today;
  }

  Future<void> _checkAchievements() async {
    for (final achievement in AchievementDefinitions.all) {
      if (_reward.unlockedAchievements.contains(achievement.id)) continue;

      dynamic ctx;
      if (achievement.id.contains('sessions') || achievement.id == 'first_session') {
        ctx = _getContextValue('totalSessions');
      } else if (achievement.id.contains('hours') || achievement.id.contains('minutes')) {
        ctx = _getContextValue('totalMinutes');
      } else if (achievement.id.contains('no_distractions') || achievement.id.contains('laser')) {
        ctx = _getContextValue('cleanSessions');
      } else if (achievement.id.contains('pomodoro')) {
        ctx = _getContextValue('totalPomodoros');
      } else if (achievement.id.contains('face_down')) {
        ctx = _getContextValue('faceDownCount');
      }

      if (achievement.isUnlocked(_reward, ctx)) {
        _reward.unlockedAchievements.add(achievement.id);
        _reward.xp += achievement.xpReward;
        _reward.coins += achievement.coinReward;
        _newlyUnlocked.add(achievement.id);
      }
    }
  }

  int _getContextValue(String key) {
    // These are set externally before checking
    return 0; // Default fallback
  }

  void setContextValue(String key, int value) {
    // Store context values for achievement checking
    _box.put('ctx_$key', value);
  }

  int getContextValue(String key) {
    return _box.get('ctx_$key', defaultValue: 0) as int;
  }

  bool hasAchievement(String id) =>
      _reward.unlockedAchievements.contains(id);

  bool hasBadge(String id) =>
      _reward.unlockedBadges.contains(id);

  Future<void> unlockBadge(String badgeId) async {
    if (!_reward.unlockedBadges.contains(badgeId)) {
      _reward.unlockedBadges.add(badgeId);
      await _save();
    }
  }

  void dispose() {
    _box.close();
  }
}
