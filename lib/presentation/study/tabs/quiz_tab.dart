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
      {'type': QuestionType.mcq, 'label': 'MCQ', 'icon': Icons.check_circle_outline},
      {'type': QuestionType.short, 'label': 'Short', 'icon': Icons.short_text},
      {'type': QuestionType.medium, 'label': 'Medium', 'icon': Icons.format_list_numbered},
      {'type': QuestionType.long, 'label': 'Long', 'icon': Icons.notes},
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 64,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            const SizedBox(height: 16),
            Text(
              'Select Quiz Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: types.map((typeInfo) {
                return GestureDetector(
                  onTap: () {
                    context.read<QuizBloc>().add(
                          QuizStarted('topic_id', typeInfo['type'] as QuestionType),
                        );
                  },
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          typeInfo['icon'] as IconData,
                          size: 32,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          typeInfo['label'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: (state.currentQuestionIndex + 1) / state.questions.length,
            backgroundColor: isDark ? AppColors.dividerDark : AppColors.dividerLight,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 12),
          Text(
            'Question ${state.currentQuestionIndex + 1} of ${state.questions.length}',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            question.question,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 24),
          if (question.type == QuestionType.mcq && question.options != null)
            ...question.options!.asMap().entries.map((entry) {
              final isSelected = state.answers[state.currentQuestionIndex] == entry.value;
              return GestureDetector(
                onTap: () {
                  context.read<QuizBloc>().add(
                        QuizAnswerSelected(state.currentQuestionIndex, entry.value),
                      );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.15)
                        : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : (isDark ? AppColors.dividerDark : AppColors.dividerLight),
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
                            color: isSelected ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + entry.key),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                context.read<QuizBloc>().add(
                      QuizAnswerSelected(state.currentQuestionIndex, value),
                    );
              },
            ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!state.isFirstQuestion)
                OutlinedButton(
                  onPressed: () {
                    context.read<QuizBloc>().add(QuizPreviousQuestion());
                  },
                  child: const Text('Previous'),
                )
              else
                const SizedBox.shrink(),
              if (state.isLastQuestion)
                ElevatedButton(
                  onPressed: () {
                    context.read<QuizBloc>().add(QuizSubmitted());
                  },
                  child: const Text('Submit'),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    context.read<QuizBloc>().add(QuizNextQuestion());
                  },
                  child: const Text('Next'),
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
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: (state.percentage >= 50 ? AppColors.success : AppColors.error).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${state.percentage.toInt()}%',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: state.percentage >= 50 ? AppColors.success : AppColors.error,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              state.percentage >= 50 ? 'Great Job!' : 'Keep Practicing!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${state.score} / ${state.totalMarks} marks',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // TODO: Review answers
              },
              child: const Text('Review Answers'),
            ),
          ],
        ),
      ),
    );
  }
}
