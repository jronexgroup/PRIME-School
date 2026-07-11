class UserReward {
  int xp;
  int coins;
  int level;
  int streak;
  DateTime? lastStudyDate;
  List<String> unlockedBadges;
  List<String> unlockedAchievements;

  UserReward({
    this.xp = 0,
    this.coins = 0,
    this.level = 1,
    this.streak = 0,
    this.lastStudyDate,
    List<String>? unlockedBadges,
    List<String>? unlockedAchievements,
  })  : unlockedBadges = unlockedBadges ?? [],
        unlockedAchievements = unlockedAchievements ?? [];

  static const xpPerLevel = 100;

  int get xpForNextLevel => level * xpPerLevel;
  int get xpProgressInLevel => xp - ((level - 1) * xpPerLevel);
  double get levelProgress => xpProgressInLevel / xpForNextLevel;

  void addXp(int amount) {
    xp += amount;
    coins += amount ~/ 10;
    while (xp >= level * xpPerLevel) {
      level++;
    }
  }

  Map<String, dynamic> toJson() => {
    'xp': xp,
    'coins': coins,
    'level': level,
    'streak': streak,
    'lastStudyDate': lastStudyDate?.toIso8601String(),
    'unlockedBadges': unlockedBadges,
    'unlockedAchievements': unlockedAchievements,
  };

  factory UserReward.fromJson(Map<String, dynamic> json) => UserReward(
    xp: json['xp'] as int? ?? 0,
    coins: json['coins'] as int? ?? 0,
    level: json['level'] as int? ?? 1,
    streak: json['streak'] as int? ?? 0,
    lastStudyDate: json['lastStudyDate'] != null
        ? DateTime.tryParse(json['lastStudyDate'] as String)
        : null,
    unlockedBadges: List<String>.from(json['unlockedBadges'] ?? []),
    unlockedAchievements: List<String>.from(json['unlockedAchievements'] ?? []),
  );
}

class Badge {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int xpReward;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.xpReward = 50,
  });
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int xpReward;
  final int coinReward;
  final bool Function(UserReward rewards, dynamic context) isUnlocked;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.xpReward = 100,
    this.coinReward = 50,
    required this.isUnlocked,
  });
}
