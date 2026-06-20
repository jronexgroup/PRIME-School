import 'package:flutter/material.dart';
import '../../data/models/subject_model.dart';
import '../../core/constants/app_colors.dart';

class SubjectCard extends StatelessWidget {
  final SubjectModel subject;
  final VoidCallback onTap;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  subject.icon,
                  style: const TextStyle(fontSize: 28),
                ),
                const Spacer(),
                if (subject.progress > 0)
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      value: subject.progress,
                      backgroundColor: isDark
                          ? AppColors.dividerDark
                          : AppColors.dividerLight,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        subject.progress >= 1.0
                            ? AppColors.success
                            : AppColors.primary,
                      ),
                      strokeWidth: 3,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              subject.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${subject.totalChapters} chapters',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
