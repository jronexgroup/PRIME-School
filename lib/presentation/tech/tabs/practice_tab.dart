import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PracticeTab extends StatelessWidget {
  final Map<String, dynamic> content;

  const PracticeTab({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final codeExamples = (content['codeExamples'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    if (codeExamples.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.code_off_rounded, size: 48, color: isDark ? Colors.white24 : Colors.black26),
            const SizedBox(height: 12),
            Text('No code examples yet', style: TextStyle(fontSize: 14, color: isDark ? Colors.white38 : Colors.black38)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: codeExamples.length,
      itemBuilder: (context, index) {
        final example = codeExamples[index];
        return _CodeExampleCard(example: example, isDark: isDark, index: index + 1);
      },
    );
  }
}

class _CodeExampleCard extends StatefulWidget {
  final Map<String, dynamic> example;
  final bool isDark;
  final int index;

  const _CodeExampleCard({
    required this.example,
    required this.isDark,
    required this.index,
  });

  @override
  State<_CodeExampleCard> createState() => _CodeExampleCardState();
}

class _CodeExampleCardState extends State<_CodeExampleCard> {
  bool _showOutput = false;
  bool _showExplanation = false;

  @override
  Widget build(BuildContext context) {
    final title = widget.example['title'] as String? ?? '';
    final code = widget.example['code'] as String? ?? '';
    final explanation = widget.example['explanation'] as String? ?? '';
    final output = widget.example['output'] as String? ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: widget.isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: AppColors.tech.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text('${widget.index}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.tech))),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight))),
            ],
          ),
          const SizedBox(height: 12),
          // Code block
          GestureDetector(
            onTap: () {}, // Tap to copy in future
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SelectableText(
                code,
                style: const TextStyle(fontSize: 12, color: Color(0xFFCDD6F4), fontFamily: 'monospace', height: 1.6),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Action buttons
          Row(
            children: [
              if (output.isNotEmpty)
                _ActionChip(
                  icon: Icons.output_rounded,
                  label: _showOutput ? 'Hide Output' : 'Show Output',
                  color: AppColors.success,
                  onTap: () => setState(() => _showOutput = !_showOutput),
                  isDark: widget.isDark,
                ),
              const SizedBox(width: 8),
              if (explanation.isNotEmpty)
                _ActionChip(
                  icon: Icons.explore_outlined,
                  label: _showExplanation ? 'Hide Explanation' : 'Explanation',
                  color: AppColors.accent,
                  onTap: () => setState(() => _showExplanation = !_showExplanation),
                  isDark: widget.isDark,
                ),
            ],
          ),
          if (_showOutput && output.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D3F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.output_rounded, size: 14, color: AppColors.success),
                  const SizedBox(width: 6),
                  Expanded(child: Text(output, style: const TextStyle(fontSize: 11, color: Color(0xFFA6E3A1), fontFamily: 'monospace', height: 1.4))),
                ],
              ),
            ),
          ],
          if (_showExplanation && explanation.isNotEmpty) ...[
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
                  Expanded(child: Text(explanation, style: TextStyle(fontSize: 12, color: widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.5))),
                ],
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
  final bool isDark;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.isDark,
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
