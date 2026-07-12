import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../blocs/study_os/study_os_bloc.dart';
import '../../blocs/study_os/study_os_event.dart';
import '../../blocs/study_os/study_os_state.dart';
import 'secure_exit_dialog.dart';
import 'distraction_overlay.dart';
import 'pomodoro_screen.dart';
import 'ai_hub_screen.dart';
import 'smart_notes_screen.dart';
import 'widgets/focus_overlay.dart';

class StudyModeScreen extends StatefulWidget {
  const StudyModeScreen({super.key});

  @override
  State<StudyModeScreen> createState() => _StudyModeScreenState();
}

class _StudyModeScreenState extends State<StudyModeScreen> {
  int _currentTab = 0;
  bool _showExitWarning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudyOsBloc>().add(const StudyOsStartSession(
        durationMinutes: 60,
        enablePomodoro: true,
      ));
    });
  }

  Future<bool> _onWillPop() async {
    if (_showExitWarning) return false;
    setState(() => _showExitWarning = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _showExitWarning = false);
    return false;
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => BlocProvider.value(
        value: context.read<StudyOsBloc>(),
        child: const SecureExitDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _onWillPop();
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: BlocConsumer<StudyOsBloc, StudyOsState>(
            listener: (context, state) {
              if (state.sessionState == StudyOsSessionState.idle) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  // Top bar — timer, distractions, exit
                  _buildTopBar(context, isDark, state),

                  // Main content area
                  Expanded(child: _buildContent(context, isDark)),

                  // Face-down bonus indicator
                  if (state.faceDown)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      color: AppColors.success.withValues(alpha: 0.15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone_android_rounded, size: 14, color: AppColors.success),
                          const SizedBox(width: 6),
                          Text('Phone face down — Focus bonus active!', style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),

                  // Bottom tabs
                  _buildBottomNav(isDark, state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDark, StudyOsState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5)),
      ),
      child: Row(
        children: [
          // Timer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.studyOs.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_rounded, size: 14, color: AppColors.studyOs),
                const SizedBox(width: 6),
                Text(state.elapsedFormatted, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'monospace', color: AppColors.studyOs)),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Pomodoro phase
          if (state.pomodoroPhase != 'idle')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: state.pomodoroPhase == 'focus' ? AppColors.primary.withValues(alpha: 0.1) : AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                state.pomodoroPhase == 'focus' ? 'Focus ${state.pomodoroFormatted}' : 'Break ${state.pomodoroFormatted}',
                style: TextStyle(fontSize: 11, color: state.pomodoroPhase == 'focus' ? AppColors.primary : AppColors.success, fontWeight: FontWeight.w600),
              ),
            ),

          const Spacer(),

          // Distractions
          if (state.distractionCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded, size: 12, color: AppColors.error),
                  const SizedBox(width: 4),
                  Text('${state.distractionCount}', style: TextStyle(fontSize: 11, color: AppColors.error, fontWeight: FontWeight.w600)),
                ],
              ),
            ),

          const SizedBox(width: 8),

          // Exit button
          IconButton(
            onPressed: _showExitDialog,
            icon: const Icon(Icons.exit_to_app_rounded, size: 20),
            color: AppColors.error,
            tooltip: 'Exit Study Mode',
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    switch (_currentTab) {
      case 0:
        return const PomodoroScreen();
      case 1:
        return const AiHubScreen();
      case 2:
        return const SmartNotesScreen();
      case 3:
        return _buildDistractionInfo(isDark);
      default:
        return const Center(child: Text('Select a tab'));
    }
  }

  Widget _buildDistractionInfo(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_rounded, size: 48, color: AppColors.studyOs.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text('Study Mode Active', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
          const SizedBox(height: 8),
          Text('Distracting apps are blocked.\nStay focused on your goals.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
        ],
      ),
    );
  }

  Widget _buildBottomNav(bool isDark, StudyOsState state) {
    final tabs = [
      ('Timer', Icons.timer_rounded, AppColors.primary),
      ('AI Hub', Icons.smart_toy_rounded, AppColors.accent),
      ('Notes', Icons.note_alt_rounded, AppColors.success),
      ('Focus', Icons.lock_rounded, AppColors.studyOs),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (i) {
              final isSelected = _currentTab == i;
              return GestureDetector(
                onTap: () => setState(() => _currentTab = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? tabs[i].$3.withValues(alpha: 0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(tabs[i].$2, size: 20, color: isSelected ? tabs[i].$3 : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                      Text(tabs[i].$1, style: TextStyle(fontSize: 10, color: isSelected ? tabs[i].$3 : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight))),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
