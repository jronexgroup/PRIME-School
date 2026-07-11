import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/achievement_definitions.dart';
import '../../blocs/study_os/study_os_bloc.dart';
import '../../blocs/study_os/study_os_state.dart';
import 'widgets/reward_animation.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<StudyOsBloc, StudyOsState>(
      builder: (context, state) {
        final reward = context.read<StudyOsBloc>().rewardService.reward;
        final analytics = context.read<StudyOsBloc>().analyticsService;
        final totalSessions = analytics.getTotalSessions();
        final totalMinutes = analytics.getTotalMinutes();

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rewards', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                  const SizedBox(height: 4),
                  Text('Earn XP, badges, and achievements', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                  const SizedBox(height: 20),

                  // Level card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.studyOs, AppColors.studyOs.withValues(alpha: 0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text('Level ${reward.level}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white)),
                        const SizedBox(height: 8),
                        Row(children: [
                          const Text('XP', style: TextStyle(fontSize: 12, color: Colors.white70)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: reward.levelProgress,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                minHeight: 8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${reward.xpProgressInLevel}/${reward.xpForNextLevel}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                        ]),
                        const SizedBox(height: 12),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                          _RewardStat(label: 'Total XP', value: '${reward.xp}', icon: Icons.auto_awesome_rounded),
                          _RewardStat(label: 'Coins', value: '${reward.coins}', icon: Icons.monetization_on_rounded),
                          _RewardStat(label: 'Streak', value: '${reward.streak}d', icon: Icons.local_fire_department_rounded),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // XP breakdown
                  Text('XP BREAKDOWN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
                    ),
                    child: Column(children: [
                      _XpRow(isDark: isDark, label: 'Study Time', value: '$totalMinutes XP', detail: '$totalMinutes minutes studied'),
                      const Divider(height: 16),
                      _XpRow(isDark: isDark, label: 'Sessions', value: '$totalSessions XP', detail: '$totalSessions completed'),
                      const Divider(height: 16),
                      _XpRow(isDark: isDark, label: 'Level', value: '${reward.level}', detail: '${reward.xp} total XP'),
                    ]),
                  ),
                  const SizedBox(height: 20),

                  // Badges
                  Text('BADGES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight, letterSpacing: 1)),
                  const SizedBox(height: 12),
                ],
              ),
            )),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final achievement = AchievementDefinitions.all[index];
                  final unlocked = reward.unlockedAchievements.contains(achievement.id);
                  return Container(
                    decoration: BoxDecoration(
                      color: unlocked ? (isDark ? AppColors.cardDark : AppColors.cardLight) : (isDark ? AppColors.borderDark : AppColors.dividerLight),
                      borderRadius: BorderRadius.circular(12),
                      border: unlocked ? Border.all(color: AppColors.studyOs.withValues(alpha: 0.3)) : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(unlocked ? achievement.icon : '🔒', style: TextStyle(fontSize: 22)),
                        const SizedBox(height: 4),
                        Text(achievement.name, style: TextStyle(fontSize: 7, color: unlocked ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight) : AppColors.textTertiaryDark), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  );
                }, childCount: AchievementDefinitions.all.length),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        );
      },
    );
  }
}

class _RewardStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _RewardStat({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(icon, size: 20, color: Colors.white),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
      Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70)),
    ]);
  }
}

class _XpRow extends StatelessWidget {
  final bool isDark;
  final String label, value, detail;
  const _XpRow({required this.isDark, required this.label, required this.value, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight))),
      Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.studyOs)),
      const SizedBox(width: 4),
      Text(detail, style: TextStyle(fontSize: 10, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
    ]);
  }
}
