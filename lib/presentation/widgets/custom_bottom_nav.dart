import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum BottomNavTab { home, subjects, add, progress, settings }

class CustomBottomNav extends StatelessWidget {
  final BottomNavTab currentTab;
  final Function(BottomNavTab) onTabChanged;

  const CustomBottomNav({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: currentTab == BottomNavTab.home,
                onTap: () => onTabChanged(BottomNavTab.home),
                isDark: isDark,
              ),
              _NavItem(
                icon: Icons.menu_book_rounded,
                label: 'Subjects',
                isSelected: currentTab == BottomNavTab.subjects,
                onTap: () => onTabChanged(BottomNavTab.subjects),
                isDark: isDark,
              ),
              _AddButton(
                onTap: () => onTabChanged(BottomNavTab.add),
                isDark: isDark,
              ),
              _NavItem(
                icon: Icons.bar_chart_rounded,
                label: 'Progress',
                isSelected: currentTab == BottomNavTab.progress,
                onTap: () => onTabChanged(BottomNavTab.progress),
                isDark: isDark,
              ),
              _NavItem(
                icon: Icons.settings_rounded,
                label: 'Settings',
                isSelected: currentTab == BottomNavTab.settings,
                onTap: () => onTabChanged(BottomNavTab.settings),
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isDark;

  const _AddButton({required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
