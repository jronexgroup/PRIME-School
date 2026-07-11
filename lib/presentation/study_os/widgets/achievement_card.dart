import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/reward.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool unlocked;
  final bool isNew;

  const AchievementCard({
    super.key,
    required this.achievement,
    this.unlocked = false,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: unlocked
            ? (isNew ? AppColors.studyOs.withValues(alpha: 0.1) : (isDark ? AppColors.cardDark : AppColors.cardLight))
            : (isDark ? AppColors.borderDark : AppColors.dividerLight),
        borderRadius: BorderRadius.circular(12),
        border: isNew
            ? Border.all(color: AppColors.studyOs, width: 1.5)
            : (unlocked ? Border.all(color: AppColors.studyOs.withValues(alpha: 0.3)) : null),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Text(achievement.icon, style: TextStyle(fontSize: isNew ? 28 : 24)),
              if (isNew)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.studyOs,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            achievement.name,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: unlocked
                  ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                  : AppColors.textTertiaryDark,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (unlocked && achievement.xpReward > 0) ...[
            const SizedBox(height: 4),
            Text(
              '+${achievement.xpReward} XP',
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: AppColors.studyOs),
            ),
          ],
        ],
      ),
    );
  }
}
