import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/quiz/quiz_bloc.dart';
import '../../../blocs/quiz/quiz_event.dart';
import '../../../blocs/quiz/quiz_state.dart';
import '../../../data/models/question_model.dart';
import '../../../core/constants/app_colors.dart';

class QuizTab extends StatelessWidget {
  const QuizTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<QuizBloc, QuizState>(
      builder: (context, state) {
        if (state.questions.isEmpty && !state.isLoading) {
          return _buildQuizTypeSelector(context, isDark);
        }

        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isSubmitted) {
          return _buildQuizResult(context, state, isDark);
        }

        return _buildQuizQuestion(context, state, isDark);
      },
    );
  }

  Widget _buildQuizTypeSelector(BuildContext context, bool isDark) {
    final types = [
      {'type': QuestionType.mcq, 'label': 'MCQ', 'icon': Icons.check_circle_outline_rounded},
      {'type': QuestionType.short, 'label': 'Short', 'icon': Icons.short_text_rounded},
      {'type': QuestionType.medium, 'label': 'Medium', 'icon': Icons.format_list_numbered_rounded},
      {'type': QuestionType.long, 'label': 'Long', 'icon': Icons.notes_rounded},
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 48,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
            ),
            const SizedBox(height: 12),
            Text(
              'Select Quiz Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.2,
              children: types.map((typeInfo) {
                return GestureDetector(
                  onTap: () {
                    context.read<QuizBloc>().add(
                          QuizStarted('topic_id', typeInfo['type'] as QuestionType),
                        );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            typeInfo['icon'] as IconData,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          typeInfo['label'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizQuestion(BuildContext context, QuizState state, bool isDark) {
    final question = state.currentQuestion;
    if (question == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (state.currentQuestionIndex + 1) / state.questions.length,
                    backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${state.currentQuestionIndex + 1}/${state.questions.length}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Question
          Text(
            question.question,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          // Options
          if (question.type == QuestionType.mcq && question.options != null)
            ...question.options!.asMap().entries.map((entry) {
              final isSelected = state.answers[state.currentQuestionIndex] == entry.value;
              return GestureDetector(
                onTap: () {
                  context.read<QuizBloc>().add(
                        QuizAnswerSelected(state.currentQuestionIndex, entry.value),
                      );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : (isDark ? AppColors.cardDark : AppColors.cardLight),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                      width: isSelected ? 1.5 : 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + entry.key),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
          else
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Type your answer...',
              ),
              onChanged: (value) {
                context.read<QuizBloc>().add(
                      QuizAnswerSelected(state.currentQuestionIndex, value),
                    );
              },
            ),
          const SizedBox(height: 24),
          // Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!state.isFirstQuestion)
                OutlinedButton.icon(
                  onPressed: () => context.read<QuizBloc>().add(QuizPreviousQuestion()),
                  icon: const Icon(Icons.chevron_left_rounded, size: 18),
                  label: const Text('Previous'),
                )
              else
                const SizedBox.shrink(),
              if (state.isLastQuestion)
                ElevatedButton.icon(
                  onPressed: () => context.read<QuizBloc>().add(QuizSubmitted()),
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text('Submit'),
                )
              else
                ElevatedButton.icon(
                  onPressed: () => context.read<QuizBloc>().add(QuizNextQuestion()),
                  icon: const Icon(Icons.chevron_right_rounded, size: 18),
                  label: const Text('Next'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuizResult(BuildContext context, QuizState state, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: (state.percentage >= 50 ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${state.percentage.toInt()}%',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: state.percentage >= 50 ? AppColors.success : AppColors.error,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              state.percentage >= 50 ? 'Great Job!' : 'Keep Practicing!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${state.score} / ${state.totalMarks} marks',
              style: TextStyle(
                fontSize: 15,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Review Answers'),
            ),
          ],
        ),
      ),
    );
  }
}
