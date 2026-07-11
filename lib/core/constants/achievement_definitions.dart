import '../models/reward.dart';

class AchievementDefinitions {
  AchievementDefinitions._();

  static final List<Achievement> all = [
    Achievement(
      id: 'first_session',
      name: 'First Steps',
      description: 'Complete your first study session',
      icon: '🌟',
      xpReward: 50,
      coinReward: 25,
      isUnlocked: (rewards, ctx) {
        final totalSessions = ctx is int ? ctx : 0;
        return totalSessions >= 1;
      },
    ),
    Achievement(
      id: 'streak_3',
      name: 'Getting Started',
      description: 'Study for 3 days in a row',
      icon: '🔥',
      xpReward: 100,
      coinReward: 50,
      isUnlocked: (rewards, ctx) => rewards.streak >= 3,
    ),
    Achievement(
      id: 'streak_7',
      name: 'Week Warrior',
      description: 'Study for 7 days in a row',
      icon: '💪',
      xpReward: 200,
      coinReward: 100,
      isUnlocked: (rewards, ctx) => rewards.streak >= 7,
    ),
    Achievement(
      id: 'streak_30',
      name: 'Monthly Master',
      description: 'Study for 30 days in a row',
      icon: '🏆',
      xpReward: 500,
      coinReward: 250,
      isUnlocked: (rewards, ctx) => rewards.streak >= 30,
    ),
    Achievement(
      id: 'sessions_10',
      name: 'Dedicated',
      description: 'Complete 10 study sessions',
      icon: '🎯',
      xpReward: 150,
      coinReward: 75,
      isUnlocked: (rewards, ctx) {
        final totalSessions = ctx is int ? ctx : 0;
        return totalSessions >= 10;
      },
    ),
    Achievement(
      id: 'sessions_50',
      name: 'Study Machine',
      description: 'Complete 50 study sessions',
      icon: '🤖',
      xpReward: 400,
      coinReward: 200,
      isUnlocked: (rewards, ctx) {
        final totalSessions = ctx is int ? ctx : 0;
        return totalSessions >= 50;
      },
    ),
    Achievement(
      id: 'hours_10',
      name: '10 Hour Club',
      description: 'Study for 10 total hours',
      icon: '⏰',
      xpReward: 200,
      coinReward: 100,
      isUnlocked: (rewards, ctx) {
        final totalMinutes = ctx is int ? ctx : 0;
        return totalMinutes >= 600;
      },
    ),
    Achievement(
      id: 'hours_50',
      name: 'Marathoner',
      description: 'Study for 50 total hours',
      icon: '🏃',
      xpReward: 500,
      coinReward: 250,
      isUnlocked: (rewards, ctx) {
        final totalMinutes = ctx is int ? ctx : 0;
        return totalMinutes >= 3000;
      },
    ),
    Achievement(
      id: 'no_distractions_5',
      name: 'Laser Focus',
      description: 'Complete 5 sessions without any distractions',
      icon: '🧘',
      xpReward: 200,
      coinReward: 100,
      isUnlocked: (rewards, ctx) {
        final cleanSessions = ctx is int ? ctx : 0;
        return cleanSessions >= 5;
      },
    ),
    Achievement(
      id: 'pomodoro_10',
      name: 'Tomato Timer',
      description: 'Complete 10 pomodoro cycles',
      icon: '🍅',
      xpReward: 150,
      coinReward: 75,
      isUnlocked: (rewards, ctx) {
        final totalPomodoros = ctx is int ? ctx : 0;
        return totalPomodoros >= 10;
      },
    ),
    Achievement(
      id: 'face_down_5',
      name: 'Phone Down',
      description: 'Earn the face-down bonus 5 times',
      icon: '📵',
      xpReward: 100,
      coinReward: 50,
      isUnlocked: (rewards, ctx) {
        final faceDownCount = ctx is int ? ctx : 0;
        return faceDownCount >= 5;
      },
    ),
    Achievement(
      id: 'xp_1000',
      name: 'Knowledge Seeker',
      description: 'Earn 1,000 total XP',
      icon: '📚',
      xpReward: 300,
      coinReward: 150,
      isUnlocked: (rewards, ctx) => rewards.xp >= 1000,
    ),
    Achievement(
      id: 'xp_5000',
      name: 'Knowledge Sage',
      description: 'Earn 5,000 total XP',
      icon: '🧙',
      xpReward: 800,
      coinReward: 400,
      isUnlocked: (rewards, ctx) => rewards.xp >= 5000,
    ),
    Achievement(
      id: 'level_5',
      name: 'Level Up!',
      description: 'Reach level 5',
      icon: '⭐',
      xpReward: 200,
      coinReward: 100,
      isUnlocked: (rewards, ctx) => rewards.level >= 5,
    ),
    Achievement(
      id: 'level_10',
      name: 'Pro Learner',
      description: 'Reach level 10',
      icon: '👑',
      xpReward: 500,
      coinReward: 250,
      isUnlocked: (rewards, ctx) => rewards.level >= 10,
    ),
  ];
}
