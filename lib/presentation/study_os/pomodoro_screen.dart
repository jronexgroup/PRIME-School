import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../blocs/study_os/study_os_bloc.dart';
import '../../blocs/study_os/study_os_state.dart';
import '../../core/services/study_os/pomodoro_service.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseAnim;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseAnim = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _pulse = Tween<double>(begin: 1.0, end: 1.05).animate(CurvedAnimation(parent: _pulseAnim, curve: Curves.easeInOut));
    _pulseAnim.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bloc = context.read<StudyOsBloc>();
    final pomoService = bloc.pomodoroService;

    return BlocBuilder<StudyOsBloc, StudyOsState>(
      builder: (context, state) {
        final isRunning = pomoService.isRunning;
        final isFocus = pomoService.isFocus;
        final isBreak = pomoService.isBreak;
        final phaseColor = isFocus ? AppColors.primary : (isBreak ? AppColors.success : AppColors.studyOs);

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Phase label
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: phaseColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isFocus ? 'FOCUS TIME' : (isBreak ? 'BREAK TIME' : 'POMODORO'),
                    style: TextStyle(fontSize: 11, color: phaseColor, fontWeight: FontWeight.w700, letterSpacing: 2),
                  ),
                ),
                const SizedBox(height: 32),

                // Timer circle
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, _) {
                    return Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: phaseColor.withValues(alpha: isRunning ? 0.08 : 0.05),
                        border: Border.all(color: phaseColor.withValues(alpha: 0.3), width: 3),
                        boxShadow: isRunning ? [
                          BoxShadow(color: phaseColor.withValues(alpha: 0.15), blurRadius: 30, spreadRadius: 5),
                        ] : null,
                      ),
                      child: Transform.scale(
                        scale: _pulse.value,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              pomoService.isRunning || pomoService.secondsRemaining > 0
                                  ? state.pomodoroFormatted
                                  : '25:00',
                              style: TextStyle(fontSize: 52, fontWeight: FontWeight.w300, fontFamily: 'monospace', color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${pomoService.cyclesCompleted} cycles',
                              style: TextStyle(fontSize: 12, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),

                // Control buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isRunning && pomoService.secondsRemaining == 0)
                      _ControlButton(
                        icon: Icons.play_arrow_rounded,
                        label: 'Start Focus',
                        color: AppColors.primary,
                        onTap: () => pomoService.startFocus(),
                      ),
                    if (!isRunning && pomoService.secondsRemaining > 0)
                      _ControlButton(
                        icon: Icons.play_arrow_rounded,
                        label: 'Resume',
                        color: phaseColor,
                        onTap: () => pomoService.resume(),
                      ),
                    if (isRunning)
                      _ControlButton(
                        icon: Icons.pause_rounded,
                        label: 'Pause',
                        color: AppColors.warning,
                        onTap: () => pomoService.pause(),
                      ),
                    const SizedBox(width: 12),
                    if (isBreak)
                      _ControlButton(
                        icon: Icons.skip_next_rounded,
                        label: 'Skip Break',
                        color: AppColors.accent,
                        onTap: () => pomoService.skipBreak(),
                      ),
                    if (pomoService.secondsRemaining > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: _ControlButton(
                          icon: Icons.stop_rounded,
                          label: 'Reset',
                          color: AppColors.error,
                          onTap: () => pomoService.reset(),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 32),

                // Focus tips
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.tips_and_updates_rounded, size: 18, color: AppColors.studyOs),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isFocus
                              ? 'Stay focused on one task. Close all distractions.'
                              : (isBreak ? 'Stand up, stretch, and hydrate.' : 'Set a timer and start your study session.'),
                          style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ControlButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
