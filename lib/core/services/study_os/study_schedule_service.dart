import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../models/study_schedule.dart';

class StudyScheduleService {
  static const _boxName = 'study_schedules';
  late Box _box;
  Timer? _checkTimer;
  final _scheduleTriggerController = StreamController<StudySchedule>.broadcast();
  Stream<StudySchedule> get onScheduleTrigger => _scheduleTriggerController.stream;

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final _uuid = const Uuid();

  Future<void> initialize() async {
    _box = await Hive.openBox(_boxName);

    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings();
      await _notifications.initialize(
        settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
      );
    } catch (_) {}

    _startScheduleChecker();
  }

  void _startScheduleChecker() {
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkSchedules();
    });
    // Also check immediately
    _checkSchedules();
  }

  void _checkSchedules() {
    final now = DateTime.now();
    final currentMinute = now.hour * 60 + now.minute;
    for (final schedule in _box.values.cast<StudySchedule>()) {
      if (!schedule.active) continue;
      if (!schedule.daysOfWeek.contains(now.weekday)) continue;

      final startMin = schedule.startHour * 60 + schedule.startMinute;
      final endMin = schedule.endHour * 60 + schedule.endMinute;

      // Trigger 5 minutes before start
      if (currentMinute == startMin - 5) {
        _sendReminder(schedule);
      }

      // Start at scheduled time
      if (currentMinute == startMin) {
        _scheduleTriggerController.add(schedule);
      }

      // End at scheduled time
      if (currentMinute == endMin) {
        _scheduleTriggerController.add(schedule); // Will be handled as end by listener
      }
    }
  }

  Future<void> _sendReminder(StudySchedule schedule) async {
    try {
      await _notifications.show(
        id: schedule.id.hashCode,
        title: 'Study Time Soon!',
        body: '${schedule.name} starts in 5 minutes (${schedule.startTimeFormatted})',
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'study_reminders',
            'Study Reminders',
            importance: Importance.high,
            priority: Priority.high,
            fullScreenIntent: true,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    } catch (_) {}
  }

  Future<void> addSchedule(StudySchedule schedule) async {
    await _box.put(schedule.id, schedule);
  }

  Future<StudySchedule> createSchedule({
    String name = 'Study Session',
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
    List<int> daysOfWeek = const [1, 2, 3, 4, 5, 6, 7],
    String? subjectId,
  }) async {
    final schedule = StudySchedule(
      id: _uuid.v4(),
      name: name,
      startHour: startHour,
      startMinute: startMinute,
      endHour: endHour,
      endMinute: endMinute,
      daysOfWeek: daysOfWeek,
      subjectId: subjectId,
    );
    await addSchedule(schedule);
    return schedule;
  }

  Future<void> updateSchedule(StudySchedule schedule) async {
    await _box.put(schedule.id, schedule);
  }

  Future<void> deleteSchedule(String id) async {
    await _box.delete(id);
  }

  Future<void> toggleSchedule(String id) async {
    final schedule = _box.get(id) as StudySchedule?;
    if (schedule != null) {
      schedule.active = !schedule.active;
      await _box.put(schedule.id, schedule);
    }
  }

  List<StudySchedule> getAllSchedules() => _box.values.cast<StudySchedule>().toList();

  StudySchedule? getSchedule(String id) => _box.get(id) as StudySchedule?;

  List<StudySchedule> getActiveSchedulesForToday() {
    final today = DateTime.now().weekday;
    return _box.values.cast<StudySchedule>().where((s) => s.active && s.daysOfWeek.contains(today)).toList();
  }

  bool isStudyTimeNow() {
    final now = DateTime.now();
    final currentMinute = now.hour * 60 + now.minute;
    for (final schedule in _box.values.cast<StudySchedule>()) {
      if (!schedule.active) continue;
      if (!schedule.daysOfWeek.contains(now.weekday)) continue;
      final startMin = schedule.startHour * 60 + schedule.startMinute;
      final endMin = schedule.endHour * 60 + schedule.endMinute;
      if (currentMinute >= startMin && currentMinute < endMin) return true;
    }
    return false;
  }

  void dispose() {
    _checkTimer?.cancel();
    _scheduleTriggerController.close();
  }
}
