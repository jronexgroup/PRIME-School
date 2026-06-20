import 'package:equatable/equatable.dart';

class ProgressModel extends Equatable {
  final String userId;
  final Map<String, double> subjectProgress;
  final Map<String, Map<String, double>> topicProgress;
  final int totalTopicsStudied;
  final int streak;
  final DateTime lastStudyDate;
  final Map<String, int> quizScores;
  final Map<String, int> weakAreas;

  const ProgressModel({
    required this.userId,
    this.subjectProgress = const {},
    this.topicProgress = const {},
    this.totalTopicsStudied = 0,
    this.streak = 0,
    required this.lastStudyDate,
    this.quizScores = const {},
    this.weakAreas = const {},
  });

  factory ProgressModel.initial(String userId) => ProgressModel(
        userId: userId,
        lastStudyDate: DateTime.now(),
      );

  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      userId: map['userId'] ?? '',
      subjectProgress: Map<String, double>.from(map['subjectProgress'] ?? {}),
      totalTopicsStudied: map['totalTopicsStudied'] ?? 0,
      streak: map['streak'] ?? 0,
      lastStudyDate: DateTime.parse(map['lastStudyDate']),
      quizScores: Map<String, int>.from(map['quizScores'] ?? {}),
      weakAreas: Map<String, int>.from(map['weakAreas'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'subjectProgress': subjectProgress,
      'totalTopicsStudied': totalTopicsStudied,
      'streak': streak,
      'lastStudyDate': lastStudyDate.toIso8601String(),
      'quizScores': quizScores,
      'weakAreas': weakAreas,
    };
  }

  ProgressModel copyWith({
    Map<String, double>? subjectProgress,
    int? totalTopicsStudied,
    int? streak,
    DateTime? lastStudyDate,
    Map<String, int>? quizScores,
    Map<String, int>? weakAreas,
  }) {
    return ProgressModel(
      userId: userId,
      subjectProgress: subjectProgress ?? this.subjectProgress,
      topicProgress: topicProgress,
      totalTopicsStudied: totalTopicsStudied ?? this.totalTopicsStudied,
      streak: streak ?? this.streak,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
      quizScores: quizScores ?? this.quizScores,
      weakAreas: weakAreas ?? this.weakAreas,
    );
  }

  @override
  List<Object?> get props => [userId, subjectProgress, totalTopicsStudied, streak];
}
