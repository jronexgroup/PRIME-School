import 'package:hive/hive.dart';
import '../../models/study_session.dart';
import '../../models/study_analytics.dart';

class StudyAnalyticsService {
  static const _sessionsBox = 'study_sessions';
  static const _dailyBox = 'study_daily_stats';
  late Box _sessionsBoxRef;
  late Box _dailyBoxRef;

  Future<void> initialize() async {
    _sessionsBoxRef = await Hive.openBox(_sessionsBox);
    _dailyBoxRef = await Hive.openBox(_dailyBox);
  }

  Future<void> recordSession(StudySession session) async {
    await _sessionsBoxRef.put(session.id, session);
    await _updateDailyStats(session);
  }

  Future<void> _updateDailyStats(StudySession session) async {
    final dateKey = session.startedAt.toIso8601String().substring(0, 10);
    final existing = _dailyBoxRef.get(dateKey) as Map<String, dynamic>?;
    final stats = existing != null
        ? DailyStats.fromJson(existing)
        : DailyStats(date: DateTime.parse(dateKey));

    stats.totalSeconds += session.actualDurationSeconds;
    stats.sessionsCompleted += 1;
    stats.distractions += session.distractionCount;
    stats.xpEarned += session.xpEarned;
    if (session.subjectId != null) {
      stats.subjectsStudied.add(session.subjectId!);
    }

    await _dailyBoxRef.put(dateKey, stats.toJson());
  }

  DailyStats? getDailyStats(DateTime date) {
    final dateKey = date.toIso8601String().substring(0, 10);
    final data = _dailyBoxRef.get(dateKey) as Map<String, dynamic>?;
    return data != null ? DailyStats.fromJson(data) : null;
  }

  List<DailyStats> getDailyStatsForRange(DateTime start, DateTime end) {
    final result = <DailyStats>[];
    var current = start;
    while (!current.isAfter(end)) {
      final stats = getDailyStats(current);
      if (stats != null && stats.totalSeconds > 0) result.add(stats);
      current = current.add(const Duration(days: 1));
    }
    return result;
  }

  WeeklyStats getWeeklyStats(int year, int weekNumber) {
    final weekly = WeeklyStats(year: year, weekNumber: weekNumber);
    final sessions = _sessionsBoxRef.values.cast<StudySession>().where((s) {
      final isoWeek = _getWeekNumber(s.startedAt);
      return isoWeek.$1 == year && isoWeek.$2 == weekNumber;
    });

    for (final s in sessions) {
      weekly.totalSeconds += s.actualDurationSeconds;
      weekly.sessionsCompleted += 1;
      weekly.distractions += s.distractionCount;
      weekly.xpEarned += s.xpEarned;
    }
    return weekly;
  }

  MonthlyStats getMonthlyStats(int year, int month) {
    final monthly = MonthlyStats(year: year, month: month);
    final sessions = _sessionsBoxRef.values.cast<StudySession>().where((s) {
      return s.startedAt.year == year && s.startedAt.month == month;
    });

    for (final s in sessions) {
      monthly.totalSeconds += s.actualDurationSeconds;
      monthly.sessionsCompleted += 1;
      monthly.distractions += s.distractionCount;
      monthly.xpEarned += s.xpEarned;
    }
    return monthly;
  }

  List<StudySession> getAllSessions() => _sessionsBoxRef.values.cast<StudySession>().toList();

  List<StudySession> getSessionsForRange(DateTime start, DateTime end) =>
      _sessionsBoxRef.values.cast<StudySession>()
          .where((s) => !s.startedAt.isBefore(start) && !s.startedAt.isAfter(end))
          .toList();

  int getTotalSessions() => _sessionsBoxRef.length;

  int getTotalMinutes() {
    int total = 0;
    for (final s in _sessionsBoxRef.values.cast<StudySession>()) {
      total += s.actualDurationSeconds;
    }
    return total ~/ 60;
  }

  int getCleanSessionCount() =>
      _sessionsBoxRef.values.cast<StudySession>().where((s) => s.distractionCount == 0).length;

  int getTotalDistractions() {
    int total = 0;
    for (final s in _sessionsBoxRef.values.cast<StudySession>()) {
      total += s.distractionCount;
    }
    return total;
  }

  int getTotalPomodoroCycles() {
    int total = 0;
    for (final s in _sessionsBoxRef.values.cast<StudySession>()) {
      total += s.pomodoroCycles;
    }
    return total;
  }

  int getFaceDownBonusCount() =>
      _sessionsBoxRef.values.cast<StudySession>().where((s) => s.faceDownBonus).length;

  Map<String, int> getSubjectTimeBreakdown() {
    final breakdown = <String, int>{};
    for (final s in _sessionsBoxRef.values.cast<StudySession>()) {
      final subject = s.subjectId ?? 'Unspecified';
      breakdown[subject] = (breakdown[subject] ?? 0) + s.actualDurationSeconds;
    }
    return breakdown;
  }

  (int, int) _getWeekNumber(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(startOfYear).inDays;
    final weekNumber = ((dayOfYear - startOfYear.weekday + 10) / 7).floor();
    return (date.year, weekNumber.clamp(1, 52));
  }

  void dispose() {
    _sessionsBoxRef.close();
    _dailyBoxRef.close();
  }
}
