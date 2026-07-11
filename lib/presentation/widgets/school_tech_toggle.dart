import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum AppMode { school, tech, studyOs }

class SchoolTechToggle extends StatelessWidget {
  final AppMode currentMode;
  final Function(AppMode) onToggle;

  const SchoolTechToggle({
    super.key,
    required this.currentMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.dividerLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleOption(
            icon: Icons.school_rounded,
            label: 'School',
            isSelected: currentMode == AppMode.school,
            color: AppColors.school,
            isDark: isDark,
            onTap: () => onToggle(AppMode.school),
          ),
          const SizedBox(width: 2),
          _ToggleOption(
            icon: Icons.computer_rounded,
            label: 'Tech',
            isSelected: currentMode == AppMode.tech,
            color: AppColors.tech,
            isDark: isDark,
            onTap: () => onToggle(AppMode.tech),
          ),
          const SizedBox(width: 2),
          _ToggleOption(
            icon: Icons.psychology_rounded,
            label: 'Study',
            isSelected: currentMode == AppMode.studyOs,
            color: AppColors.warning,
            isDark: isDark,
            onTap: () => onToggle(AppMode.studyOs),
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _ToggleOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
