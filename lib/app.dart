import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_state.dart';
import 'blocs/content/content_bloc.dart';
import 'blocs/content/content_event.dart';
import 'blocs/content/content_state.dart';
import 'providers/theme_provider.dart';
import 'core/constants/app_colors.dart';
import 'presentation/widgets/custom_bottom_nav.dart';
import 'presentation/home/home_screen.dart';
import 'presentation/subjects/subject_list_screen.dart';
import 'presentation/progress/progress_screen.dart';
import 'presentation/settings/settings_screen.dart';
import 'presentation/auth/login_screen.dart';

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

  @override
  void initState() {
    super.initState();
    context.read<ContentBloc>().add(ContentSubjectsLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNav(
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
        return const HomeScreen();
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
