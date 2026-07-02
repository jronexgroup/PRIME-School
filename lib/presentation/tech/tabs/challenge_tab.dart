import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ChallengeTab extends StatelessWidget {
  final Map<String, dynamic> content;

  const ChallengeTab({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final challenges = (content['challenges'] as List?)?.cast<Map<String, dynamic>>() ?? [];

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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: challenges.length,
      itemBuilder: (context, index) => _ChallengeCard(
        challenge: challenges[index],
        isDark: isDark,
        index: index + 1,
      ),
    );
  }
}

class _ChallengeCard extends StatefulWidget {
  final Map<String, dynamic> challenge;
  final bool isDark;
  final int index;

  const _ChallengeCard({
    required this.challenge,
    required this.isDark,
    required this.index,
  });

  @override
  State<_ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<_ChallengeCard> {
  bool _showHint = false;
  bool _showSolution = false;
  bool _completed = false;

  @override
  Widget build(BuildContext context) {
    final question = widget.challenge['question'] as String? ?? '';
    final hint = widget.challenge['hint'] as String? ?? '';
    final solution = widget.challenge['solution'] as String? ?? '';
    final difficulty = widget.challenge['difficulty'] as String? ?? 'easy';

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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _completed
              ? AppColors.success.withValues(alpha: 0.3)
              : (widget.isDark ? AppColors.borderDark : AppColors.borderLight),
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
                decoration: BoxDecoration(
                  color: diffColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text('${widget.index}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: diffColor))),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: diffColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(difficulty.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: diffColor)),
              ),
              const Spacer(),
              if (_completed)
                const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.success),
            ],
          ),
          const SizedBox(height: 12),
          Text(question, style: TextStyle(fontSize: 13, color: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight, height: 1.5)),
          const SizedBox(height: 12),
          Row(
            children: [
              if (hint.isNotEmpty)
                _ActionChip(
                  icon: Icons.lightbulb_outline,
                  label: _showHint ? 'Hide Hint' : 'Hint',
                  color: AppColors.accent,
                  onTap: () => setState(() => _showHint = !_showHint),
                ),
              const SizedBox(width: 8),
              if (solution.isNotEmpty)
                _ActionChip(
                  icon: Icons.light_rounded,
                  label: _showSolution ? 'Hide Solution' : 'Solution',
                  color: AppColors.tech,
                  onTap: () => setState(() => _showSolution = !_showSolution),
                ),
              const Spacer(),
              _ActionChip(
                icon: _completed ? Icons.undo_rounded : Icons.check_rounded,
                label: _completed ? 'Undo' : 'Done',
                color: AppColors.success,
                onTap: () => setState(() => _completed = !_completed),
              ),
            ],
          ),
          if (_showHint && hint.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline, size: 14, color: AppColors.accent),
                  const SizedBox(width: 6),
                  Expanded(child: Text(hint, style: TextStyle(fontSize: 12, color: widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.4))),
                ],
              ),
            ),
          ],
          if (_showSolution && solution.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SelectableText(
                solution,
                style: const TextStyle(fontSize: 12, color: Color(0xFFCDD6F4), fontFamily: 'monospace', height: 1.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color)),
          ],
        ),
      ),
    );
  }
}
