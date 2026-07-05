import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../screens/cheatsheet_screen.dart';

class NotesTab extends StatelessWidget {
  final Map<String, dynamic> content;
  final String? chapterId;

  const NotesTab({super.key, required this.content, this.chapterId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final keyConcepts = (content['keyConcepts'] as List?)?.cast<String>() ?? [];
    final importantSyntax = (content['importantSyntax'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final commonMistakes = (content['commonMistakes'] as List?)?.cast<String>() ?? [];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Cheatsheet quick access
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => CheatsheetScreen(chapterId: chapterId),
          )),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.tech.withValues(alpha: 0.8), AppColors.primary.withValues(alpha: 0.4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Python Cheatsheet', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 3),
                      Text(chapterId != null ? 'Showing chapter-specific syntax' : 'Quick reference — syntax, functions, examples', style: TextStyle(fontSize: 11, color: Colors.white70)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.chevron_right_rounded, size: 18, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        if (keyConcepts.isNotEmpty) ...[
          _SectionCard(
            title: 'Key Concepts',
            icon: Icons.psychology_outlined,
            color: AppColors.tech,
            isDark: isDark,
            badge: '${keyConcepts.length} concepts',
            child: Wrap(
              spacing: 10, runSpacing: 10,
              children: keyConcepts.map((c) {
                final idx = keyConcepts.indexOf(c);
                final colors = [
                  AppColors.tech, AppColors.accent, AppColors.primary,
                  AppColors.warning, AppColors.success, AppColors.info,
                ];
                final color = colors[idx % colors.length];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withValues(alpha: 0.12), color.withValues(alpha: 0.04)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.terminal_rounded, size: 12, color: color),
                      const SizedBox(width: 6),
                      Text(c, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color, letterSpacing: 0.2)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],

        if (importantSyntax.isNotEmpty) ...[
          _SectionCard(
            title: 'Important Syntax',
            icon: Icons.code_rounded,
            color: AppColors.accent,
            isDark: isDark,
            badge: '${importantSyntax.length} items',
            child: Column(
              children: importantSyntax.map((s) {
                final syntax = s['syntax'] as String? ?? '';
                final example = s['example'] as String? ?? '';
                final description = s['description'] as String? ?? '';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F1225) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(Icons.arrow_right_alt, size: 16, color: AppColors.accent),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A1A2E),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(syntax, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFE879F9), fontFamily: 'monospace', height: 1.4)),
                                  ),
                                  if (example.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(example, style: const TextStyle(fontSize: 12, color: Color(0xFFA6E3A1), fontFamily: 'monospace', height: 1.5)),
                                  ],
                                  if (description.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(Icons.info_outline, size: 12, color: AppColors.info),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(description, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.4)),
                                        ),
                                      ],
                                    ),
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
          ),
          const SizedBox(height: 16),
        ],

        if (commonMistakes.isNotEmpty) ...[
          _SectionCard(
            title: 'Common Mistakes',
            icon: Icons.warning_amber_rounded,
            color: AppColors.error,
            isDark: isDark,
            badge: '${commonMistakes.length} warnings',
            child: Column(
              children: commonMistakes.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.error_outline, size: 14, color: AppColors.error),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(m, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.5)),
                      ),
                    ],
                  ),
                ),
              )).toList(),
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool isDark;
  final String? badge;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.isDark,
    this.badge,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.06),
            isDark ? AppColors.cardDark : AppColors.cardLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              ),
              if (badge != null) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(badge!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
