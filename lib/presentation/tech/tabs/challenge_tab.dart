import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/services/python_executor_service.dart';

class ChallengeTab extends StatefulWidget {
  final Map<String, dynamic> content;

  const ChallengeTab({super.key, required this.content});

  @override
  State<ChallengeTab> createState() => _ChallengeTabState();
}

class _ChallengeTabState extends State<ChallengeTab> {
  final Map<String, TextEditingController> _codeControllers = {};
  final Map<String, bool> _submitted = {};
  final Map<String, String> _aiFeedback = {};
  final Map<String, bool> _checking = {};
  final Map<String, int> _hintLevel = {};
  final Map<String, String> _outputs = {};
  final Map<String, bool> _isRunning = {};
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
    setState(() {
      _easyDone = prefs.getInt('challenge_easy') ?? 0;
      _mediumDone = prefs.getInt('challenge_medium') ?? 0;
      _hardDone = prefs.getInt('challenge_hard') ?? 0;
    });
  }

  Future<void> _saveStat(String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    if (difficulty == 'easy') {
      final v = (prefs.getInt('challenge_easy') ?? 0) + 1;
      await prefs.setInt('challenge_easy', v);
      _easyDone = v;
    } else if (difficulty == 'medium') {
      final v = (prefs.getInt('challenge_medium') ?? 0) + 1;
      await prefs.setInt('challenge_medium', v);
      _mediumDone = v;
    } else {
      final v = (prefs.getInt('challenge_hard') ?? 0) + 1;
      await prefs.setInt('challenge_hard', v);
      _hardDone = v;
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
    // Generate 3 levels from single hint
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

  Future<void> _runCode(String id) async {
    final code = _codeControllers[id]?.text ?? '';
    if (code.trim().isEmpty) return;
    setState(() => _isRunning[id] = true);
    final executor = context.read<PythonExecutorService>();
    final result = await executor.executeCode(code);
    setState(() {
      _outputs[id] = result;
      _isRunning[id] = false;
    });
  }

  Future<void> _submitChallenge(Map<String, dynamic> challenge) async {
    final id = challenge['question'] as String? ?? '';
    final code = _codeControllers[id]?.text ?? '';
    if (code.trim().isEmpty) return;

    setState(() => _checking[id] = true);

    try {
      final ai = context.read<AiService>();
      final correctAnswer = challenge['solution'] as String? ?? '';
      final feedback = await ai.checkAnswer(
        challenge['question'] as String? ?? '',
        code,
        correctAnswer,
      );
      final difficulty = challenge['difficulty'] as String? ?? 'easy';
      await _saveStat(difficulty);
      setState(() {
        _aiFeedback[id] = feedback;
        _submitted[id] = true;
        _checking[id] = false;
      });
    } catch (e) {
      setState(() {
        _aiFeedback[id] = 'AI feedback unavailable. Check your solution manually.';
        _submitted[id] = true;
        _checking[id] = false;
      });
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
                        Text("Harry's Solution", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.success)),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _submitted[id] == true ? AppColors.success.withValues(alpha: 0.3) : (isDark ? AppColors.borderDark : AppColors.borderLight),
          width: 0.5,
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
              if (_submitted[id] == true)
                const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.success),
            ],
          ),
          const SizedBox(height: 10),
          Text(question, style: TextStyle(fontSize: 13, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight, height: 1.5)),
          const SizedBox(height: 10),

          // Code editor
          Container(
            decoration: BoxDecoration(color: const Color(0xFF1E1E2E), borderRadius: BorderRadius.circular(10)),
            child: TextField(
              controller: _codeControllers[id],
              maxLines: 4,
              style: const TextStyle(fontSize: 12, color: Color(0xFFCDD6F4), fontFamily: 'monospace', height: 1.5),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
                hintText: '# Write your code here...',
                hintStyle: TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontFamily: 'monospace'),
              ),
            ),
          ),

          // Output display
          if (_outputs[id] != null && _outputs[id]!.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFF2D2D3F), borderRadius: BorderRadius.circular(8)),
              child: Text(_outputs[id]!, style: const TextStyle(fontSize: 11, color: Color(0xFFA6E3A1), fontFamily: 'monospace', height: 1.4)),
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
              _ActionChip(
                icon: Icons.play_arrow_rounded,
                label: _isRunning[id] == true ? 'Running...' : 'Run',
                color: AppColors.success,
                onTap: _isRunning[id] == true ? null : () => _runCode(id),
              ),
              _ActionChip(
                icon: Icons.send_rounded,
                label: _checking[id] == true ? 'Checking...' : 'Submit',
                color: AppColors.primary,
                onTap: _checking[id] == true ? null : () => _submitChallenge(challenge),
              ),
              if (solution.isNotEmpty && _submitted[id] == true)
                _ActionChip(
                  icon: Icons.compare_arrows_rounded,
                  label: 'Compare',
                  color: AppColors.tech,
                  onTap: () => _showSolution(solution, _codeControllers[id]?.text ?? ''),
                ),
            ],
          ),

          if (_aiFeedback[id] != null) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.feedback_rounded, size: 14, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text('AI Feedback', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(_aiFeedback[id]!, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.4)),
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
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: AppColors.accent),
                const SizedBox(width: 8),
                Text(titles[level], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Text(hintText, style: const TextStyle(fontSize: 13, height: 1.5)),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: color)),
          ],
        ),
      ),
    );
  }
}
