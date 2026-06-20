import 'package:equatable/equatable.dart';

class RoutineModel extends Equatable {
  final String id;
  final String subjectId;
  final String time;
  final List<int> days;
  final bool isActive;

  const RoutineModel({
    required this.id,
    required this.subjectId,
    required this.time,
    required this.days,
    this.isActive = true,
  });

  factory RoutineModel.fromMap(Map<String, dynamic> map) {
    return RoutineModel(
      id: map['id'] ?? '',
      subjectId: map['subjectId'] ?? '',
      time: map['time'] ?? '',
      days: List<int>.from(map['days'] ?? []),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subjectId': subjectId,
      'time': time,
      'days': days,
      'isActive': isActive,
    };
  }

  RoutineModel copyWith({bool? isActive, String? time, List<int>? days}) {
    return RoutineModel(
      id: id,
      subjectId: subjectId,
      time: time ?? this.time,
      days: days ?? this.days,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, subjectId, time, days, isActive];
}
