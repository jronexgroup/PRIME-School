import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'app.dart';
import 'core/services/firebase_service.dart';
import 'core/services/auth_service.dart';
import 'core/services/firestore_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/ai_service.dart';
import 'core/services/tts_service.dart';
import 'core/services/sarvam_service.dart';
import 'core/services/cache_service.dart';
import 'core/services/content_rag_service.dart';
import 'core/services/progress_service.dart';
import 'core/services/study_os/study_mode_service.dart';
import 'core/services/study_os/study_schedule_service.dart';
import 'core/services/study_os/study_analytics_service.dart';
import 'core/services/study_os/reward_service.dart';
import 'core/services/study_os/pomodoro_service.dart';
import 'core/services/study_os/smart_notes_service.dart';
import 'core/services/study_os/voice_tutor_service.dart';
import 'core/services/study_os/focus_detector_service.dart';
import 'core/services/study_os/study_mode_auth_service.dart';
import 'core/services/study_os/notification_handler.dart';
import 'providers/theme_provider.dart';
import 'providers/api_key_provider.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/content/content_bloc.dart';
import 'blocs/study/study_bloc.dart';
import 'blocs/quiz/quiz_bloc.dart';
import 'blocs/exam/exam_bloc.dart';
import 'blocs/study_os/study_os_bloc.dart';

const _workmanagerTaskName = 'com.prime_school.schedule_reschedule';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == _workmanagerTaskName) {
      try {
        final scheduleService = StudyScheduleService();
        await scheduleService.initialize(
          onNotificationTap: (_) {},
        );
        await scheduleService.rescheduleAll();
        scheduleService.dispose();
      } catch (_) {}
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  await FirebaseService.initialize();
  await CacheService().initialize();

  runApp(const PrimeSchoolRoot());
}

class PrimeSchoolRoot extends StatelessWidget {
  const PrimeSchoolRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final firestoreService = FirestoreService();
    final storageService = StorageService();
    final aiService = AiService();
    final ttsService = TtsService();
    final sarvamService = SarvamService();
    final apiKeyProvider = ApiKeyProvider();
    final contentRagService = ContentRagService(firestore: firestoreService, ai: aiService);
    final progressService = ProgressService();

    // Study OS services
    final studyModeService = StudyModeService();
    final notificationHandler = NotificationHandler();
    final scheduleService = StudyScheduleService();
    final analyticsService = StudyAnalyticsService();
    final rewardService = RewardService();
    final pomodoroService = PomodoroService();
    final smartNotesService = SmartNotesService();
    final voiceTutorService = VoiceTutorService(ttsService);
    final focusDetectorService = FocusDetectorService();
    final studyModeAuthService = StudyModeAuthService();

    scheduleService.initialize(
      onNotificationTap: notificationHandler.onNotificationResponse,
    );

    Workmanager().registerPeriodicTask(
      _workmanagerTaskName,
      _workmanagerTaskName,
      frequency: const Duration(hours: 6),
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authService),
        RepositoryProvider.value(value: firestoreService),
        RepositoryProvider.value(value: storageService),
        RepositoryProvider.value(value: aiService),
        RepositoryProvider.value(value: ttsService),
        RepositoryProvider.value(value: sarvamService),
        RepositoryProvider.value(value: contentRagService),
        RepositoryProvider.value(value: progressService),

        // Study OS services
        RepositoryProvider.value(value: studyModeService),
        RepositoryProvider.value(value: notificationHandler),
        RepositoryProvider.value(value: scheduleService),
        RepositoryProvider.value(value: analyticsService),
        RepositoryProvider.value(value: rewardService),
        RepositoryProvider.value(value: pomodoroService),
        RepositoryProvider.value(value: smartNotesService),
        RepositoryProvider.value(value: voiceTutorService),
        RepositoryProvider.value(value: focusDetectorService),
        RepositoryProvider.value(value: studyModeAuthService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(authService: authService)..add(AuthStarted()),
          ),
          BlocProvider(
            create: (_) => ContentBloc(firestoreService: firestoreService),
          ),
          BlocProvider(
            create: (_) => StudyBloc(
              firestoreService: firestoreService,
              aiService: aiService,
              ttsService: ttsService,
              sarvamService: sarvamService,
            ),
          ),
          BlocProvider(
            create: (_) => QuizBloc(),
          ),
          BlocProvider(
            create: (_) => ExamBloc(firestoreService: firestoreService),
          ),
          BlocProvider(
            create: (_) => StudyOsBloc(
              studyModeService: studyModeService,
              scheduleService: scheduleService,
              pomodoroService: pomodoroService,
              rewardService: rewardService,
              analyticsService: analyticsService,
              smartNotesService: smartNotesService,
              voiceTutorService: voiceTutorService,
              focusDetectorService: focusDetectorService,
            ),
          ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: ThemeProvider()),
            ChangeNotifierProvider.value(value: apiKeyProvider),
          ],
          child: const PrimeSchoolApp(),
        ),
      ),
    );
  }
}
