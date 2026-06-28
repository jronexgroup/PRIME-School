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
              // Listen Button
              GestureDetector(
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
              ),
              const SizedBox(height: 24),
              // Breakdown
              if (state.breakdown != null) ...[
                _buildSectionHeader('SIMPLE BREAKDOWN', isDark),
                const SizedBox(height: 10),
                ...state.breakdown!.map((point) => _buildPoint(point, isDark)),
                const SizedBox(height: 24),
              ],
              // Example
              if (state.example != null) ...[
                _buildSectionHeader('REAL LIFE EXAMPLE', isDark),
                const SizedBox(height: 10),
                Container(
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
                    state.example!,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              // Key Terms
              if (state.keyTerms != null && state.keyTerms!.isNotEmpty) ...[
                _buildSectionHeader('KEY TERMS', isDark),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.keyTerms!.entries.map((entry) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.cardLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          width: 0.5,
                        ),
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${entry.key} ',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            TextSpan(
                              text: '→ ${entry.value}',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],
              // YouTube Search
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.play_circle_outline, color: Colors.red, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Search on YouTube',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.open_in_new_rounded,
                      size: 16,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
}
