import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/study/study_bloc.dart';
import '../../../blocs/study/study_event.dart';
import '../../../blocs/study/study_state.dart';
import '../../../core/constants/app_colors.dart';

class UnderstandTab extends StatelessWidget {
  const UnderstandTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<StudyBloc, StudyState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.topicContent == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 48,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                ),
                const SizedBox(height: 12),
                Text(
                  'Content not available',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildListenButton(context, state),
              const SizedBox(height: 24),
              _buildSummarySection(state, isDark),
              const SizedBox(height: 24),
              _buildSection('SIMPLE BREAKDOWN', state.simpleBreakdown, isDark, _buildBreakdownList),
              _buildSection('REAL LIFE EXAMPLE', state.realLifeExample, isDark, _buildExampleBox),
              _buildSection('KEY TERMS', state.keyTerms, isDark, _buildKeyTerms),
              _buildSection('TIMELINE', state.timeline, isDark, _buildTimeline),
              _buildSection('CAUSE & EFFECT', state.causeEffect, isDark, _buildCauseEffect),
              _buildSection('IMPORTANT PERSONALITIES', state.importantPersonalities, isDark, _buildPersonalities),
              _buildSection('IMPORTANT PLACES', state.importantPlaces, isDark, _buildPlaces),
              if (state.mapDescription != null && state.mapDescription!.isNotEmpty)
                _buildSection('MAP', state.mapDescription, isDark, _buildExampleBox),
              if (state.voiceScript != null && state.voiceScript!.isNotEmpty)
                _buildSection('VOICE SCRIPT', state.voiceScript, isDark, _buildExampleBox),
              if (state.sidebarContent != null && state.sidebarContent!.isNotEmpty)
                _buildSection('DID YOU KNOW?', state.sidebarContent, isDark, _buildSidebar),
              if (state.examTips != null && state.examTips!.isNotEmpty)
                _buildSection('EXAM TIPS', state.examTips, isDark, _buildExamTips),
              if (state.importantHighlights != null)
                _buildHighlights(state.importantHighlights!, isDark),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListenButton(BuildContext context, StudyState state) {
    return GestureDetector(
      onTap: () {
        if (state.isAudioPlaying) {
          context.read<StudyBloc>().add(StudyAudioStopped());
        } else {
          context.read<StudyBloc>().add(StudyAudioPlayed());
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              state.isAudioPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              state.isAudioPlaying ? 'STOP' : 'LISTEN',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(StudyState state, bool isDark) {
    final summary = state.summary;
    if (summary == null || summary.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('SUMMARY', isDark),
        const SizedBox(height: 10),
        Text(
          summary,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, dynamic data, bool isDark, Widget Function(dynamic, bool) builder) {
    if (data == null) return const SizedBox.shrink();
    if (data is List && data.isEmpty) return const SizedBox.shrink();
    if (data is String && data.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildSectionHeader(title, isDark),
        const SizedBox(height: 10),
        builder(data, isDark),
      ],
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildBreakdownList(dynamic data, bool isDark) {
    final points = data as List;
    return Column(
      children: points.map((point) => _buildPoint(point as String, isDark)).toList(),
    );
  }

  Widget _buildPoint(String point, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              point,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleBox(dynamic data, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        data as String,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildSidebar(dynamic data, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: AppColors.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              data as String,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyTerms(dynamic data, bool isDark) {
    final terms = data as List<Map<String, dynamic>>;
    return Column(
      children: terms.map((t) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${t['term'] ?? ''}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${t['meaning'] ?? ''}',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  height: 1.4,
                ),
              ),
              if (t['example'] != null && (t['example'] as String).isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.auto_awesome, size: 12, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${t['example']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimeline(dynamic data, bool isDark) {
    final entries = data as List<Map<String, dynamic>>;
    return Column(
      children: List.generate(entries.length, (i) {
        final e = entries[i];
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 0.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${e['date'] ?? ''}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${e['event'] ?? ''}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    if (e['significance'] != null && (e['significance'] as String).isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          '${e['significance']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCauseEffect(dynamic data, bool isDark) {
    final pairs = data as List<Map<String, dynamic>>;
    return Column(
      children: List.generate(pairs.length, (i) {
        final p = pairs[i];
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 0.5,
            ),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.arrow_upward, size: 16, color: Colors.orange, semanticLabel: 'Cause'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${p['cause'] ?? ''}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Icon(Icons.arrow_downward, size: 16, color: AppColors.primary),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.arrow_downward, size: 16, color: AppColors.primary, semanticLabel: 'Effect'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${p['effect'] ?? ''}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPersonalities(dynamic data, bool isDark) {
    final people = data as List<Map<String, dynamic>>;
    return Column(
      children: List.generate(people.length, (i) {
        final p = people[i];
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${p['name'] ?? ''}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          '${p['title'] ?? ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${p['contribution'] ?? ''}',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  height: 1.4,
                ),
              ),
              if (p['exam_importance'] != null && (p['exam_importance'] as String).isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.school, size: 14, color: AppColors.warning),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${p['exam_importance']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.warning,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPlaces(dynamic data, bool isDark) {
    final places = data as List<Map<String, dynamic>>;
    return Column(
      children: List.generate(places.length, (i) {
        final p = places[i];
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    '${p['name'] ?? ''}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${p['description'] ?? ''}',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${p['significance'] ?? ''}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildExamTips(dynamic data, bool isDark) {
    final tips = data as List;
    return Column(
      children: List.generate(tips.length, (i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${tips[i]}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHighlights(Map<String, dynamic> highlights, bool isDark) {
    final dates = highlights['must_remember_dates'];
    final names = highlights['must_remember_names'];
    final places = highlights['must_remember_places'];
    final facts = highlights['one_liner_facts'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildSectionHeader('IMPORTANT HIGHLIGHTS', isDark),
        const SizedBox(height: 10),
        if (dates != null && (dates as List).isNotEmpty)
          _buildHighlightBlock('📅 Must Remember Dates', dates, isDark),
        if (names != null && (names as List).isNotEmpty)
          _buildHighlightBlock('👤 Must Remember Names', names, isDark),
        if (places != null && (places as List).isNotEmpty)
          _buildHighlightBlock('📍 Must Remember Places', places, isDark),
        if (facts != null && (facts as List).isNotEmpty)
          _buildHighlightBlock('⭐ One-Liner Facts', facts, isDark),
      ],
    );
  }

  Widget _buildHighlightBlock(String title, List items, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 13)),
                    Expanded(
                      child: Text(
                        '$item',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
