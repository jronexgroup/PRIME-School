import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/study_schedule.dart';
import '../../core/services/study_os/study_schedule_service.dart';
import '../../core/services/study_os/study_mode_service.dart';
import '../../core/services/study_os/study_mode_auth_service.dart';
import '../../blocs/study_os/study_os_bloc.dart';
import '../../blocs/study_os/study_os_event.dart';
import '../../blocs/study_os/study_os_state.dart';
import 'study_mode_screen.dart';
import 'analytics_screen.dart';
import 'rewards_screen.dart';
import 'ai_hub_screen.dart';
import 'pomodoro_screen.dart';
import 'password_dialog.dart';

class StudyOsHome extends StatefulWidget {
  const StudyOsHome({super.key});

  @override
  State<StudyOsHome> createState() => _StudyOsHomeState();
}

class _StudyOsHomeState extends State<StudyOsHome> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _initBloc();
  }

  void _initBloc() {
    final bloc = context.read<StudyOsBloc>();
    if (bloc.state.sessionState == StudyOsSessionState.idle) {
      bloc.add(const StudyOsStarted());
    }
  }

  void _startQuickSession() {
    final bloc = context.read<StudyOsBloc>();
    if (bloc.state.sessionState != StudyOsSessionState.idle) return;
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => const StudyModeScreen(),
    ));
  }

  void _showAddScheduleDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _ScheduleForm(
        onSave: (data) {
          context.read<StudyOsBloc>().add(StudyOsAddSchedule(data));
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _deleteScheduleWithAuth(StudySchedule schedule) async {
    final auth = context.read<StudyModeAuthService>();
    final verified = await showDialog<bool>(
      context: context,
      builder: (ctx) => PasswordVerifyDialog(
        auth: auth,
        title: 'Delete Schedule',
        message: 'Enter your password to delete "${schedule.name}".',
        onVerified: () => Navigator.of(ctx).pop(true),
      ),
    );
    if (verified == true) {
      context.read<StudyOsBloc>().add(StudyOsDeleteSchedule(schedule.id));
    }
  }

  void _toggleScheduleWithAuth(StudySchedule schedule) async {
    final auth = context.read<StudyModeAuthService>();
    final verified = await showDialog<bool>(
      context: context,
      builder: (ctx) => PasswordVerifyDialog(
        auth: auth,
        title: schedule.active ? 'Disable Schedule' : 'Enable Schedule',
        message: 'Enter your password to ${schedule.active ? 'disable' : 'enable'} "${schedule.name}".',
        onVerified: () => Navigator.of(ctx).pop(true),
      ),
    );
    if (verified == true) {
      context.read<StudyOsBloc>().add(StudyOsToggleSchedule(schedule.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<StudyOsBloc, StudyOsState>(
      builder: (context, state) {
        final schedules = context.read<StudyOsBloc>().scheduleService.getAllSchedules();
        final activeSchedules = schedules.where((s) => s.active).toList();
        final nowStudying = activeSchedules.isNotEmpty;

        return Scaffold(
          body: _selectedTab == 0 ? _buildHomeTab(context, isDark, state, schedules, nowStudying)
              : _selectedTab == 1 ? const AnalyticsScreen()
              : _selectedTab == 2 ? const RewardsScreen()
              : _selectedTab == 3 ? const AiHubScreen()
              : const PomodoroScreen(),
          bottomNavigationBar: _buildBottomNav(isDark),
          floatingActionButton: _selectedTab == 0
              ? FloatingActionButton.extended(
                  onPressed: _startQuickSession,
                  backgroundColor: AppColors.studyOs,
                  icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                  label: const Text('Start Study', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                )
              : null,
        );
      },
    );
  }

  Widget _buildBottomNav(bool isDark) {
    final tabs = [
      ('Home', Icons.home_rounded),
      ('Analytics', Icons.bar_chart_rounded),
      ('Rewards', Icons.auto_awesome_rounded),
      ('AI Hub', Icons.smart_toy_rounded),
      ('Timer', Icons.timer_rounded),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (i) {
              final isSelected = _selectedTab == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.studyOs.withValues(alpha: 0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(tabs[i].$2, size: 20, color: isSelected ? AppColors.studyOs : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                      Text(tabs[i].$1, style: TextStyle(fontSize: 9, color: isSelected ? AppColors.studyOs : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight))),
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

  Widget _buildHomeTab(BuildContext context, bool isDark, StudyOsState state, List<StudySchedule> schedules, bool nowStudying) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Study OS', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.5)),
                        Text('Stay focused. Learn better.', style: TextStyle(fontSize: 13, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                      ],
                    ),
                    Icon(Icons.psychology_rounded, color: AppColors.studyOs, size: 32),
                  ],
                ),
                const SizedBox(height: 16),

                // Today's schedule card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.studyOs.withValues(alpha: 0.15), AppColors.studyOs.withValues(alpha: 0.05)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.studyOs.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.schedule_rounded, size: 16, color: AppColors.studyOs),
                          const SizedBox(width: 6),
                          Text('Today\'s Schedule', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.studyOs)),
                          const Spacer(),
                          Text('${schedules.length} schedule${schedules.length != 1 ? 's' : ''}', style: TextStyle(fontSize: 11, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (schedules.isEmpty)
                        Text('No schedules yet. Tap + to create one.', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight))
                      else
                        ...schedules.take(3).map((s) => GestureDetector(
                          onLongPress: () => _deleteScheduleWithAuth(s),
                          onTap: () => _toggleScheduleWithAuth(s),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: s.active ? AppColors.success.withValues(alpha: 0.15) : AppColors.textTertiaryDark.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(s.active ? 'Active' : 'Off', style: TextStyle(fontSize: 9, color: s.active ? AppColors.success : AppColors.textTertiaryDark, fontWeight: FontWeight.w600)),
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(s.name, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight))),
                                Text('${s.startTimeFormatted}–${s.endTimeFormatted}', style: TextStyle(fontSize: 11, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                                const SizedBox(width: 4),
                                Icon(Icons.delete_outline_rounded, size: 14, color: AppColors.error.withValues(alpha: 0.5)),
                              ],
                            ),
                          ),
                        )),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _showAddScheduleDialog,
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text('Add Schedule', style: TextStyle(fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.studyOs,
                            side: BorderSide(color: AppColors.studyOs.withValues(alpha: 0.3)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Quick Stats row
                Row(
                  children: [
                    Expanded(child: _StatCard(isDark: isDark, icon: Icons.timer_outlined, label: 'Today', value: '${_getTodayMinutes()}m', color: AppColors.primary)),
                    const SizedBox(width: 8),
                    Expanded(child: _StatCard(isDark: isDark, icon: Icons.local_fire_department_rounded, label: 'Streak', value: '${context.read<StudyOsBloc>().rewardService.reward.streak}d', color: AppColors.warning)),
                    const SizedBox(width: 8),
                    Expanded(child: _StatCard(isDark: isDark, icon: Icons.auto_awesome_rounded, label: 'Level', value: '${context.read<StudyOsBloc>().rewardService.reward.level}', color: AppColors.studyOs)),
                  ],
                ),
                const SizedBox(height: 16),

                // Feature Grid
                Text('FEATURES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight, letterSpacing: 1)),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.4,
            ),
            delegate: SliverChildListDelegate([
              _FeatureCard(isDark: isDark, icon: Icons.timer_rounded, label: 'Pomodoro', color: AppColors.primary, onTap: () => setState(() => _selectedTab = 4)),
              _FeatureCard(isDark: isDark, icon: Icons.smart_toy_rounded, label: 'AI Hub', color: AppColors.accent, onTap: () => setState(() => _selectedTab = 3)),
              _FeatureCard(isDark: isDark, icon: Icons.bar_chart_rounded, label: 'Analytics', color: AppColors.success, onTap: () => setState(() => _selectedTab = 1)),
              _FeatureCard(isDark: isDark, icon: Icons.auto_awesome_rounded, label: 'Rewards', color: AppColors.warning, onTap: () => setState(() => _selectedTab = 2)),
            ]),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  int _getTodayMinutes() {
    final today = DateTime.now();
    final stats = context.read<StudyOsBloc>().analyticsService.getDailyStats(today);
    return stats?.totalMinutes ?? 0;
  }
}

class _StatCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({required this.isDark, required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
          Text(label, style: TextStyle(fontSize: 10, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({required this.isDark, required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
          ],
        ),
      ),
    );
  }
}

class _ScheduleForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  const _ScheduleForm({required this.onSave});

  @override
  State<_ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<_ScheduleForm> {
  final _nameCtrl = TextEditingController(text: 'Study Session');
  TimeOfDay _startTime = const TimeOfDay(hour: 19, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 21, minute: 0);
  List<int> _selectedDays = [1, 2, 3, 4, 5, 6, 7];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.add_rounded, size: 20, color: AppColors.studyOs),
              const SizedBox(width: 8),
              Text('New Schedule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
              const Spacer(),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded, size: 20)),
            ]),
            const SizedBox(height: 16),
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: 'Session Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: _TimePicker(label: 'Start', time: _startTime, onPicked: (t) => setState(() => _startTime = t), isDark: isDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TimePicker(label: 'End', time: _endTime, onPicked: (t) => setState(() => _endTime = t), isDark: isDark),
              ),
            ]),
            const SizedBox(height: 12),
            Text('Repeat on', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: List.generate(7, (i) {
                final selected = _selectedDays.contains(i + 1);
                return ChoiceChip(
                  label: Text(days[i], style: TextStyle(fontSize: 11, color: selected ? Colors.white : null)),
                  selected: selected,
                  selectedColor: AppColors.studyOs,
                  onSelected: (v) {
                    setState(() {
                      if (v) _selectedDays.add(i + 1);
                      else _selectedDays.remove(i + 1);
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onSave({
                    'name': _nameCtrl.text,
                    'startHour': _startTime.hour,
                    'startMinute': _startTime.minute,
                    'endHour': _endTime.hour,
                    'endMinute': _endTime.minute,
                    'daysOfWeek': _selectedDays,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.studyOs,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Create Schedule', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _TimePicker extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onPicked;
  final bool isDark;

  const _TimePicker({required this.label, required this.time, required this.onPicked, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(context: context, initialTime: time);
        if (picked != null) onPicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded, size: 16, color: AppColors.studyOs),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 10, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                Text(time.format(context), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
