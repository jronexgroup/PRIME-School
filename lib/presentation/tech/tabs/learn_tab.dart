import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';

class LearnTab extends StatefulWidget {
  final Map<String, dynamic> content;
  final List<Map<String, dynamic>> roadmap;
  final String subjectId;
  final String topicId;

  const LearnTab({
    super.key,
    required this.content,
    required this.roadmap,
    required this.subjectId,
    required this.topicId,
  });

  @override
  State<LearnTab> createState() => _LearnTabState();
}

class _LearnTabState extends State<LearnTab> {
  bool _aiCoachMode = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final keyPoints = (widget.content['keyPoints'] as List?)?.cast<String>() ?? [];
    final keyConcepts = (widget.content['keyConcepts'] as List?)?.cast<String>() ?? [];
    final codeExamples = (widget.content['codeExamples'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final videoUrl = widget.content['videoUrl'] as String? ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mode toggle
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _aiCoachMode = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !_aiCoachMode ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_circle_fill, size: 16, color: !_aiCoachMode ? Colors.white : AppColors.textTertiaryDark),
                          const SizedBox(width: 6),
                          Text('Video', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: !_aiCoachMode ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight))),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _aiCoachMode = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _aiCoachMode ? AppColors.tech : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.smart_toy_rounded, size: 16, color: _aiCoachMode ? Colors.white : AppColors.textTertiaryDark),
                          const SizedBox(width: 6),
                          Text('AI Coach', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _aiCoachMode ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight))),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (_aiCoachMode) ...[
            _buildSection('Key Points', keyPoints, isDark, Icons.lightbulb_outline, AppColors.accent),
            if (keyConcepts.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildConceptsGrid(keyConcepts, isDark),
            ],
            ...codeExamples.map((ex) => Padding(
              padding: const EdgeInsets.only(top: 16),
              child: _buildCodeExample(ex, isDark),
            )),
          ] else ...[
            _buildVideoCard(videoUrl, isDark),
            const SizedBox(height: 16),
            _buildSection('Key Points', keyPoints, isDark, Icons.lightbulb_outline, AppColors.accent),
          ],
        ],
      ),
    );
  }

  Widget _buildVideoCard(String videoUrl, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow_rounded, size: 32, color: AppColors.error),
          ),
          const SizedBox(height: 16),
          Text(
            'CodeWithHarry — Complete Python Course',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '11 hours · Full Python tutorial',
            style: TextStyle(fontSize: 12, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                if (videoUrl.isNotEmpty) {
                  final uri = Uri.parse(videoUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }
              },
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('Open in YouTube', style: TextStyle(fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items, bool isDark, IconData icon, Color color) {
    return Container(
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
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: color, fontSize: 13)),
                Expanded(child: Text(item, style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.4))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildConceptsGrid(List<String> concepts, bool isDark) {
    return Container(
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
              Icon(Icons.psychology_outlined, size: 18, color: AppColors.tech),
              const SizedBox(width: 8),
              Text('Key Concepts', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: concepts.map((c) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.tech.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(c, style: TextStyle(fontSize: 12, color: AppColors.tech, height: 1.3)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeExample(Map<String, dynamic> example, bool isDark) {
    final title = example['title'] as String? ?? '';
    final code = example['code'] as String? ?? '';
    final explanation = example['explanation'] as String? ?? '';
    final output = example['output'] as String? ?? '';

    return Container(
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
              Icon(Icons.code_rounded, size: 18, color: AppColors.tech),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight))),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(code, style: const TextStyle(fontSize: 12, color: Color(0xFFCDD6F4), fontFamily: 'monospace', height: 1.5)),
          ),
          if (output.isNotEmpty) ...[
            const SizedBox(height: 8),
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
          if (explanation.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(explanation, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.5)),
          ],
        ],
      ),
    );
  }
}
