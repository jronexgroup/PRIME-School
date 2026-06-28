import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/study/study_bloc.dart';
import '../../blocs/study/study_event.dart';
import '../../blocs/study/study_state.dart';
import '../../blocs/exam/exam_bloc.dart';
import '../../blocs/exam/exam_state.dart';
import '../../core/constants/app_colors.dart';
import 'tabs/understand_tab.dart';
import 'tabs/flashcards_tab.dart';
import 'tabs/quiz_tab.dart';
import 'tabs/qa_bank_tab.dart';
import 'tabs/chat_tab.dart';

class StudyScreen extends StatelessWidget {
  final String subjectId;
  final String chapterId;
  final String topicId;
  final String topicName;

  const StudyScreen({
    super.key,
    required this.subjectId,
    required this.chapterId,
    required this.topicId,
    required this.topicName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    context.read<StudyBloc>().add(
          StudyContentLoaded(subjectId, chapterId, topicId),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(topicName),
        actions: [
          BlocBuilder<ExamBloc, ExamState>(
            builder: (context, examState) {
              if (!examState.isExamMode) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.bookmark_add_rounded),
                onPressed: () {},
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<StudyBloc, StudyState>(
        builder: (context, state) {
          return Column(
            children: [
              _buildTabBar(context, state, isDark),
              Expanded(
                child: _buildTabContent(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, StudyState state, bool isDark) {
    final tabs = [
      StudyTab.understand,
      StudyTab.flashcards,
      StudyTab.quiz,
      StudyTab.qaBank,
      StudyTab.chat,
    ];

    final tabLabels = ['Understand', 'Flashcards', 'Quiz', 'Q&A', 'Chat'];
    final tabIcons = [
      Icons.lightbulb_outline_rounded,
      Icons.style_outlined,
      Icons.quiz_outlined,
      Icons.question_answer_outlined,
      Icons.chat_outlined,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = state.currentTab == tabs[index];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<StudyBloc>().add(StudyTabChanged(tabs[index]));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tabIcons[index],
                      size: 18,
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      tabLabels[index],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabContent(StudyState state) {
    switch (state.currentTab) {
      case StudyTab.understand:
        return const UnderstandTab();
      case StudyTab.flashcards:
        return const FlashcardsTab();
      case StudyTab.quiz:
        return const QuizTab();
      case StudyTab.qaBank:
        return const QaBankTab();
      case StudyTab.chat:
        return const ChatTab();
    }
  }
}
