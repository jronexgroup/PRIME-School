import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/study_schedule.dart';

class ScheduleCard extends StatelessWidget {
  final StudySchedule schedule;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final bool isActive;

  const ScheduleCard({
    super.key,
    required this.schedule,
    this.onToggle,
    this.onDelete,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final activeDays = schedule.daysOfWeek.map((d) => dayNames[d - 1]).join(', ');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.studyOs.withValues(alpha: 0.08)
            : (isDark ? AppColors.cardDark : AppColors.cardLight),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? AppColors.studyOs.withValues(alpha: 0.3)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
          width: isActive ? 1.5 : 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: schedule.active ? AppColors.success.withValues(alpha: 0.15) : AppColors.textTertiaryDark.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  schedule.active ? 'Active' : 'Paused',
                  style: TextStyle(
                    fontSize: 9,
                    color: schedule.active ? AppColors.success : AppColors.textTertiaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  schedule.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ),
              if (onToggle != null)
                GestureDetector(
                  onTap: onToggle,
                  child: Icon(
                    schedule.active ? Icons.toggle_on_rounded : Icons.toggle_off_outlined,
                    color: schedule.active ? AppColors.success : AppColors.textTertiaryDark,
                    size: 28,
                  ),
                ),
              if (onDelete != null)
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error.withValues(alpha: 0.6)),
                  onPressed: onDelete,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 14, color: AppColors.studyOs),
              const SizedBox(width: 6),
              Text(
                '${schedule.startTimeFormatted} – ${schedule.endTimeFormatted}',
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.studyOs),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  activeDays,
                  style: TextStyle(fontSize: 11, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (schedule.durationMinutes > 0) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.timer_outlined, size: 14, color: AppColors.studyOs),
                const SizedBox(width: 6),
                Text(
                  '${schedule.durationMinutes} min session',
                  style: TextStyle(fontSize: 11, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
