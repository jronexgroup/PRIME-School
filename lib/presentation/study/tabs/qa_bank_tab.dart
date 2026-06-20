import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class QaBankTab extends StatelessWidget {
  const QaBankTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.question_answer_outlined,
            size: 64,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
          const SizedBox(height: 16),
          Text(
            'Q&A Bank',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pre-generated exam-ready Q&A will appear here',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 24),
          _buildFilterChips(isDark),
        ],
      ),
    );
  }

  Widget _buildFilterChips(bool isDark) {
    final filters = ['MCQ', 'Short', 'Medium', 'Long'];

    return Wrap(
      spacing: 8,
      children: filters.map((filter) {
        return Chip(
          label: Text(filter),
          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          side: BorderSide(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
        );
      }).toList(),
    );
  }
}
