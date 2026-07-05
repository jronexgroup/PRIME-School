import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/ai_service.dart';
import '../../shared/widgets/markdown_text.dart';

enum PracticeMode { example, aiReview }

class PracticeTab extends StatefulWidget {
  final Map<String, dynamic> content;

  const PracticeTab({super.key, required this.content});

  @override
  State<PracticeTab> createState() => _PracticeTabState();
}

class _PracticeTabState extends State<PracticeTab> {
  PracticeMode _mode = PracticeMode.example;
  final TextEditingController _reviewController = TextEditingController();
  String _aiReviewFeedback = '';
  bool _isReviewing = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _reviewCode() async {
    final code = _reviewController.text.trim();
    if (code.isEmpty) return;
    setState(() {
      _isReviewing = true;
      _aiReviewFeedback = '';
    });
    try {
      final ai = context.read<AiService>();
      final feedback = await ai.reviewCode(code, 'Review this Python code:');
      setState(() {
        _aiReviewFeedback = feedback;
        _isReviewing = false;
      });
    } catch (e) {
      setState(() {
        _aiReviewFeedback = 'Error: ${e.toString()}';
        _isReviewing = false;
      });
    }
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _reviewController.text = data!.text!;
    }
  }

  Future<void> _copyToClipboard(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code copied to clipboard!'), duration: Duration(seconds: 2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final codeExamples = (widget.content['codeExamples'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Column(
      children: [
        _buildModeToggle(isDark),
        Expanded(
          child: _mode == PracticeMode.example
              ? _buildExamplesList(codeExamples, isDark)
              : _buildAiReview(isDark),
        ),
      ],
    );
  }

  Widget _buildModeToggle(bool isDark) {
    final modes = [PracticeMode.example, PracticeMode.aiReview];
    final labels = ['Examples', 'AI Review'];
    final icons = [Icons.menu_book_rounded, Icons.rate_review_outlined];

    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
      ),
      child: Row(
        children: List.generate(2, (index) {
          final isSelected = _mode == modes[index];
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _mode = modes[index]),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.tech : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icons[index], size: 14, color: isSelected ? Colors.white : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                    const SizedBox(width: 4),
                    Text(labels[index], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight))),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAiReview(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.rate_review_outlined, color: AppColors.accent, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Paste your Python code below. AI will review it and give specific improvement suggestions.',
                    style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _reviewController,
              maxLines: null,
              expands: true,
              style: const TextStyle(fontSize: 13, color: Color(0xFFCDD6F4), fontFamily: 'monospace', height: 1.6),
              decoration: const InputDecoration(
                hintText: '# Paste your code here...',
                hintStyle: TextStyle(fontSize: 13, color: Color(0xFF6B7280), fontFamily: 'monospace'),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(14),
              ),
              keyboardType: TextInputType.multiline,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pasteFromClipboard,
                  icon: const Icon(Icons.content_paste_rounded, size: 16),
                  label: const Text('Paste', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: const BorderSide(color: AppColors.accent),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _isReviewing ? null : _reviewCode,
                  icon: _isReviewing
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.rate_review_outlined, size: 18),
                  label: Text(_isReviewing ? 'Reviewing...' : 'Review Code', style: const TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
          if (_aiReviewFeedback.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.feedback_rounded, size: 16, color: AppColors.accent),
                      const SizedBox(width: 8),
                      Text('AI Review', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  MarkdownText(_aiReviewFeedback),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExamplesList(List<Map<String, dynamic>> examples, bool isDark) {
    if (examples.isEmpty) {
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
      padding: const EdgeInsets.all(12),
      itemCount: examples.length,
      itemBuilder: (context, index) {
        final ex = examples[index];
        final title = ex['title'] as String? ?? '';
        final code = ex['code'] as String? ?? '';
        final explanation = ex['explanation'] as String? ?? '';

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.tech.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Text('${index + 1}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tech))),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight))),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(code, style: const TextStyle(fontSize: 11, color: Color(0xFFCDD6F4), fontFamily: 'monospace', height: 1.4), maxLines: 8, overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _SmallButton(
                    icon: Icons.copy_rounded,
                    label: 'Copy',
                    color: AppColors.tech,
                    onTap: () => _copyToClipboard(code),
                    isDark: isDark,
                  ),
                  if (explanation.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    _SmallButton(
                      icon: Icons.explore_outlined,
                      label: 'Explain',
                      color: AppColors.accent,
                      onTap: () => _showExplanation(explanation),
                      isDark: isDark,
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showExplanation(String explanation) {
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
                Text('Explanation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Text(explanation, style: const TextStyle(fontSize: 13, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isDark;

  const _SmallButton({
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
