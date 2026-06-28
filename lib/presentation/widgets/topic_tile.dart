import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class TopicTile extends StatelessWidget {
  final int order;
  final String name;
  final bool isCompleted;
  final bool isBookmarked;
  final VoidCallback onTap;

  const TopicTile({
    super.key,
    required this.order,
    required this.name,
    this.isCompleted = false,
    this.isBookmarked = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCompleted
                ? AppColors.success.withValues(alpha: 0.3)
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: isCompleted ? 1 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check_rounded, size: 16, color: AppColors.success)
                    : Text(
                        '$order',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ),
            if (isBookmarked)
              const Icon(
                Icons.bookmark_rounded,
                size: 16,
                color: AppColors.warning,
              ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
            ),
          ],
        ),
      ),
    );
  }
}
