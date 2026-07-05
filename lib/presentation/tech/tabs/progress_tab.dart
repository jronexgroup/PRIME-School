import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';

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

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final lastStudy = prefs.getString('last_study_date');
    final savedStreak = prefs.getInt('streak') ?? 0;
    if (lastStudy != null) {
      final last = DateTime.parse(lastStudy);
      final diff = today.difference(last).inDays;
      if (diff == 1) {
        await prefs.setInt('streak', savedStreak + 1);
        await prefs.setString('last_study_date', today.toIso8601String());
        setState(() => _streak = savedStreak + 1);
      } else if (diff == 0) {
        setState(() => _streak = savedStreak);
      } else {
        await prefs.setInt('streak', 1);
        await prefs.setString('last_study_date', today.toIso8601String());
        setState(() => _streak = 1);
      }
    } else {
      await prefs.setInt('streak', 1);
      await prefs.setString('last_study_date', today.toIso8601String());
      setState(() => _streak = 1);
    }
    setState(() {
      _easyDone = prefs.getInt('challenge_easy') ?? 0;
      _mediumDone = prefs.getInt('challenge_medium') ?? 0;
      _hardDone = prefs.getInt('challenge_hard') ?? 0;
    });
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
    final currentTopicIndex = widget.roadmap.indexWhere((r) => r['topicId'] == widget.topicId);
    final progress = totalTopics > 0 ? ((currentTopicIndex + 1) / totalTopics * 100) : 0.0;
    final chapterNames = _getChapterNames();
    final totalChapters = chapterNames.length;
    final currentChapter = currentTopicIndex >= 0
        ? ((currentTopicIndex / (totalTopics / totalChapters)).floor()).clamp(0, totalChapters - 1)
        : 0;

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
                final isCompleted = i < currentChapter;
                final isCurrent = i == currentChapter;
                final chapterProgress = isCompleted ? 1.0 : (isCurrent ? ((currentTopicIndex % (totalTopics ~/ totalChapters)) / (totalTopics / totalChapters)).clamp(0.0, 1.0) : 0.0);

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
                  ...chapterNames.take(currentChapter + 1).map((s) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, size: 10, color: AppColors.success),
                        const SizedBox(width: 4),
                        Text(s, style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )),
                  ...chapterNames.skip(currentChapter + 1).map((s) {
                    final prereqIndex = _getPrerequisite(currentChapter + 1, chapterNames.indexOf(s));
                    final isLocked = prereqIndex > currentChapter;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isLocked ? (isDark ? Colors.white10 : Colors.black12) : AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(isLocked ? Icons.lock_outline : Icons.check_circle_outline, size: 10, color: isLocked ? (isDark ? Colors.white24 : Colors.black26) : AppColors.warning),
                          const SizedBox(width: 4),
                          Text(s, style: TextStyle(fontSize: 10, color: isLocked ? (isDark ? Colors.white24 : Colors.black26) : AppColors.warning, fontWeight: FontWeight.w500)),
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
                final isPassed = index < currentTopicIndex;

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
                          child: Text(name, style: TextStyle(
                            fontSize: 11,
                            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                            color: isCurrent ? AppColors.tech : (isPassed ? AppColors.success : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
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

  Widget _buildChallengesBadge(int challenges, bool isDark) {
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
          Text('$challenges challenges', style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  int _getPrerequisite(int currentChapterIdx, int targetIdx) {
    const prerequisites = {
      1: 0,   // Ch 2 needs Ch 1
      2: 1,   // Ch 3 needs Ch 2
      3: 2,   // Ch 4 needs Ch 3
      4: 3,   // Ch 5 needs Ch 4
      5: 4,   // Ch 6 needs Ch 5
      6: 5,   // Ch 7 needs Ch 6
      7: 6,   // Ch 8 needs Ch 7
      8: 7,   // Ch 9 needs Ch 8
      9: 8,   // Ch 10 needs Ch 9
      10: 9,  // Ch 11 needs Ch 10
      11: 10, // Ch 12 needs Ch 11
      12: 11, // Ch 13 needs Ch 12
      13: 12, // Projects needs all
    };
    return prerequisites[targetIdx] ?? targetIdx - 1;
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
