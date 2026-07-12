import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../models/study_schedule.dart';

class StudyScheduleService {
  static const _boxName = 'study_schedules';
  late Box _box;
  Timer? _checkTimer;

  static const String channelStart = 'study_auto_start';
  static const String channelEnd = 'study_auto_end';
  static const String channelReminder = 'study_reminders';
  static const String payloadPrefixStart = 'study_start:';
  static const String payloadPrefixEnd = 'study_end:';

  final _scheduleTriggerController = StreamController<StudySchedule>.broadcast();
  Stream<StudySchedule> get onScheduleTrigger => _scheduleTriggerController.stream;

  final _studyModeStartController = StreamController<String?>.broadcast();
  Stream<String?> get onStudyModeStart => _studyModeStartController.stream;

  final _studyModeEndController = StreamController<String?>.broadcast();
  Stream<String?> get onStudyModeEnd => _studyModeEndController.stream;

  final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();
  final _uuid = const Uuid();

  String? pendingStartScheduleId;
  String? pendingEndScheduleId;

  Future<void> initialize({void Function(NotificationResponse)? onNotificationTap}) async {
    _box = await Hive.openBox(_boxName);

    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings();
      await notifications.initialize(
        settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
        onDidReceiveNotificationResponse: onNotificationTap,
      );
    } catch (_) {}

    _startScheduleChecker();
  }

  void _startScheduleChecker() {
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkSchedules();
    });
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

      if (currentMinute == startMin - 5) {
        _sendReminder(schedule);
      }

      if (currentMinute == startMin) {
        _scheduleTriggerController.add(schedule);
        _studyModeStartController.add(schedule.id);
      }

      if (currentMinute == endMin) {
        _scheduleTriggerController.add(schedule);
        _studyModeEndController.add(schedule.id);
      }
    }
  }

  Future<void> scheduleAutoNotifications(StudySchedule schedule) async {
    try {
      await notifications.cancel(id: schedule.id.hashCode);
      await notifications.cancel(id: schedule.id.hashCode + 1);
      await notifications.cancel(id: schedule.id.hashCode + 2);
    } catch (_) {}

    try {
      final now = DateTime.now();
      final startTime = DateTime(now.year, now.month, now.day, schedule.startHour, schedule.startMinute);
      final endTime = DateTime(now.year, now.month, now.day, schedule.endHour, schedule.endMinute);

      if (startTime.isAfter(now) || startTime.isAtSameMomentAs(now)) {
        await notifications.periodicallyShow(
          id: schedule.id.hashCode,
          title: 'Study Time!',
          body: '${schedule.name} — Tap to start focused learning',
          repeatInterval: RepeatInterval.daily,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              channelStart,
              'Study Auto-Start',
              importance: Importance.max,
              priority: Priority.max,
              fullScreenIntent: true,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: '${payloadPrefixStart}${schedule.id}',
        );
      }

      if (endTime.isAfter(now) || endTime.isAtSameMomentAs(now)) {
        await notifications.periodicallyShow(
          id: schedule.id.hashCode + 1,
          title: 'Study Session Complete!',
          body: '${schedule.name} has ended. Great work!',
          repeatInterval: RepeatInterval.daily,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              channelEnd,
              'Study Auto-End',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: '${payloadPrefixEnd}${schedule.id}',
        );
      }
    } catch (_) {}
  }

  Future<void> rescheduleAll() async {
    for (final schedule in _box.values.cast<StudySchedule>()) {
      if (schedule.active) {
        await scheduleAutoNotifications(schedule);
      }
    }
  }

  Future<void> _sendReminder(StudySchedule schedule) async {
    try {
      await notifications.show(
        id: schedule.id.hashCode + 2,
        title: 'Study Time Soon!',
        body: '${schedule.name} starts in 5 minutes (${schedule.startTimeFormatted})',
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            channelReminder,
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
    await scheduleAutoNotifications(schedule);
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
    await scheduleAutoNotifications(schedule);
  }

  Future<void> deleteSchedule(String id) async {
    await _box.delete(id);
    try {
      await notifications.cancel(id: id.hashCode);
      await notifications.cancel(id: id.hashCode + 1);
      await notifications.cancel(id: id.hashCode + 2);
    } catch (_) {}
  }

  Future<void> toggleSchedule(String id) async {
    final schedule = _box.get(id) as StudySchedule?;
    if (schedule != null) {
      schedule.active = !schedule.active;
      await _box.put(schedule.id, schedule);
      await scheduleAutoNotifications(schedule);
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
    _studyModeStartController.close();
    _studyModeEndController.close();
  }
}
