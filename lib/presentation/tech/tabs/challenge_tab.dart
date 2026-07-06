import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/services/progress_service.dart';
import '../../shared/widgets/markdown_text.dart';

class ChallengeTab extends StatefulWidget {
  final Map<String, dynamic> content;
  final String subjectId;
  final String chapterId;
  final String topicId;
  final List<Map<String, dynamic>> roadmap;

  const ChallengeTab({
    super.key,
    required this.content,
    required this.subjectId,
    required this.chapterId,
    required this.topicId,
    required this.roadmap,
  });

  @override
  State<ChallengeTab> createState() => _ChallengeTabState();
}

class _ChallengeTabState extends State<ChallengeTab> {
  final Map<String, TextEditingController> _codeControllers = {};
  final Map<String, bool> _submitted = {};
  final Map<String, String> _aiFeedback = {};
  final Map<String, bool> _checking = {};
  final Map<String, bool> _solved = {};
  final Map<String, int> _hintLevel = {};
  final Map<String, int> _attempts = {};
  int _easyDone = 0;
  int _mediumDone = 0;
  int _hardDone = 0;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    try {
      final progress = context.read<ProgressService>();
      final progressData = await progress.getProgress(widget.subjectId);
      final submissions = Map<String, dynamic>.from(progressData['challengeSubmissions'] ?? {});
      final completedChallenges = List<String>.from(progressData['completedChallenges'] ?? []);
      final stats = progressData['challengeStats'] as Map<String, dynamic>? ?? {};
      final challenges = (widget.content['challenges'] as List?)?.cast<Map<String, dynamic>>() ?? [];

      for (final c in challenges) {
        final id = c['question'] as String? ?? '';
        final key = '${widget.chapterId}/${widget.topicId}/$id';
        final submission = submissions[key] as Map<String, dynamic>?;
        final isCompleted = completedChallenges.contains(key);

        if (submission != null) {
          final code = submission['code'] as String? ?? '';
          final feedback = submission['feedback'] as String? ?? '';
          final submissionSolved = submission['solved'] as bool? ?? false;
          final solved = submissionSolved || isCompleted;

          final controller = _codeControllers.putIfAbsent(id, () => TextEditingController());
          if (code.isNotEmpty) controller.text = code;

          if (feedback.isNotEmpty) {
            _aiFeedback[id] = feedback;
            _submitted[id] = true;
            _solved[id] = solved;
            _attempts[id] = submission['attempts'] as int? ?? 0;
          } else if (solved) {
            _submitted[id] = true;
            _solved[id] = true;
          }
        } else if (isCompleted) {
          // Challenge is in completedChallenges but submission data is missing
          // (e.g., corrupted by dot-in-key bug in older writes, or update failed)
          _submitted[id] = true;
          _solved[id] = true;
        }
      }

      if (mounted) {
        setState(() {
          _easyDone = (stats['easy'] as int? ?? 0);
          _mediumDone = (stats['medium'] as int? ?? 0);
          _hardDone = (stats['hard'] as int? ?? 0);
        });
      }
    } catch (_) {}
  }

  void _incrementLocalStat(String difficulty) {
    if (difficulty == 'easy') {
      _easyDone++;
    } else if (difficulty == 'medium') {
      _mediumDone++;
    } else {
      _hardDone++;
    }
  }

  @override
  void dispose() {
    for (final c in _codeControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _generateHint(String hint, int level) {
    final hints = hint.split('|');
    if (hints.length >= 3) return hints[level].trim();
    switch (level) {
      case 0:
        return 'Concept: $hint';
      case 1:
        return 'Approach: Think step by step. $hint';
      case 2:
        return 'Almost there: Here is the structure. $hint';
      default:
        return hint;
    }
  }

  Future<void> _pasteCode(String id) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _codeControllers.putIfAbsent(id, () => TextEditingController());
      _codeControllers[id]!.text = data!.text!;
      if (mounted) setState(() {});
    }
  }

  Future<void> _saveSubmission(String id, String code, String feedback, bool solved, String difficulty, {int attempts = 1}) async {
    try {
      final progress = context.read<ProgressService>();
      final challengeKey = '${widget.chapterId}/${widget.topicId}/$id';
      await progress.saveChallengeSubmission(
        widget.subjectId,
        challengeKey,
        code,
        feedback,
        solved,
        difficulty,
        timestamp: DateTime.now().toIso8601String(),
        attempts: attempts,
      );
    } catch (_) {}
  }

  bool _isCorrectAnswer(String feedback) {
    final trimmed = feedback.trim();

    // 1. Strict prefix/emoji check
    if (trimmed.startsWith('✓ CORRECT') || trimmed.startsWith('✅')) return true;
    if (trimmed.startsWith('✗ INCORRECT')) return false;

    // 2. Structured VERDICT tag anywhere in the text (from updated prompt)
    if (trimmed.contains('VERDICT: CORRECT')) return true;
    if (trimmed.contains('VERDICT: INCORRECT')) return false;

    // 3. Loose fallback: word-boundary check on first 300 chars only
    //    \bcorrect\b matches "correct" but NOT "incorrect" or "correctly"
    final snippet = trimmed.length > 300 ? trimmed.substring(0, 300) : trimmed;
    final hasCorrect = RegExp(r'\bcorrect\b', caseSensitive: false).hasMatch(snippet);
    final hasIncorrect = RegExp(r'\bincorrect\b', caseSensitive: false).hasMatch(snippet);
    if (hasCorrect && !hasIncorrect) return true;

    return false;
  }

  Future<void> _submitChallenge(Map<String, dynamic> challenge) async {
    final id = challenge['question'] as String? ?? '';
    _codeControllers.putIfAbsent(id, () => TextEditingController());
    final code = _codeControllers[id]!.text.trim();
    if (code.isEmpty) return;

    // Prevent re-submitting already solved challenges
    if (_solved[id] == true) return;

    setState(() => _checking[id] = true);

    try {
      final ai = context.read<AiService>();
      final correctAnswer = challenge['solution'] as String? ?? '';
      if (correctAnswer.isEmpty) {
        throw Exception('No solution available for this challenge');
      }
      final feedback = await ai.checkAnswer(
        challenge['question'] as String? ?? '',
        code,
        correctAnswer,
      );
      final difficulty = challenge['difficulty'] as String? ?? 'easy';

      final isCorrect = _isCorrectAnswer(feedback);

      if (isCorrect) {
        _incrementLocalStat(difficulty);
        final progress = context.read<ProgressService>();
        final challengeKey = '${widget.chapterId}/${widget.topicId}/$id';
        await progress.markChallengeComplete(widget.subjectId, challengeKey, difficulty);

        final challenges = (widget.content['challenges'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        final topicChallengeIds = challenges
            .map((c) => '${widget.chapterId}/${widget.topicId}/${c['question']}')
            .toList();
        await progress.autoCompleteTopic(widget.subjectId, widget.topicId, topicChallengeIds);

        final chapterTopics = widget.roadmap
            .where((t) => t['chapterId'] == widget.chapterId)
            .map((t) => t['topicId'] as String)
            .toList();
        await progress.autoCompleteChapter(widget.subjectId, widget.chapterId, chapterTopics);
      } else {
        // Explicitly do NOT update progress or mark challenge as complete
        // Only save the submission with solved=false
      }

      final currentAttempts = (_attempts[id] ?? 0) + 1;
      await _saveSubmission(
        id,
        code,
        feedback,
        isCorrect,
        difficulty,
        attempts: currentAttempts,
      );

      if (mounted) {
        setState(() {
          _aiFeedback[id] = feedback;
          _submitted[id] = true;
          _solved[id] = isCorrect;
          _attempts[id] = currentAttempts;
          _checking[id] = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _aiFeedback[id] = e is Exception ? e.toString().replaceFirst('Exception: ', '') : 'AI feedback unavailable. Check your solution manually.';
          _submitted[id] = true;
          _solved[id] = false;
          _checking[id] = false;
        });
      }
    }
  }

  void _showSolution(String solution, String userCode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.compare_arrows_rounded, color: AppColors.tech),
                const SizedBox(width: 8),
                Text('Compare Solutions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your Code', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.warning)),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E2E),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SingleChildScrollView(
                              child: SelectableText(
                                userCode.isEmpty ? '(No code written)' : userCode,
                                style: const TextStyle(fontSize: 11, color: Color(0xFFCDD6F4), fontFamily: 'monospace', height: 1.5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Solution', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.success)),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E2E),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SingleChildScrollView(
                              child: SelectableText(
                                solution,
                                style: const TextStyle(fontSize: 11, color: Color(0xFFA6E3A1), fontFamily: 'monospace', height: 1.5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final challenges = (widget.content['challenges'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    if (challenges.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flag_outlined, size: 48, color: isDark ? Colors.white24 : Colors.black26),
            const SizedBox(height: 12),
            Text('No challenges yet', style: TextStyle(fontSize: 14, color: isDark ? Colors.white38 : Colors.black38)),
          ],
        ),
      );
    }

    return Column(
      children: [
        _buildStatsBar(isDark),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: challenges.length,
            itemBuilder: (context, index) => _buildChallenge(challenges[index], isDark, index),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        border: Border(bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5)),
      ),
      child: Row(
        children: [
          _StatPill(label: 'Easy', done: _easyDone, color: AppColors.success, isDark: isDark),
          const SizedBox(width: 8),
          _StatPill(label: 'Medium', done: _mediumDone, color: AppColors.accent, isDark: isDark),
          const SizedBox(width: 8),
          _StatPill(label: 'Hard', done: _hardDone, color: AppColors.error, isDark: isDark),
        ],
      ),
    );
  }

  Widget _buildChallenge(Map<String, dynamic> challenge, bool isDark, int index) {
    final question = challenge['question'] as String? ?? '';
    final hint = challenge['hint'] as String? ?? '';
    final solution = challenge['solution'] as String? ?? '';
    final difficulty = challenge['difficulty'] as String? ?? 'easy';
    final id = question;
    _codeControllers.putIfAbsent(id, () => TextEditingController());
    _hintLevel.putIfAbsent(id, () => 0);

    final Color diffColor;
    switch (difficulty) {
      case 'hard':
        diffColor = AppColors.error;
      case 'medium':
        diffColor = AppColors.accent;
      default:
        diffColor = AppColors.success;
    }

    final isSolved = _solved[id] == true;
    final isSubmitted = _submitted[id] == true;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSolved
              ? AppColors.success.withValues(alpha: 0.3)
              : (isSubmitted
                  ? AppColors.warning.withValues(alpha: 0.3)
                  : (isDark ? AppColors.borderDark : AppColors.borderLight)),
          width: isSolved ? 1 : 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(color: diffColor.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: Center(child: Text('${index + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: diffColor))),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: diffColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(difficulty.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: diffColor)),
              ),
              const Spacer(),
              if (isSubmitted && isSolved)
                const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.success),
              if (isSubmitted && !isSolved)
                Icon(Icons.refresh_rounded, size: 18, color: AppColors.warning),
            ],
          ),
          const SizedBox(height: 10),
          Text(question, style: TextStyle(fontSize: 13, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight, height: 1.5)),
          const SizedBox(height: 10),

          // Code editor
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(10),
              border: isSolved
                  ? Border.all(color: AppColors.success.withValues(alpha: 0.3), width: 1)
                  : null,
            ),
            child: TextField(
              controller: _codeControllers[id],
              maxLines: 4,
              readOnly: isSolved,
              style: TextStyle(
                fontSize: 12,
                color: isSolved ? const Color(0xFFA6E3A1) : const Color(0xFFCDD6F4),
                fontFamily: 'monospace',
                height: 1.5,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(12),
                hintText: isSolved ? '✓ Challenge completed' : '# Paste your code here...',
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: isSolved ? AppColors.success.withValues(alpha: 0.5) : const Color(0xFF6B7280),
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
          // Action buttons row
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (hint.isNotEmpty)
                _ActionChip(
                  icon: Icons.lightbulb_outline,
                  label: 'Hint ${_hintLevel[id]! + 1}/3',
                  color: AppColors.accent,
                  onTap: () {
                    setState(() {
                      _hintLevel[id] = (_hintLevel[id]! + 1) % 3;
                    });
                    _showHint(_generateHint(hint, _hintLevel[id]!), _hintLevel[id]!);
                  },
                ),
              if (!isSolved)
                _ActionChip(
                  icon: Icons.content_paste_rounded,
                  label: 'Paste',
                  color: AppColors.accent,
                  onTap: () => _pasteCode(id),
                ),
              if (!isSolved)
                _ActionChip(
                  icon: Icons.send_rounded,
                  label: _checking[id] == true ? 'Checking...' : (isSubmitted ? 'Retry' : 'Submit'),
                  color: AppColors.primary,
                  onTap: _checking[id] == true ? null : () => _submitChallenge(challenge),
                ),
              if (isSolved)
                _ActionChip(
                  icon: Icons.check_circle_rounded,
                  label: 'Completed',
                  color: AppColors.success,
                  onTap: null,
                ),
              if (solution.isNotEmpty && isSubmitted)
                _ActionChip(
                  icon: Icons.compare_arrows_rounded,
                  label: 'Compare',
                  color: AppColors.tech,
                  onTap: () => _showSolution(solution, _codeControllers[id]?.text ?? ''),
                ),
            ],
          ),

          if (_aiFeedback[id] != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: (isSolved ? AppColors.success : AppColors.warning).withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (isSolved ? AppColors.success : AppColors.warning).withValues(alpha: 0.15),
                  width: 0.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: (isSolved ? AppColors.success : AppColors.warning).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.smart_toy_rounded, size: 14, color: isSolved ? AppColors.success : AppColors.warning),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'AI Feedback',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSolved ? AppColors.success : AppColors.warning,
                        ),
                      ),
                      const Spacer(),
                      if (isSolved)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_rounded, size: 10, color: AppColors.success),
                              const SizedBox(width: 4),
                              const Text('Solved', style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: () => _submitChallenge(challenge),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.refresh_rounded, size: 10, color: AppColors.warning),
                                const SizedBox(width: 4),
                                const Text('Retry', style: TextStyle(fontSize: 10, color: AppColors.warning, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  MarkdownText(_aiFeedback[id]!),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showHint(String hintText, int level) {
    final titles = ['Concept Hint', 'Approach Hint', 'Almost Solution'];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.accent.withValues(alpha: 0.08),
              isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            ],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.lightbulb_outline, size: 18, color: AppColors.accent),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titles[level], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                    Text('Level ${level + 1} of 3', style: TextStyle(fontSize: 10, color: AppColors.accent)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.1)),
              ),
              child: Text(hintText,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  height: 1.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final int done;
  final Color color;
  final bool isDark;

  const _StatPill({required this.label, required this.done, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text('$label $done', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color)),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ActionChip({required this.icon, required this.label, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: onTap != null ? 0.12 : 0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: onTap != null ? 0.2 : 0.08),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: onTap != null ? color : color.withValues(alpha: 0.5)),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: onTap != null ? color : color.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
