import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ProgressTab extends StatelessWidget {
  final Map<String, dynamic> content;
  final List<Map<String, dynamic>> roadmap;
  final String topicId;

  const ProgressTab({
    super.key,
    required this.content,
    required this.roadmap,
    required this.topicId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final order = content['order'] as int? ?? 0;
    final totalTopics = roadmap.length;
    final currentTopicIndex = roadmap.indexWhere((r) => r['topicId'] == topicId);
    final progress = totalTopics > 0 ? ((currentTopicIndex + 1) / totalTopics * 100) : 0.0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Overall Progress Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.tech.withValues(alpha: 0.8), AppColors.tech.withValues(alpha: 0.3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text('Overall Progress', style: TextStyle(fontSize: 13, color: Colors.white70)),
              const SizedBox(height: 8),
              Text('${progress.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 4),
              Text('${currentTopicIndex + 1} of $totalTopics topics', style: TextStyle(fontSize: 12, color: Colors.white60)),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Skills Unlocked
        Container(
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
                  Icon(Icons.verified_rounded, size: 18, color: AppColors.success),
                  const SizedBox(width: 8),
                  Text('Skills Unlocked', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: _getSkills(order).map((s) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, size: 12, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text(s, style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w500)),
                    ],
                  ),
                )).toList(),
              ),
              if (order < 14) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: _getLockedSkills(order).map((s) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.black12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_outline, size: 12, color: isDark ? Colors.white24 : Colors.black26),
                        const SizedBox(width: 4),
                        Text(s, style: TextStyle(fontSize: 11, color: isDark ? Colors.white24 : Colors.black26)),
                      ],
                    ),
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Roadmap
        Container(
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
                  Icon(Icons.map_outlined, size: 18, color: AppColors.tech),
                  const SizedBox(width: 8),
                  Text('Course Roadmap', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                ],
              ),
              const SizedBox(height: 16),
              ...List.generate(roadmap.length, (index) {
                final topic = roadmap[index];
                final name = topic['name'] as String? ?? '';
                final tId = topic['topicId'] as String? ?? '';
                final isCurrent = tId == topicId;
                final isPassed = index < currentTopicIndex;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 24, height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCurrent
                                  ? AppColors.tech
                                  : (isPassed ? AppColors.success : (isDark ? Colors.white12 : Colors.black12)),
                            ),
                            child: Center(
                              child: isPassed
                                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                                  : Text('${index + 1}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: isCurrent ? Colors.white : (isDark ? Colors.white38 : Colors.black38))),
                            ),
                          ),
                          if (index < roadmap.length - 1)
                            Container(
                              width: 1,
                              height: 28,
                              color: isPassed
                                  ? AppColors.success.withValues(alpha: 0.5)
                                  : (isDark ? Colors.white10 : Colors.black12),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? AppColors.tech.withValues(alpha: 0.08)
                                : (isPassed ? AppColors.success.withValues(alpha: 0.05) : Colors.transparent),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(name, style: TextStyle(
                            fontSize: 12,
                            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                            color: isCurrent
                                ? AppColors.tech
                                : (isPassed ? AppColors.success : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                          )),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Stats
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
          ),
          child: Row(
            children: [
              _StatItem(icon: Icons.flag_rounded, label: 'Challenges', value: '${(content['challenges'] as List?)?.length ?? 0}', color: AppColors.tech, isDark: isDark),
              _StatItem(icon: Icons.code_rounded, label: 'Examples', value: '${(content['codeExamples'] as List?)?.length ?? 0}', color: AppColors.accent, isDark: isDark),
              _StatItem(icon: Icons.psychology_outlined, label: 'Concepts', value: '${(content['keyConcepts'] as List?)?.length ?? 0}', color: AppColors.success, isDark: isDark),
            ],
          ),
        ),
      ],
    );
  }

  List<String> _getSkills(int order) {
    const allSkills = [
      'Python Setup',
      'Variables & Types',
      'Strings',
      'Lists & Tuples',
      'Dicts & Sets',
      'Conditionals',
      'Loops',
      'Functions',
      'File I/O',
      'Exceptions',
      'OOP',
      'Modules & pip',
      'Advanced Python',
      'Projects',
    ];
    return allSkills.take(order).toList();
  }

  List<String> _getLockedSkills(int order) {
    const allSkills = [
      'Python Setup',
      'Variables & Types',
      'Strings',
      'Lists & Tuples',
      'Dicts & Sets',
      'Conditionals',
      'Loops',
      'Functions',
      'File I/O',
      'Exceptions',
      'OOP',
      'Modules & pip',
      'Advanced Python',
      'Projects',
    ];
    return allSkills.skip(order).toList();
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
          Text(label, style: TextStyle(fontSize: 10, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
        ],
      ),
    );
  }
}
