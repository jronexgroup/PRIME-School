import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/youtube_embed_widget.dart';

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
    final aiCoachScript = widget.content['aiCoachScript'] as String? ?? '';
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
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
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
            if (aiCoachScript.isNotEmpty)
              _buildCoachCard(aiCoachScript, isDark),
            const SizedBox(height: 16),
            _buildSection('Key Points', keyPoints, isDark, Icons.lightbulb_outline, AppColors.accent),
            if (keyConcepts.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildConceptsGrid(keyConcepts, isDark),
            ],
          ] else ...[
            if (videoUrl.isNotEmpty)
              YoutubeEmbedWidget(videoUrl: videoUrl),
            const SizedBox(height: 16),
            if (keyPoints.isNotEmpty)
              _buildSection('Key Points', keyPoints, isDark, Icons.lightbulb_outline, AppColors.accent),
          ],
        ],
      ),
    );
  }

  Widget _buildCoachCard(String script, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.tech.withValues(alpha: 0.08), AppColors.primary.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.tech.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: AppColors.tech.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.smart_toy_rounded, size: 18, color: AppColors.tech),
              ),
              const SizedBox(width: 10),
              Text('AI Coach', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
            ],
          ),
          const SizedBox(height: 12),
          Text(script, style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.7)),
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
            spacing: 8, runSpacing: 8,
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
}
