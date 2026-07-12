import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_state.dart';
import 'blocs/content/content_bloc.dart';
import 'blocs/content/content_event.dart';
import 'blocs/content/content_state.dart';
import 'providers/theme_provider.dart';
import 'providers/api_key_provider.dart';
import 'core/constants/app_colors.dart';
import 'core/services/ai_service.dart';
import 'core/services/study_os/study_mode_service.dart';
import 'core/services/study_os/study_mode_auth_service.dart';
import 'core/services/study_os/notification_handler.dart';
import 'presentation/widgets/custom_bottom_nav.dart';
import 'presentation/home/home_screen.dart';
import 'presentation/subjects/subject_list_screen.dart';
import 'presentation/progress/progress_screen.dart';
import 'presentation/settings/settings_screen.dart';
import 'presentation/auth/login_screen.dart';
import 'presentation/study_os/secure_exit_dialog.dart';
import 'presentation/study_os/password_dialog.dart';

class PrimeSchoolApp extends StatelessWidget {
  const PrimeSchoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'PRIME School',
          debugShowCheckedModeBanner: false,
          theme: ThemeProvider.lightTheme,
          darkTheme: ThemeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is AuthLoading) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (authState is Unauthenticated) {
                return const LoginScreen();
              }

              return const MainShell();
            },
          ),
        );
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  BottomNavTab _currentTab = BottomNavTab.home;
  bool _studyMode = false;

  @override
  void initState() {
    super.initState();
    context.read<ContentBloc>().add(ContentSubjectsLoaded());
    _loadApiKeys();
    _checkPendingNotificationAction();
  }

  Future<void> _checkPendingNotificationAction() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    final handler = context.read<NotificationHandler>();
    final startId = handler.consumePendingStart();
    if (startId != null && !_studyMode) {
      final service = context.read<StudyModeService>();
      final success = await service.startStudyMode();
      if (mounted && success) setState(() => _studyMode = true);
      return;
    }

    final endId = handler.consumePendingEnd();
    if (endId != null && _studyMode) {
      final service = context.read<StudyModeService>();
      await service.endStudyMode();
      if (mounted) setState(() => _studyMode = false);
    }
  }

  Future<void> _loadApiKeys() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final apiKeyProvider = context.read<ApiKeyProvider>();
      await apiKeyProvider.loadKeys(authState.user.uid);
      final aiService = context.read<AiService>();
      aiService.setGeminiKeys(apiKeyProvider.geminiKeys);
      aiService.setGroqKeys(apiKeyProvider.groqKeys);
      aiService.setCloudflareWorkerUrl(apiKeyProvider.cloudflareWorkerUrl);
      aiService.setCloudflareCredentials(apiKeyProvider.cloudflareAccountId, apiKeyProvider.cloudflareApiToken);
    }
  }

  Future<void> _toggleStudyMode(bool enable) async {
    if (!enable) {
      _showExitConfirmation();
      return;
    }

    final auth = context.read<StudyModeAuthService>();
    final hasPassword = await auth.isPasswordSet();

    if (!hasPassword && mounted) {
      final passwordSet = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => PasswordSetupDialog(
          auth: auth,
          onComplete: () => Navigator.of(ctx).pop(true),
        ),
      );
      if (passwordSet != true) return;
    }

    final service = context.read<StudyModeService>();
    final success = await service.startStudyMode();
    if (mounted && success) setState(() => _studyMode = true);
  }

  void _showExitConfirmation() {
    final auth = context.read<StudyModeAuthService>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => SecureExitDialog(
        auth: auth,
        onExit: _exitStudyMode,
      ),
    );
  }

  void _exitStudyMode() async {
    final service = context.read<StudyModeService>();
    await service.endStudyMode();
    if (mounted) setState(() => _studyMode = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          if (_studyMode)
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 6,
                bottom: 8,
                left: 16,
                right: 8,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.studyOs,
                    AppColors.studyOs.withValues(alpha: 0.85),
                  ],
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.psychology_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Study Mode Active',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Distractions blocked · Stay focused',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: _showExitConfirmation,
                    icon: const Icon(Icons.exit_to_app_rounded, size: 16, color: Colors.white),
                    label: const Text(
                      'Exit',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
      bottomNavigationBar: _studyMode
          ? null
          : CustomBottomNav(
              currentTab: _currentTab,
              onTabChanged: (tab) {
                setState(() {
                  _currentTab = tab;
                });
              },
            ),
    );
  }

  Widget _buildBody() {
    switch (_currentTab) {
      case BottomNavTab.home:
        return HomeScreen(studyMode: _studyMode, onStudyModeToggle: _toggleStudyMode);
      case BottomNavTab.subjects:
        return _buildSubjectsList();
      case BottomNavTab.add:
        return _buildAddScreen();
      case BottomNavTab.progress:
        return const ProgressScreen();
      case BottomNavTab.settings:
        return const SettingsScreen();
    }
  }

  Widget _buildSubjectsList() {
    return BlocBuilder<ContentBloc, ContentState>(
      builder: (context, state) {
        final subjects = state.currentSubjects;

        return Scaffold(
          appBar: AppBar(title: const Text('Subjects')),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return ListTile(
                leading: Text(subject.icon, style: const TextStyle(fontSize: 28)),
                title: Text(subject.name),
                subtitle: Text('${subject.totalChapters} chapters'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubjectListScreen(subject: subject),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAddScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Content')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              size: 64,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            const SizedBox(height: 16),
            Text(
              'Upload textbook pages',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt_rounded),
              label: const Text('Take Photo'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.photo_library_rounded),
              label: const Text('Choose from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
