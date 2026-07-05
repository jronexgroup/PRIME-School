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
            _buildCoachCard(aiCoachScript, isDark),
            const SizedBox(height: 16),
            _buildKeyPoints(keyPoints, isDark),
            if (keyConcepts.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildConceptsSection(keyConcepts, isDark),
            ],
          ] else ...[
            if (videoUrl.isNotEmpty) ...[
              YoutubeEmbedWidget(videoUrl: videoUrl),
              const SizedBox(height: 16),
            ],
            if (keyPoints.isNotEmpty)
              _buildKeyPoints(keyPoints, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildCoachCard(String script, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                colors: [
                  AppColors.tech.withValues(alpha: 0.12),
                  const Color(0xFF1A1A2E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  AppColors.tech.withValues(alpha: 0.06),
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.tech.withValues(alpha: isDark ? 0.25 : 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.tech, AppColors.tech.withValues(alpha: 0.6)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.smart_toy_rounded, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI Coach', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.textPrimaryLight)),
                  Text('AI-powered explanation', style: TextStyle(fontSize: 10, color: isDark ? Colors.white54 : AppColors.textTertiaryLight)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withValues(alpha: 0.3) : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.borderLight),
            ),
            child: Text(
              script,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                height: 1.8,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyPoints(List<String> points, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withValues(alpha: 0.08),
            AppColors.primary.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.15)),
      ),
      child: Column(
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
              const SizedBox(width: 12),
              Text(
                'Key Points',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${points.length} points', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.accent)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(points.length, (i) {
            final color = _pointColors[i % _pointColors.length];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26, height: 26,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text('${i + 1}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      points[i],
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF334155),
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildConceptsSection(List<String> concepts, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.tech.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.psychology_outlined, size: 18, color: AppColors.tech),
              ),
              const SizedBox(width: 12),
              Text(
                'Key Concepts',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10, runSpacing: 10,
            children: concepts.map((c) {
              final color = _conceptColors[concepts.indexOf(c) % _conceptColors.length];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withValues(alpha: 0.12), color.withValues(alpha: 0.04)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.terminal_rounded, size: 12, color: color),
                    const SizedBox(width: 6),
                    Text(c, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color, letterSpacing: 0.2)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  static const _pointColors = [
    AppColors.tech,
    AppColors.accent,
    AppColors.primary,
    AppColors.warning,
    AppColors.info,
    AppColors.success,
    AppColors.tech,
  ];

  static const _conceptColors = [
    Color(0xFFE879F9),
    Color(0xFFA6E3A1),
    Color(0xFF89B4FA),
    Color(0xFFF9E2AF),
    Color(0xFFF38BA8),
    Color(0xFF94E2D5),
  ];
}
