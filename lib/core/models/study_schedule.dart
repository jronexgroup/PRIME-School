import 'package:hive/hive.dart';

part 'study_schedule.g.dart';

@HiveType(typeId: 10)
class StudySchedule extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int startHour;

  @HiveField(3)
  int startMinute;

  @HiveField(4)
  int endHour;

  @HiveField(5)
  int endMinute;

  @HiveField(6)
  List<int> daysOfWeek;

  @HiveField(7)
  bool active;

  @HiveField(8)
  String? subjectId;

  @HiveField(9)
  bool enablePomodoro;

  @HiveField(10)
  int pomodoroFocusMinutes;

  @HiveField(11)
  int pomodoroBreakMinutes;

  StudySchedule({
    required this.id,
    this.name = 'Study Session',
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    this.daysOfWeek = const [1, 2, 3, 4, 5, 6, 7],
    this.active = true,
    this.subjectId,
    this.enablePomodoro = false,
    this.pomodoroFocusMinutes = 25,
    this.pomodoroBreakMinutes = 5,
  });

  String get startTimeFormatted =>
      '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}';

  String get endTimeFormatted =>
      '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';

  int get durationMinutes =>
      (endHour * 60 + endMinute) - (startHour * 60 + startMinute);

  bool get isValid => durationMinutes > 0;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'startHour': startHour,
    'startMinute': startMinute,
    'endHour': endHour,
    'endMinute': endMinute,
    'daysOfWeek': daysOfWeek,
    'active': active,
    'subjectId': subjectId,
    'enablePomodoro': enablePomodoro,
    'pomodoroFocusMinutes': pomodoroFocusMinutes,
    'pomodoroBreakMinutes': pomodoroBreakMinutes,
  };

  factory StudySchedule.fromJson(Map<String, dynamic> json) => StudySchedule(
    id: json['id'] as String,
    name: json['name'] as String? ?? 'Study Session',
    startHour: json['startHour'] as int,
    startMinute: json['startMinute'] as int,
    endHour: json['endHour'] as int,
    endMinute: json['endMinute'] as int,
    daysOfWeek: List<int>.from(json['daysOfWeek'] ?? [1,2,3,4,5,6,7]),
    active: json['active'] as bool? ?? true,
    subjectId: json['subjectId'] as String?,
    enablePomodoro: json['enablePomodoro'] as bool? ?? false,
    pomodoroFocusMinutes: json['pomodoroFocusMinutes'] as int? ?? 25,
    pomodoroBreakMinutes: json['pomodoroBreakMinutes'] as int? ?? 5,
  );
}
