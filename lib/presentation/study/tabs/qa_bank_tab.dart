import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/study/study_bloc.dart';
import '../../../blocs/study/study_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/question_model.dart';

class QaBankTab extends StatelessWidget {
  const QaBankTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudyBloc, StudyState>(
      builder: (context, state) {
        final content = state.topicContent;
        if (content == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final sections = <_QaSection>[];

        final quiz = state.quiz;
        if (quiz != null) {
          final mcq = _parseQuestions(quiz['mcq']);
          final veryShort = _parseQuestions(quiz['very_short_1mark']);
          final short = _parseQuestions(quiz['short_2mark']);
          final evaluation = _parseQuestions(quiz['evaluation_4mark']);
          final explanatory = _parseQuestions(quiz['explanatory_8mark']);
          if (mcq.isNotEmpty) sections.add(_QaSection('Quiz MCQ', mcq, Icons.quiz_outlined, AppColors.primary));
          if (veryShort.isNotEmpty) sections.add(_QaSection('Very Short (1M)', veryShort, Icons.short_text_outlined, Colors.orange));
          if (short.isNotEmpty) sections.add(_QaSection('Short (2M)', short, Icons.text_snippet_outlined, Colors.teal));
          if (evaluation.isNotEmpty) sections.add(_QaSection('Evaluation (4M)', evaluation, Icons.article_outlined, Colors.purple));
          if (explanatory.isNotEmpty) sections.add(_QaSection('Explanatory (8M)', explanatory, Icons.menu_book_outlined, Colors.deepOrange));
        }

        final bk = state.bookQuestions;
        if (bk != null) {
          final mcq = _parseQuestions(bk['mcq']);
          final vs = _parseQuestions(bk['very_short']);
          final sh = _parseQuestions(bk['short']);
          final lg = _parseQuestions(bk['long']);
          if (mcq.isNotEmpty) sections.add(_QaSection('Book MCQ', mcq, Icons.book_outlined, AppColors.primary));
          if (vs.isNotEmpty) sections.add(_QaSection('Book Very Short', vs, Icons.book_outlined, Colors.orange));
          if (sh.isNotEmpty) sections.add(_QaSection('Book Short', sh, Icons.book_outlined, Colors.teal));
          if (lg.isNotEmpty) sections.add(_QaSection('Book Long', lg, Icons.book_outlined, Colors.purple));
        }

        final eb = state.examBank;
        if (eb != null) {
          final mostImp = _parseExamBankItems(eb['most_important_questions'], 'most_important');
          final freq = _parseExamBankItems(eb['frequently_asked'], 'frequently_asked');
          final tricky = _parseTrickyMcq(eb['tricky_mcq']);
          if (mostImp.isNotEmpty) sections.add(_QaSection('Most Important', mostImp, Icons.star_outlined, AppColors.warning));
          if (freq.isNotEmpty) sections.add(_QaSection('Frequently Asked', freq, Icons.trending_up_outlined, Colors.blue));
          if (tricky.isNotEmpty) sections.add(_QaSection('Tricky MCQ', tricky, Icons.bug_report_outlined, Colors.red));
        }

        if (sections.isEmpty) {
          return _buildEmptyState();
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: sections.map((s) => _QuestionSection(
            label: s.label,
            questions: s.questions,
            icon: s.icon,
            color: s.color,
          )).toList(),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.question_answer_outlined,
                size: 32,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No questions yet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              'Questions will appear here once generated',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  List<QuestionModel> _parseQuestions(dynamic field) {
    if (field == null) return [];
    if (field is List) {
      return field.map((q) => QuestionModel.fromMap(q is Map<String, dynamic> ? q : <String, dynamic>{})).toList();
    }
    return [];
  }

  List<_ExamBankItem> _parseExamBankItems(dynamic field, String type) {
    if (field == null) return [];
    if (field is List) {
      return field.map((item) {
        final m = item as Map<String, dynamic>;
        return _ExamBankItem(
          question: '${m['question'] ?? ''}',
          answer: '${m['answer'] ?? ''}',
          why: type == 'most_important' ? '${m['why'] ?? ''}' : '',
          frequency: type == 'frequently_asked' ? '${m['frequency'] ?? ''}' : '',
        );
      }).toList();
    }
    return [];
  }

  List<_TrickyMcqItem> _parseTrickyMcq(dynamic field) {
    if (field == null) return [];
    if (field is List) {
      return field.map((item) {
        final m = item as Map<String, dynamic>;
        return _TrickyMcqItem(
          question: '${m['question'] ?? ''}',
          options: m['options'] != null ? List<String>.from(m['options']) : [],
          correct: '${m['correct'] ?? ''}',
          commonMistake: '${m['commonMistake'] ?? ''}',
          trap: '${m['trap'] ?? ''}',
        );
      }).toList();
    }
    return [];
  }
}

class _QaSection {
  final String label;
  final List<dynamic> questions;
  final IconData icon;
  final Color color;
  _QaSection(this.label, this.questions, this.icon, this.color);
}

class _ExamBankItem {
  final String question;
  final String answer;
  final String why;
  final String frequency;
  _ExamBankItem({required this.question, required this.answer, this.why = '', this.frequency = ''});
}

class _TrickyMcqItem {
  final String question;
  final List<String> options;
  final String correct;
  final String commonMistake;
  final String trap;
  _TrickyMcqItem({required this.question, required this.options, required this.correct, required this.commonMistake, required this.trap});
}

class _QuestionSection extends StatefulWidget {
  final String label;
  final List<dynamic> questions;
  final IconData icon;
  final Color color;

  const _QuestionSection({
    required this.label,
    required this.questions,
    required this.icon,
    required this.color,
  });

  @override
  State<_QuestionSection> createState() => _QuestionSectionState();
}

class _QuestionSectionState extends State<_QuestionSection> {
  final Set<int> _expandedIndexes = {};

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Row(
            children: [
              Icon(widget.icon, size: 20, color: widget.color),
              const SizedBox(width: 8),
              Text(
                '${widget.label} (${widget.questions.length})',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
        ),
        ...List.generate(widget.questions.length, (i) {
          final q = widget.questions[i];
          if (q is QuestionModel) {
            return _buildQuestionCard(q, i, isDark);
          } else if (q is _ExamBankItem) {
            return _buildExamBankCard(q, i, isDark);
          } else if (q is _TrickyMcqItem) {
            return _buildTrickyMcqCard(q, i, isDark);
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildQuestionCard(QuestionModel q, int i, bool isDark) {
    final isExpanded = _expandedIndexes.contains(i);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            if (isExpanded) {
              _expandedIndexes.remove(i);
            } else {
              _expandedIndexes.add(i);
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: widget.color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      q.question,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${q.marks}M',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: widget.color,
                      ),
                    ),
                  ),
                ],
              ),
              if (q.options != null && q.options!.isNotEmpty) ...[
                const SizedBox(height: 8),
                ...List.generate(q.options!.length, (oi) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 34, top: 3),
                    child: Row(
                      children: [
                        Text(
                          '${String.fromCharCode(0x0995 + oi)}) ',
                          style: const TextStyle(fontSize: 13),
                        ),
                        Expanded(
                          child: Text(
                            q.options![oi],
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
              if (isExpanded) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (q.explanation != null && q.explanation!.isNotEmpty) ...[
                        Text(
                          'Answer',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: widget.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          q.answer,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Explanation',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: widget.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          q.explanation!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            height: 1.4,
                          ),
                        ),
                      ] else ...[
                        Text(
                          'Answer',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: widget.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          q.answer,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamBankCard(_ExamBankItem item, int i, bool isDark) {
    final isExpanded = _expandedIndexes.contains(i);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            if (isExpanded) {
              _expandedIndexes.remove(i);
            } else {
              _expandedIndexes.add(i);
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: widget.color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.question,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                ],
              ),
              if (item.why.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 34, top: 4),
                  child: Row(
                    children: [
                      Icon(Icons.star, size: 14, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.why,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.warning,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (item.frequency.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 34, top: 4),
                  child: Row(
                    children: [
                      Icon(Icons.trending_up, size: 14, color: Colors.blue),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.frequency,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (isExpanded) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.answer,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrickyMcqCard(_TrickyMcqItem item, int i, bool isDark) {
    final isExpanded = _expandedIndexes.contains(i);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            if (isExpanded) {
              _expandedIndexes.remove(i);
            } else {
              _expandedIndexes.add(i);
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: widget.color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.question,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ...List.generate(item.options.length, (oi) {
                return Padding(
                  padding: const EdgeInsets.only(left: 34, top: 2),
                  child: Row(
                    children: [
                      Text(
                        '${String.fromCharCode(65 + oi)}) ',
                        style: const TextStyle(fontSize: 13),
                      ),
                      Expanded(
                        child: Text(
                          item.options[oi],
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              if (isExpanded) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '✅ Correct: ${item.correct}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.warning_amber, size: 14, color: AppColors.error),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '⚠️ ${item.commonMistake}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.error,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline, size: 14, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '💡 ${item.trap}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.warning,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
