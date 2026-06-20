import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flip_card/flip_card.dart';
import '../../../blocs/study/study_bloc.dart';
import '../../../blocs/study/study_event.dart';
import '../../../blocs/study/study_state.dart';
import '../../../core/constants/app_colors.dart';

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
                  size: 64,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                const SizedBox(height: 16),
                Text(
                  'No flashcards available',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: Center(
                child: FlipCard(
                  direction: FlipDirection.HORIZONTAL,
                  front: _buildFlashcard(
                    state.flashcards[state.currentFlashcardIndex].front,
                    'Tap to flip',
                    isDark,
                  ),
                  back: _buildFlashcard(
                    state.flashcards[state.currentFlashcardIndex].back,
                    'Tap to flip back',
                    isDark,
                  ),
                ),
              ),
            ),
            _buildNavigation(context, state, isDark),
            const SizedBox(height: 16),
            _buildMarkButtons(context, state, isDark),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildFlashcard(String text, String hint, bool isDark) {
    return Container(
      width: 300,
      height: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
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
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ),
          ),
          Text(
            hint,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation(BuildContext context, StudyState state, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: state.currentFlashcardIndex > 0
              ? () {
                  context.read<StudyBloc>().add(
                        StudyFlashcardFlipped(state.currentFlashcardIndex - 1),
                      );
                }
              : null,
          icon: Icon(
            Icons.chevron_left_rounded,
            color: state.currentFlashcardIndex > 0
                ? AppColors.primary
                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
          ),
        ),
        Text(
          '${state.currentFlashcardIndex + 1} / ${state.flashcards.length}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        IconButton(
          onPressed: state.currentFlashcardIndex < state.flashcards.length - 1
              ? () {
                  context.read<StudyBloc>().add(
                        StudyFlashcardFlipped(state.currentFlashcardIndex + 1),
                      );
                }
              : null,
          icon: Icon(
            Icons.chevron_right_rounded,
            color: state.currentFlashcardIndex < state.flashcards.length - 1
                ? AppColors.primary
                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
          ),
        ),
      ],
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
        const SizedBox(width: 12),
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
        const SizedBox(width: 12),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? color : (isDark ? AppColors.dividerDark : AppColors.dividerLight),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: isActive ? color : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? color : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
