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
            child: Text(
              'Content not available',
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildListenButton(context, state, isDark),
              const SizedBox(height: 20),
              _buildSectionTitle('SIMPLE BREAKDOWN', isDark),
              const SizedBox(height: 8),
              ...?state.breakdown?.map((point) => _buildPoint(point, isDark)),
              const SizedBox(height: 20),
              if (state.example != null) ...[
                _buildSectionTitle('REAL LIFE EXAMPLE', isDark),
                const SizedBox(height: 8),
                _buildExampleBox(state.example!, isDark),
                const SizedBox(height: 20),
              ],
              if (state.keyTerms != null && state.keyTerms!.isNotEmpty) ...[
                _buildSectionTitle('KEY TERMS', isDark),
                const SizedBox(height: 8),
                ...state.keyTerms!.entries.map(
                  (entry) => _buildKeyTerm(entry.key, entry.value, isDark),
                ),
                const SizedBox(height: 20),
              ],
              _buildYouTubeButton(isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListenButton(BuildContext context, StudyState state, bool isDark) {
    return GestureDetector(
      onTap: () {
        if (state.isAudioPlaying) {
          context.read<StudyBloc>().add(StudyAudioStopped());
        } else {
          context.read<StudyBloc>().add(StudyAudioPlayed());
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              state.isAudioPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              state.isAudioPlaying ? 'STOP' : 'LISTEN',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '🇧🇩',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      '📌 $title',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildPoint(String point, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Text(
              point,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleBox(String example, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Text(
        example,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
      ),
    );
  }

  Widget _buildKeyTerm(String term, String meaning, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔑 ',
            style: TextStyle(fontSize: 14),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$term → ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  TextSpan(
                    text: meaning,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYouTubeButton(bool isDark) {
    return GestureDetector(
      onTap: () {
        // TODO: Open YouTube search
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.play_circle_outline, color: Colors.red, size: 28),
            const SizedBox(width: 12),
            Text(
              '🎥 YOUTUBE SEARCH',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
