class DailyStats {
  final DateTime date;
  int totalSeconds;
  int sessionsCompleted;
  int distractions;
  int xpEarned;
  Set<String> subjectsStudied;

  DailyStats({
    required this.date,
    this.totalSeconds = 0,
    this.sessionsCompleted = 0,
    this.distractions = 0,
    this.xpEarned = 0,
    Set<String>? subjectsStudied,
  }) : subjectsStudied = subjectsStudied ?? {};

  int get totalMinutes => totalSeconds ~/ 60;

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String().substring(0, 10),
    'totalSeconds': totalSeconds,
    'sessionsCompleted': sessionsCompleted,
    'distractions': distractions,
    'xpEarned': xpEarned,
    'subjectsStudied': subjectsStudied.toList(),
  };

  factory DailyStats.fromJson(Map<String, dynamic> json) => DailyStats(
    date: DateTime.parse(json['date'] as String),
    totalSeconds: json['totalSeconds'] as int? ?? 0,
    sessionsCompleted: json['sessionsCompleted'] as int? ?? 0,
    distractions: json['distractions'] as int? ?? 0,
    xpEarned: json['xpEarned'] as int? ?? 0,
    subjectsStudied: Set<String>.from(json['subjectsStudied'] ?? []),
  );
}

class WeeklyStats {
  final int year;
  final int weekNumber;
  int totalSeconds;
  int sessionsCompleted;
  int distractions;
  int xpEarned;
  int streakDays;

  WeeklyStats({
    required this.year,
    required this.weekNumber,
    this.totalSeconds = 0,
    this.sessionsCompleted = 0,
    this.distractions = 0,
    this.xpEarned = 0,
    this.streakDays = 0,
  });

  int get totalMinutes => totalSeconds ~/ 60;
  int get totalHours => totalMinutes ~/ 60;

  Map<String, dynamic> toJson() => {
    'year': year,
    'weekNumber': weekNumber,
    'totalSeconds': totalSeconds,
    'sessionsCompleted': sessionsCompleted,
    'distractions': distractions,
    'xpEarned': xpEarned,
    'streakDays': streakDays,
  };

  factory WeeklyStats.fromJson(Map<String, dynamic> json) => WeeklyStats(
    year: json['year'] as int,
    weekNumber: json['weekNumber'] as int,
    totalSeconds: json['totalSeconds'] as int? ?? 0,
    sessionsCompleted: json['sessionsCompleted'] as int? ?? 0,
    distractions: json['distractions'] as int? ?? 0,
    xpEarned: json['xpEarned'] as int? ?? 0,
    streakDays: json['streakDays'] as int? ?? 0,
  );
}

class MonthlyStats {
  final int year;
  final int month;
  int totalSeconds;
  int sessionsCompleted;
  int distractions;
  int xpEarned;
  int streakDays;

  MonthlyStats({
    required this.year,
    required this.month,
    this.totalSeconds = 0,
    this.sessionsCompleted = 0,
    this.distractions = 0,
    this.xpEarned = 0,
    this.streakDays = 0,
  });

  int get totalMinutes => totalSeconds ~/ 60;
  int get totalHours => totalMinutes ~/ 60;

  Map<String, dynamic> toJson() => {
    'year': year,
    'month': month,
    'totalSeconds': totalSeconds,
    'sessionsCompleted': sessionsCompleted,
    'distractions': distractions,
    'xpEarned': xpEarned,
    'streakDays': streakDays,
  };

  factory MonthlyStats.fromJson(Map<String, dynamic> json) => MonthlyStats(
    year: json['year'] as int,
    month: json['month'] as int,
    totalSeconds: json['totalSeconds'] as int? ?? 0,
    sessionsCompleted: json['sessionsCompleted'] as int? ?? 0,
    distractions: json['distractions'] as int? ?? 0,
    xpEarned: json['xpEarned'] as int? ?? 0,
    streakDays: json['streakDays'] as int? ?? 0,
  );
}
