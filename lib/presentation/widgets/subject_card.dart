import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SubjectCard extends StatelessWidget {
  final String icon;
  final String name;
  final int totalChapters;
  final double progress;
  final VoidCallback onTap;

  const SubjectCard({
    super.key,
    required this.icon,
    required this.name,
    required this.totalChapters,
    this.progress = 0.0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? AppColors.borderDark
                : AppColors.borderLight,
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const Spacer(),
                if (progress > 0)
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: progress,
                          backgroundColor: isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progress >= 1.0
                                ? AppColors.success
                                : AppColors.primary,
                          ),
                          strokeWidth: 3,
                        ),
                        Text(
                          '${(progress * 100).toInt()}',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$totalChapters chapters',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.textTertiaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
