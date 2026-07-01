import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flip_card/flip_card.dart';
import '../../../blocs/study/study_bloc.dart';
import '../../../blocs/study/study_event.dart';
import '../../../blocs/study/study_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/flashcard_model.dart';

class FlashcardsTab extends StatelessWidget {
  const FlashcardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<StudyBloc, StudyState>(
      builder: (context, state) {
        if (state.flashcards.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.style_outlined,
                  size: 48,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                ),
                const SizedBox(height: 12),
                Text(
                  'No flashcards available',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTypeBadge(state.flashcards[state.currentFlashcardIndex], isDark),
                    const SizedBox(height: 8),
                    FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      front: _buildCard(
                        state.flashcards[state.currentFlashcardIndex].front,
                        isDark,
                        'Tap to flip',
                      ),
                      back: _buildCard(
                        state.flashcards[state.currentFlashcardIndex].back,
                        isDark,
                        'Tap to flip back',
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildImportanceBadge(state.flashcards[state.currentFlashcardIndex], isDark),
                  ],
                ),
              ),
            ),
            _buildNavigation(context, state, isDark),
            const SizedBox(height: 12),
            _buildMarkButtons(context, state, isDark),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildCard(String text, bool isDark, String hint) {
    return Container(
      width: 300,
      height: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  height: 1.4,
                ),
              ),
            ),
          ),
          Text(
            hint,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(FlashcardModel fc, bool isDark) {
    final colors = {
      'date': AppColors.primary,
      'person': Colors.teal,
      'place': Colors.orange,
      'concept': Colors.purple,
      'definition': Colors.blue,
    };
    final color = colors[fc.type] ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        fc.type.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  Widget _buildNavigation(BuildContext context, StudyState state, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNavButton(
          context,
          icon: Icons.chevron_left_rounded,
          enabled: state.currentFlashcardIndex > 0,
          onTap: () {
            context.read<StudyBloc>().add(
                  StudyFlashcardFlipped(state.currentFlashcardIndex - 1),
                );
          },
          isDark: isDark,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.dividerLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${state.currentFlashcardIndex + 1} / ${state.flashcards.length}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ),
        _buildNavButton(
          context,
          icon: Icons.chevron_right_rounded,
          enabled: state.currentFlashcardIndex < state.flashcards.length - 1,
          onTap: () {
            context.read<StudyBloc>().add(
                  StudyFlashcardFlipped(state.currentFlashcardIndex + 1),
                );
          },
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.dividerLight,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled
              ? AppColors.primary
              : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
        ),
      ),
    );
  }

  Widget _buildMarkButtons(BuildContext context, StudyState state, bool isDark) {
    final flashcard = state.flashcards[state.currentFlashcardIndex];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildMarkButton(
          context,
          icon: Icons.star_rounded,
          label: 'Important',
          color: AppColors.warning,
          isActive: flashcard.isImportant,
          onTap: () {
            context.read<StudyBloc>().add(
                  StudyFlashcardMarked(state.currentFlashcardIndex, 'important'),
                );
          },
          isDark: isDark,
        ),
        const SizedBox(width: 10),
        _buildMarkButton(
          context,
          icon: Icons.check_circle_rounded,
          label: 'Known',
          color: AppColors.success,
          isActive: flashcard.isKnown,
          onTap: () {
            context.read<StudyBloc>().add(
                  StudyFlashcardMarked(state.currentFlashcardIndex, 'known'),
                );
          },
          isDark: isDark,
        ),
        const SizedBox(width: 10),
        _buildMarkButton(
          context,
          icon: Icons.replay_rounded,
          label: 'Review',
          color: AppColors.error,
          isActive: flashcard.needsReview,
          onTap: () {
            context.read<StudyBloc>().add(
                  StudyFlashcardMarked(state.currentFlashcardIndex, 'review'),
                );
          },
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildImportanceBadge(FlashcardModel fc, bool isDark) {
    final colors = {
      'high': AppColors.warning,
      'medium': AppColors.primary,
      'low': AppColors.textTertiaryLight,
    };
    final color = colors[fc.importance] ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            fc.importance == 'high' ? Icons.arrow_upward : (fc.importance == 'low' ? Icons.arrow_downward : Icons.remove),
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            fc.importance == 'high' ? 'HIGH' : (fc.importance == 'low' ? 'LOW' : 'MEDIUM'),
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required bool isActive,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? color : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive
                  ? color
                  : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? color
                    : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
