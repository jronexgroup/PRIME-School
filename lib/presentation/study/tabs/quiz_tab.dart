import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/quiz/quiz_bloc.dart';
import '../../../blocs/quiz/quiz_event.dart';
import '../../../blocs/quiz/quiz_state.dart';
import '../../../blocs/study/study_bloc.dart';
import '../../../core/constants/app_colors.dart';

class QuizTab extends StatelessWidget {
  const QuizTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<QuizBloc, QuizState>(
      builder: (context, state) {
        if (state.questions.isEmpty && !state.isSubmitted) {
          return _buildQuizTypeSelector(context, isDark);
        }

        if (state.isSubmitted) {
          return _buildQuizResult(context, state, isDark);
        }

        return _buildQuizQuestion(context, state, isDark);
      },
    );
  }

  List<Map<String, dynamic>> _getQuestionsFromType(
      BuildContext context, String type) {
    final studyState = context.read<StudyBloc>().state;
    final quiz = studyState.quiz;
    if (quiz == null) return [];

    switch (type) {
      case 'mcq':
        final data = quiz['mcq'];
        if (data is List) return data.cast<Map<String, dynamic>>();
        return [];
      case 'very_short_1mark':
        final data = quiz['very_short_1mark'];
        if (data is List) return data.cast<Map<String, dynamic>>();
        return [];
      case 'short_2mark':
        final data = quiz['short_2mark'];
        if (data is List) return data.cast<Map<String, dynamic>>();
        return [];
      case 'evaluation_4mark':
        final data = quiz['evaluation_4mark'];
        if (data is List) return data.cast<Map<String, dynamic>>();
        return [];
      case 'explanatory_8mark':
        final data = quiz['explanatory_8mark'];
        if (data is List) return data.cast<Map<String, dynamic>>();
        return [];
      default:
        return [];
    }
  }

  int _totalMarksForType(String type, List<Map<String, dynamic>> questions) {
    int total = 0;
    for (final q in questions) {
      total += (q['marks'] ?? 1) as int;
    }
    return total;
  }

  Widget _buildQuizTypeSelector(BuildContext context, bool isDark) {
    final types = [
      {'key': 'mcq', 'label': 'MCQ', 'icon': Icons.check_circle_outline_rounded, 'desc': 'Multiple Choice'},
      {'key': 'very_short_1mark', 'label': 'Very Short', 'icon': Icons.short_text_rounded, 'desc': '1 Mark'},
      {'key': 'short_2mark', 'label': 'Short', 'icon': Icons.format_list_numbered_rounded, 'desc': '2 Marks'},
      {'key': 'evaluation_4mark', 'label': 'Evaluation', 'icon': Icons.analytics_outlined, 'desc': '4 Marks'},
      {'key': 'explanatory_8mark', 'label': 'Explanatory', 'icon': Icons.notes_rounded, 'desc': '8 Marks'},
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
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
              const SizedBox(height: 8),
              Text(
                'Choose a question format to practice',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                ),
              ),
              const SizedBox(height: 24),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: types.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final t = types[index];
                  final questions = _getQuestionsFromType(context, t['key'] as String);
                  return GestureDetector(
                    onTap: questions.isEmpty
                        ? null
                        : () {
                            context.read<QuizBloc>().add(
                                  QuizStarted(
                                    questions,
                                    _totalMarksForType(t['key'] as String, questions),
                                  ),
                                );
                          },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.cardLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: questions.isEmpty
                              ? (isDark ? AppColors.borderDark : AppColors.borderLight).withValues(alpha: 0.3)
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(t['icon'] as IconData, color: AppColors.primary),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t['label'] as String,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${questions.length} questions \u2022 ${t['desc']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizQuestion(BuildContext context, QuizState state, bool isDark) {
    final question = state.currentQuestion;
    if (question == null) return const SizedBox.shrink();

    final isMcq = question['options'] != null;
    final options = isMcq ? (question['options'] as List).cast<String>() : <String>[];
    final correctIdx = question['correctIndex'];
    final correctAnswer = question['answer'] as String? ?? '';
    final qIdx = state.currentQuestionIndex;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (qIdx + 1) / state.questions.length,
                    backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${qIdx + 1}/${state.questions.length}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            question['question'] as String? ?? '',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${question['marks'] ?? 1} mark${(question['marks'] ?? 1) == 1 ? '' : 's'}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          if (isMcq)
            ...options.asMap().entries.map((entry) {
              final isSelected = state.answers[qIdx] == entry.value;
              final isCorrectChoice = correctIdx != null && entry.key == (correctIdx as int);
              final hasAnswered = state.answers.containsKey(qIdx);
              Color? borderColor;
              if (hasAnswered) {
                if (isCorrectChoice) {
                  borderColor = Colors.green;
                } else if (isSelected && !isCorrectChoice) {
                  borderColor = Colors.red;
                }
              } else if (isSelected) {
                borderColor = AppColors.primary;
              }
              return GestureDetector(
                onTap: () {
                  if (!hasAnswered) {
                    final isCorrect = correctIdx != null && entry.key == (correctIdx as int);
                    context.read<QuizBloc>().add(
                          QuizAnswerSelected(qIdx, entry.value, isCorrect),
                        );
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: borderColor != null
                        ? borderColor.withValues(alpha: 0.08)
                        : (isDark ? AppColors.cardDark : AppColors.cardLight),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: borderColor ?? (isDark ? AppColors.borderDark : AppColors.borderLight),
                      width: borderColor != null ? 1.5 : 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: borderColor ?? Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: borderColor ?? (isDark ? AppColors.borderDark : AppColors.borderLight),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + entry.key),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: borderColor != null ? Colors.white : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
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
                hintStyle: TextStyle(
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                ),
                filled: true,
                fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    width: 0.5,
                  ),
                ),
              ),
              onChanged: (value) {
                final isCorrect = value.trim().toLowerCase() == correctAnswer.trim().toLowerCase();
                context.read<QuizBloc>().add(
                      QuizAnswerSelected(qIdx, value, isCorrect),
                    );
              },
            ),
          if (isMcq && state.answers.containsKey(qIdx) && question['explanation'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        question['explanation'] as String? ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
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
    final total = state.questions.length;
    final answered = state.answers.length;
    final correct = state.correctness.values.where((c) => c).length;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: (state.percentage >= 50 ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
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
              const SizedBox(height: 20),
              Text(
                state.percentage >= 50 ? 'Great Job!' : 'Keep Practicing!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 12),
              _buildStatRow('Score', '${state.score ?? 0} / ${state.totalMarks} marks', isDark),
              _buildStatRow('Correct', '$correct / $total questions', isDark),
              _buildStatRow('Answered', '$answered / $total questions', isDark),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => _showReview(context, state, isDark),
                icon: const Icon(Icons.replay_rounded, size: 18),
                label: const Text('Review Answers'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => context.read<QuizBloc>().add(QuizReset()),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Back to Quiz Types'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }

  void _showReview(BuildContext context, QuizState state, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Answer Review',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: state.questions.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final q = state.questions[i];
                    final userAns = state.answers[i];
                    final isCorrect = state.correctness[i];
                    final correctAns = q['answer'] as String? ?? '';
                    final isMcq = q['options'] != null;
                    final opts = isMcq ? (q['options'] as List).cast<String>() : <String>[];
                    final correctIdx = q['correctIndex'];
                    final correctOption = isMcq && correctIdx != null ? opts[correctIdx as int] : '';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: isCorrect == true
                                      ? AppColors.success
                                      : (isCorrect == false ? AppColors.error : Colors.grey),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isCorrect == true
                                      ? Icons.check_rounded
                                      : (isCorrect == false ? Icons.close_rounded : Icons.remove_rounded),
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Q${i + 1}: ${q['question'] ?? ''}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    if (isMcq) ...[
                                      if (userAns != null)
                                        Text(
                                          'Your answer: $userAns',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isCorrect == true ? AppColors.success : AppColors.error,
                                          ),
                                        ),
                                      Text(
                                        'Correct: $correctOption',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.success,
                                        ),
                                      ),
                                    ] else ...[
                                      if (userAns != null)
                                        Text(
                                          'Your answer: $userAns',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isCorrect == true ? AppColors.success : AppColors.error,
                                          ),
                                        ),
                                      Text(
                                        'Correct: $correctAns',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.success,
                                        ),
                                      ),
                                    ],
                                    if (q['explanation'] != null && (q['explanation'] as String).isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        q['explanation'] as String,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
