import 'package:equatable/equatable.dart';

class SettingsModel extends Equatable {
  final String userId;
  final bool isExamMode;
  final DateTime? examDate;
  final bool notificationsEnabled;
  final bool smartRemindersEnabled;
  final bool examCountdownEnabled;
  final bool achievementAlertsEnabled;
  final String aiResponseLanguage;
  final bool voiceExplanationEnabled;
  final String fontSize;
  final bool isDarkTheme;

  const SettingsModel({
    required this.userId,
    this.isExamMode = false,
    this.examDate,
    this.notificationsEnabled = true,
    this.smartRemindersEnabled = true,
    this.examCountdownEnabled = true,
    this.achievementAlertsEnabled = true,
    this.aiResponseLanguage = 'Bengali',
    this.voiceExplanationEnabled = true,
    this.fontSize = 'Medium',
    this.isDarkTheme = true,
  });

  factory SettingsModel.initial(String userId) => SettingsModel(userId: userId);

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      userId: map['userId'] ?? '',
      isExamMode: map['isExamMode'] ?? false,
      examDate: map['examDate'] != null ? DateTime.parse(map['examDate']) : null,
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      smartRemindersEnabled: map['smartRemindersEnabled'] ?? true,
      examCountdownEnabled: map['examCountdownEnabled'] ?? true,
      achievementAlertsEnabled: map['achievementAlertsEnabled'] ?? true,
      aiResponseLanguage: map['aiResponseLanguage'] ?? 'Bengali',
      voiceExplanationEnabled: map['voiceExplanationEnabled'] ?? true,
      fontSize: map['fontSize'] ?? 'Medium',
      isDarkTheme: map['isDarkTheme'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'isExamMode': isExamMode,
      'examDate': examDate?.toIso8601String(),
      'notificationsEnabled': notificationsEnabled,
      'smartRemindersEnabled': smartRemindersEnabled,
      'examCountdownEnabled': examCountdownEnabled,
      'achievementAlertsEnabled': achievementAlertsEnabled,
      'aiResponseLanguage': aiResponseLanguage,
      'voiceExplanationEnabled': voiceExplanationEnabled,
      'fontSize': fontSize,
      'isDarkTheme': isDarkTheme,
    };
  }

  SettingsModel copyWith({
    bool? isExamMode,
    DateTime? examDate,
    bool? notificationsEnabled,
    bool? smartRemindersEnabled,
    bool? examCountdownEnabled,
    bool? achievementAlertsEnabled,
    String? aiResponseLanguage,
    bool? voiceExplanationEnabled,
    String? fontSize,
    bool? isDarkTheme,
  }) {
    return SettingsModel(
      userId: userId,
      isExamMode: isExamMode ?? this.isExamMode,
      examDate: examDate ?? this.examDate,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      smartRemindersEnabled: smartRemindersEnabled ?? this.smartRemindersEnabled,
      examCountdownEnabled: examCountdownEnabled ?? this.examCountdownEnabled,
      achievementAlertsEnabled: achievementAlertsEnabled ?? this.achievementAlertsEnabled,
      aiResponseLanguage: aiResponseLanguage ?? this.aiResponseLanguage,
      voiceExplanationEnabled: voiceExplanationEnabled ?? this.voiceExplanationEnabled,
      fontSize: fontSize ?? this.fontSize,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
    );
  }

  @override
  List<Object?> get props => [userId, isExamMode, examDate, fontSize, isDarkTheme];
}
