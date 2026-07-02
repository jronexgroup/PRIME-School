import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/firestore_service.dart';
import 'tabs/learn_tab.dart';
import 'tabs/practice_tab.dart';
import 'tabs/challenge_tab.dart';
import 'tabs/notes_tab.dart';
import 'tabs/progress_tab.dart';

enum TechTab { learn, practice, challenge, notes, progress }

class TechStudyScreen extends StatefulWidget {
  final String subjectId;
  final String topicId;
  final String topicName;

  const TechStudyScreen({
    super.key,
    required this.subjectId,
    required this.topicId,
    required this.topicName,
  });

  @override
  State<TechStudyScreen> createState() => _TechStudyScreenState();
}

class _TechStudyScreenState extends State<TechStudyScreen> {
  TechTab _currentTab = TechTab.learn;
  Map<String, dynamic>? _topicContent;
  List<Map<String, dynamic>> _roadmap = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final firestore = context.read<FirestoreService>();
    try {
      final content = await firestore.getTechTopicContent(
        widget.subjectId,
        widget.topicId,
      );
      final roadmap = await firestore.getTechRoadmap(widget.subjectId);
      if (mounted) {
        setState(() {
          _topicContent = content;
          _roadmap = roadmap;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(widget.topicName)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildTabBar(isDark),
                Expanded(child: _buildTabContent()),
              ],
            ),
    );
  }

  Widget _buildTabBar(bool isDark) {
    final tabs = [TechTab.learn, TechTab.practice, TechTab.challenge, TechTab.notes, TechTab.progress];
    final labels = ['Learn', 'Practice', 'Challenge', 'Notes', 'Progress'];
    final icons = [
      Icons.play_circle_outline_rounded,
      Icons.code_rounded,
      Icons.flag_rounded,
      Icons.sticky_note_2_rounded,
      Icons.bar_chart_rounded,
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
          final isSelected = _currentTab == tabs[index];
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentTab = tabs[index]),
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
                      icons[index],
                      size: 18,
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      labels[index],
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

  Widget _buildTabContent() {
    final content = _topicContent ?? {};
    switch (_currentTab) {
      case TechTab.learn:
        return LearnTab(content: content, roadmap: _roadmap, subjectId: widget.subjectId, topicId: widget.topicId);
      case TechTab.practice:
        return PracticeTab(content: content);
      case TechTab.challenge:
        return ChallengeTab(content: content);
      case TechTab.notes:
        return NotesTab(content: content);
      case TechTab.progress:
        return ProgressTab(content: content, roadmap: _roadmap, topicId: widget.topicId);
    }
  }
}
