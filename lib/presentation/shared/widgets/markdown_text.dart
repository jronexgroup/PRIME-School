import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../core/constants/app_colors.dart';

class MarkdownText extends StatelessWidget {
  final String data;
  final bool selectable;

  const MarkdownText(this.data, {super.key, this.selectable = true});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Markdown(
      data: data,
      selectable: selectable,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(
          fontSize: 13,
          height: 1.5,
          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
        ),
        code: TextStyle(
          fontSize: 12,
          fontFamily: 'monospace',
          color: isDark ? const Color(0xFFE879F9) : const Color(0xFF7C3AED),
          backgroundColor: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.06),
        ),
        codeblockDecoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
        ),
        h1: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
        ),
        h2: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
        ),
        h3: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
        ),
        strong: TextStyle(
          fontWeight: FontWeight.w700,
          color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
        ),
        blockquote: TextStyle(
          fontStyle: FontStyle.italic,
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(left: BorderSide(color: AppColors.accent, width: 3)),
          color: AppColors.accent.withValues(alpha: 0.06),
        ),
        listBullet: TextStyle(color: AppColors.tech),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
        ),
      ),
    );
  }
}
