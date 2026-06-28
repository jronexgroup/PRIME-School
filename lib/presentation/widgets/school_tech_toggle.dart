import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SchoolTechToggle extends StatelessWidget {
  final bool isSchool;
  final Function(bool) onToggle;

  const SchoolTechToggle({
    super.key,
    required this.isSchool,
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
            isSelected: isSchool,
            color: AppColors.school,
            isDark: isDark,
            onTap: () => onToggle(true),
          ),
          _ToggleOption(
            icon: Icons.computer_rounded,
            label: 'Tech',
            isSelected: !isSchool,
            color: AppColors.tech,
            isDark: isDark,
            onTap: () => onToggle(false),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
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
