import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/progress_service.dart';

class ProgressTab extends StatefulWidget {
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
  State<ProgressTab> createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab> {
  int _streak = 0;
  int _easyDone = 0;
  int _mediumDone = 0;
  int _hardDone = 0;
  List<String> _completedTopics = [];
  List<String> _completedChapters = [];
  int _totalChallengesSolved = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final progress = await context.read<ProgressService>().getProgress('python');
      if (!mounted) return;
      final stats = progress['challengeStats'] as Map<String, dynamic>? ?? {};
      setState(() {
        _streak = progress['streak'] as int? ?? 0;
        _easyDone = (stats['easy'] as int? ?? 0);
        _mediumDone = (stats['medium'] as int? ?? 0);
        _hardDone = (stats['hard'] as int? ?? 0);
        _totalChallengesSolved = _easyDone + _mediumDone + _hardDone;
        _completedTopics = List<String>.from(progress['completedTopics'] ?? []);
        _completedChapters = List<String>.from(progress['completedChapters'] ?? []);
      });
    } catch (_) {}
  }

  List<String> _getChapterNames() {
    return const [
      'Python Setup',
      'Variables & Types',
      'Strings',
      'Lists & Tuples',
      'Dicts & Sets',
      'Conditionals',
      'Loops',
      'Functions',
      'File I/O',
      'OOP',
      'Inheritance',
      'Advanced 1',
      'Advanced 2',
      'Projects',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalTopics = widget.roadmap.length;
    final completedCount = _completedTopics.length;
    final progress = totalTopics > 0 ? (completedCount / totalTopics * 100) : 0.0;
    final chapterNames = _getChapterNames();

    final challenges = (widget.content['challenges'] as List?)?.length ?? 0;
    final codeExamples = (widget.content['codeExamples'] as List?)?.length ?? 0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Overall Progress
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStreakBadge(isDark),
                  _buildChallengesBadge(challenges, isDark),
                ],
              ),
              const SizedBox(height: 16),
              Text('Overall Progress', style: TextStyle(fontSize: 13, color: Colors.white70)),
              const SizedBox(height: 4),
              Text('${progress.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 4),
              Text('$completedCount of $totalTopics topics', style: TextStyle(fontSize: 12, color: Colors.white60)),
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

        // Chapter Progress Bars
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
                  Icon(Icons.bar_chart_rounded, size: 18, color: AppColors.tech),
                  const SizedBox(width: 8),
                  Text('Chapter Progress', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                ],
              ),
              const SizedBox(height: 16),
              ...List.generate(chapterNames.length, (i) {
                final cid = 'ch${i + 1}';
                final chapterTopics = widget.roadmap.where((r) {
                  final rcId = r['chapterId'] as String? ?? '';
                  return rcId == cid || rcId == chapterNames[i].toLowerCase().replaceAll(' ', '_');
                }).toList();
                final chapterCompleted = chapterTopics.where((t) {
                  return _completedTopics.contains(t['topicId']);
                }).length;
                final chapterTotal = chapterTopics.length;
                final isCompleted = _completedChapters.contains(cid) || (chapterTotal > 0 && chapterCompleted == chapterTotal);
                final isCurrent = chapterTotal > 0 && chapterCompleted < chapterTotal && chapterCompleted > 0;
                final chapterProgress = chapterTotal > 0 ? chapterCompleted / chapterTotal : 0.0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isCompleted ? Icons.check_circle : (isCurrent ? Icons.play_circle_fill : Icons.lock_outline),
                            size: 14,
                            color: isCompleted ? AppColors.success : (isCurrent ? AppColors.tech : (isDark ? Colors.white24 : Colors.black26)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              chapterNames[i],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                                color: isCompleted
                                    ? AppColors.success
                                    : (isCurrent
                                        ? AppColors.tech
                                        : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                              ),
                            ),
                          ),
                          Text('${(chapterProgress * 100).toInt()}%', style: TextStyle(fontSize: 10, color: isCompleted ? AppColors.success : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight))),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: chapterProgress,
                          backgroundColor: isDark ? Colors.white10 : Colors.black12,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isCompleted ? AppColors.success : (isCurrent ? AppColors.tech : (isDark ? Colors.white24 : Colors.black26)),
                          ),
                          minHeight: 4,
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

        // Stats Row
        Row(
          children: [
            Expanded(child: _StatCard(icon: Icons.flag_rounded, label: 'Total', value: '$challenges', color: AppColors.tech, isDark: isDark)),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(icon: Icons.code_rounded, label: 'Examples', value: '$codeExamples', color: AppColors.accent, isDark: isDark)),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(icon: Icons.whatshot_rounded, label: 'Streak', value: '$_streak days', color: AppColors.warning, isDark: isDark)),
          ],
        ),
        const SizedBox(height: 16),

        // Challenge Difficulty Breakdown
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
                  Icon(Icons.flag_rounded, size: 18, color: AppColors.tech),
                  const SizedBox(width: 8),
                  Text('Challenge Progress', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                ],
              ),
              const SizedBox(height: 14),
              _DiffRow(label: 'Easy', done: _easyDone, color: AppColors.success, isDark: isDark),
              const SizedBox(height: 10),
              _DiffRow(label: 'Medium', done: _mediumDone, color: AppColors.accent, isDark: isDark),
              const SizedBox(height: 10),
              _DiffRow(label: 'Hard', done: _hardDone, color: AppColors.error, isDark: isDark),
            ],
          ),
        ),
        const SizedBox(height: 16),

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
                spacing: 6, runSpacing: 6,
                children: [
                  ...chapterNames.map((s) {
                    final cid = 'ch${chapterNames.indexOf(s) + 1}';
                    final isUnlocked = _completedChapters.contains(cid) || _completedTopics.where((t) => t.startsWith(cid)).isNotEmpty;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isUnlocked ? AppColors.success.withValues(alpha: 0.1) : (isDark ? Colors.white10 : Colors.black12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(isUnlocked ? Icons.check_circle : Icons.lock_outline, size: 10, color: isUnlocked ? AppColors.success : (isDark ? Colors.white24 : Colors.black26)),
                          const SizedBox(width: 4),
                          Text(s, style: TextStyle(fontSize: 10, color: isUnlocked ? AppColors.success : (isDark ? Colors.white24 : Colors.black26), fontWeight: FontWeight.w500)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
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
              ...List.generate(widget.roadmap.length, (index) {
                final topic = widget.roadmap[index];
                final name = topic['name'] as String? ?? '';
                final tId = topic['topicId'] as String? ?? '';
                final isCurrent = tId == widget.topicId;
                final isPassed = _completedTopics.contains(tId);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 22, height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCurrent ? AppColors.tech : (isPassed ? AppColors.success : (isDark ? Colors.white12 : Colors.black12)),
                            ),
                            child: Center(
                              child: isPassed
                                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                                  : Text('${index + 1}', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: isCurrent ? Colors.white : (isDark ? Colors.white38 : Colors.black38))),
                            ),
                          ),
                          if (index < widget.roadmap.length - 1)
                            Container(width: 1, height: 24, color: isPassed ? AppColors.success.withValues(alpha: 0.5) : (isDark ? Colors.white10 : Colors.black12)),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isCurrent ? AppColors.tech.withValues(alpha: 0.08) : (isPassed ? AppColors.success.withValues(alpha: 0.05) : Colors.transparent),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(name, style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                                  color: isCurrent ? AppColors.tech : (isPassed ? AppColors.success : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                                )),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStreakBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.whatshot_rounded, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text('$_streak day streak', style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildChallengesBadge(int _, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.flag_rounded, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text('$_totalChallengesSolved challenges', style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

}

class _DiffRow extends StatelessWidget {
  final String label;
  final int done;
  final Color color;
  final bool isDark;

  const _DiffRow({required this.label, required this.done, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
        const Spacer(),
        Text('$done solved', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
        const SizedBox(width: 6),
        Icon(Icons.check_circle_rounded, size: 14, color: done > 0 ? color : (isDark ? Colors.white12 : Colors.black12)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
          Text(label, style: TextStyle(fontSize: 10, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
        ],
      ),
    );
  }
}
