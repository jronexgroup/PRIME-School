import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String name;
  final int classLevel;
  final String board;
  final bool isExamMode;
  final DateTime? examDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    required this.name,
    this.classLevel = 9,
    this.board = 'WB Madhyamik',
    this.isExamMode = false,
    this.examDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.initial(String uid) => UserModel(
        uid: uid,
        name: 'Supreme Prime',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  UserModel copyWith({
    String? name,
    int? classLevel,
    String? board,
    bool? isExamMode,
    DateTime? examDate,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      classLevel: classLevel ?? this.classLevel,
      board: board ?? this.board,
      isExamMode: isExamMode ?? this.isExamMode,
      examDate: examDate ?? this.examDate,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'classLevel': classLevel,
      'board': board,
      'isExamMode': isExamMode,
      'examDate': examDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      classLevel: map['classLevel'] ?? 9,
      board: map['board'] ?? 'WB Madhyamik',
      isExamMode: map['isExamMode'] ?? false,
      examDate: map['examDate'] != null ? DateTime.parse(map['examDate']) : null,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  int? get daysUntilExam {
    if (examDate == null) return null;
    final now = DateTime.now();
    final diff = examDate!.difference(now).inDays;
    return diff >= 0 ? diff : null;
  }

  @override
  List<Object?> get props => [uid, name, classLevel, board, isExamMode, examDate];
}
