import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class NotesTab extends StatelessWidget {
  final Map<String, dynamic> content;

  const NotesTab({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final keyConcepts = (content['keyConcepts'] as List?)?.cast<String>() ?? [];
    final importantSyntax = (content['importantSyntax'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final commonMistakes = (content['commonMistakes'] as List?)?.cast<String>() ?? [];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (keyConcepts.isNotEmpty) ...[
          _buildSection(
            title: 'Key Concepts',
            icon: Icons.psychology_outlined,
            color: AppColors.tech,
            child: Wrap(
              spacing: 8, runSpacing: 8,
              children: keyConcepts.map((c) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.tech.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(c, style: TextStyle(fontSize: 12, color: AppColors.tech, height: 1.3)),
              )).toList(),
            ),
            isDark: isDark,
          ),
          const SizedBox(height: 16),
        ],
        if (importantSyntax.isNotEmpty) ...[
          _buildSection(
            title: 'Important Syntax',
            icon: Icons.code_rounded,
            color: AppColors.accent,
            child: Column(
              children: importantSyntax.map((s) {
                final syntax = s['syntax'] as String? ?? '';
                final example = s['example'] as String? ?? '';
                final description = s['description'] as String? ?? '';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.arrow_right_alt, size: 16, color: AppColors.accent),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(syntax, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFE879F9), fontFamily: 'monospace')),
                                  if (example.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(example, style: const TextStyle(fontSize: 11, color: Color(0xFFA6E3A1), fontFamily: 'monospace')),
                                  ],
                                  if (description.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(description, style: TextStyle(fontSize: 11, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            isDark: isDark,
          ),
          const SizedBox(height: 16),
        ],
        if (commonMistakes.isNotEmpty) ...[
          _buildSection(
            title: 'Common Mistakes',
            icon: Icons.warning_amber_rounded,
            color: AppColors.error,
            child: Column(
              children: commonMistakes.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.error_outline, size: 14, color: AppColors.error),
                    const SizedBox(width: 8),
                    Expanded(child: Text(m, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.4))),
                  ],
                ),
              )).toList(),
            ),
            isDark: isDark,
          ),
        ],
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
