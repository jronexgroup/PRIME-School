class StudySession {
  final String id;
  final DateTime startedAt;
  DateTime? endedAt;
  final int plannedDurationMinutes;
  int actualDurationSeconds;
  int distractionCount;
  String? subjectId;
  String? scheduleId;
  int xpEarned;
  bool completed;
  bool faceDownBonus;
  int pomodoroCycles;
  String? notes;

  StudySession({
    required this.id,
    required this.startedAt,
    this.endedAt,
    this.plannedDurationMinutes = 60,
    this.actualDurationSeconds = 0,
    this.distractionCount = 0,
    this.subjectId,
    this.scheduleId,
    this.xpEarned = 0,
    this.completed = false,
    this.faceDownBonus = false,
    this.pomodoroCycles = 0,
    this.notes,
  });

  int get actualDurationMinutes => actualDurationSeconds ~/ 60;

  double get focusScore {
    if (actualDurationMinutes == 0) return 0;
    final distractionPenalty = distractionCount * 5;
    final maxScore = actualDurationMinutes * 10;
    return ((maxScore - distractionPenalty) / maxScore).clamp(0, 1);
  }

  String get durationFormatted {
    final h = actualDurationMinutes ~/ 60;
    final m = actualDurationMinutes % 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'startedAt': startedAt.toIso8601String(),
    'endedAt': endedAt?.toIso8601String(),
    'plannedDurationMinutes': plannedDurationMinutes,
    'actualDurationSeconds': actualDurationSeconds,
    'distractionCount': distractionCount,
    'subjectId': subjectId,
    'scheduleId': scheduleId,
    'xpEarned': xpEarned,
    'completed': completed,
    'faceDownBonus': faceDownBonus,
    'pomodoroCycles': pomodoroCycles,
    'notes': notes,
  };

  factory StudySession.fromJson(Map<String, dynamic> json) => StudySession(
    id: json['id'] as String,
    startedAt: DateTime.parse(json['startedAt'] as String),
    endedAt: json['endedAt'] != null ? DateTime.parse(json['endedAt'] as String) : null,
    plannedDurationMinutes: json['plannedDurationMinutes'] as int? ?? 60,
    actualDurationSeconds: json['actualDurationSeconds'] as int? ?? 0,
    distractionCount: json['distractionCount'] as int? ?? 0,
    subjectId: json['subjectId'] as String?,
    scheduleId: json['scheduleId'] as String?,
    xpEarned: json['xpEarned'] as int? ?? 0,
    completed: json['completed'] as bool? ?? false,
    faceDownBonus: json['faceDownBonus'] as bool? ?? false,
    pomodoroCycles: json['pomodoroCycles'] as int? ?? 0,
    notes: json['notes'] as String?,
  );
}
