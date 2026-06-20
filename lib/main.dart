import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/services/firebase_service.dart';
import 'core/services/auth_service.dart';
import 'core/services/firestore_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/ai_service.dart';
import 'core/services/tts_service.dart';
import 'core/services/cache_service.dart';
import 'providers/theme_provider.dart';
import 'providers/api_key_provider.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/content/content_bloc.dart';
import 'blocs/study/study_bloc.dart';
import 'blocs/quiz/quiz_bloc.dart';
import 'blocs/exam/exam_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    final apiKeyProvider = ApiKeyProvider();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authService),
        RepositoryProvider.value(value: firestoreService),
        RepositoryProvider.value(value: storageService),
        RepositoryProvider.value(value: aiService),
        RepositoryProvider.value(value: ttsService),
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
            ),
          ),
          BlocProvider(
            create: (_) => QuizBloc(aiService: aiService),
          ),
          BlocProvider(
            create: (_) => ExamBloc(firestoreService: firestoreService),
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
