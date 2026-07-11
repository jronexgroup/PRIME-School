import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../blocs/study_os/study_os_bloc.dart';
import '../../blocs/study_os/study_os_state.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<StudyOsBloc, StudyOsState>(
      builder: (context, state) {
        final analytics = context.read<StudyOsBloc>().analyticsService;
        final reward = context.read<StudyOsBloc>().rewardService.reward;
        final totalMinutes = analytics.getTotalMinutes();
        final totalSessions = analytics.getTotalSessions();
        final totalDistractions = analytics.getTotalDistractions();
        final subjectBreakdown = analytics.getSubjectTimeBreakdown();
        final today = DateTime.now();

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Study Analytics', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                  const SizedBox(height: 4),
                  Text('Your learning journey visualized', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                  const SizedBox(height: 20),

                  // Summary cards
                  Row(children: [
                    Expanded(child: _MetricCard(isDark: isDark, icon: Icons.timer_outlined, value: '${totalMinutes ~/ 60}h ${totalMinutes % 60}m', label: 'Total Time', color: AppColors.primary)),
                    const SizedBox(width: 8),
                    Expanded(child: _MetricCard(isDark: isDark, icon: Icons.flag_rounded, value: '$totalSessions', label: 'Sessions', color: AppColors.success)),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: _MetricCard(isDark: isDark, icon: Icons.warning_amber_rounded, value: '$totalDistractions', label: 'Distractions', color: AppColors.error)),
                    const SizedBox(width: 8),
                    Expanded(child: _MetricCard(isDark: isDark, icon: Icons.local_fire_department_rounded, value: '${reward.streak} days', label: 'Streak', color: AppColors.warning)),
                  ]),
                  const SizedBox(height: 20),

                  // Weekly chart
                  Text('THIS WEEK', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  Container(
                    height: 180,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
                    ),
                    child: _buildWeeklyChart(isDark, analytics),
                  ),
                  const SizedBox(height: 20),

                  // Subject breakdown
                  Text('SUBJECTS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
                    ),
                    child: subjectBreakdown.isEmpty
                        ? Center(child: Text('No data yet', style: TextStyle(color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)))
                        : PieChart(
                            PieChartData(
                              sections: subjectBreakdown.entries.map((e) {
                                final colors = [AppColors.primary, AppColors.accent, AppColors.success, AppColors.warning, AppColors.error, AppColors.tech, AppColors.school];
                                final idx = subjectBreakdown.keys.toList().indexOf(e.key);
                                return PieChartSectionData(
                                  value: e.value.toDouble(),
                                  title: '${e.key}',
                                  color: colors[idx % colors.length],
                                  radius: 40,
                                  titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                                );
                              }).toList(),
                              sectionsSpace: 2,
                              centerSpaceRadius: 30,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),

                  // Recent sessions
                  Text('RECENT SESSIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight, letterSpacing: 1)),
                  const SizedBox(height: 12),
                ],
              ),
            )),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  analytics.getSessionsForRange(today.subtract(const Duration(days: 7)), today).take(10).map((s) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.cardLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
                      ),
                      child: Row(children: [
                        Icon(Icons.circle_rounded, size: 8, color: s.completed ? AppColors.success : AppColors.warning),
                        const SizedBox(width: 10),
                        Expanded(child: Text(s.durationFormatted, style: TextStyle(fontSize: 13, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight))),
                        Text('${s.xpEarned} XP', style: TextStyle(fontSize: 11, color: AppColors.studyOs, fontWeight: FontWeight.w600)),
                      ]),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      },
    );
  }

  Widget _buildWeeklyChart(bool isDark, dynamic analytics) {
    final today = DateTime.now();
    final weekData = List.generate(7, (i) {
      final date = today.subtract(Duration(days: 6 - i));
      final stats = analytics.getDailyStats(date);
      return stats?.totalMinutes ?? 0;
    });

    final maxY = weekData.reduce((a, b) => a > b ? a : b).toDouble().clamp(10, double.infinity);

    return BarChart(BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY * 1.2,
      barTouchData: BarTouchData(enabled: true),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, _) {
            final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
            final idx = value.toInt();
            if (idx < 0 || idx >= days.length) return const SizedBox();
            return Padding(padding: const EdgeInsets.only(top: 4), child: Text(days[idx], style: TextStyle(fontSize: 10, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)));
          },
          reservedSize: 20,
        )),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (value, _) => Text('${value.toInt()}m', style: TextStyle(fontSize: 9, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)))),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: maxY / 4),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(7, (i) => BarChartGroupData(x: i, barRods: [
        BarChartRodData(toY: weekData[i].toDouble(), color: AppColors.studyOs, width: 12, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
      ])),
    ));
  }
}

class _MetricCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MetricCard({required this.isDark, required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
              Text(label, style: TextStyle(fontSize: 10, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
            ],
          ),
        ],
      ),
    );
  }
}
