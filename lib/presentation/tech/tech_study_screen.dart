import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/firestore_service.dart';
import '../../core/services/progress_service.dart';
import 'tabs/learn_tab.dart';
import 'tabs/practice_tab.dart';
import 'tabs/challenge_tab.dart';
import 'tabs/notes_tab.dart';
import 'tabs/progress_tab.dart';
import 'tabs/ai_chat_tab.dart';
import 'screens/pdf_reader_screen.dart';
import 'screens/cheatsheet_screen.dart';

enum TechTab { learn, practice, challenge, notes, progress, aiChat }

class TechStudyScreen extends StatefulWidget {
  final String subjectId;
  final String chapterId;
  final String topicId;
  final String topicName;

  const TechStudyScreen({
    super.key,
    required this.subjectId,
    required this.chapterId,
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
    _updateStreak();
  }

  Future<void> _updateStreak() async {
    try {
      await context.read<ProgressService>().updateStreak('python');
    } catch (_) {}
  }

  Future<void> _markComplete() async {
    try {
      await context.read<ProgressService>().markTopicComplete(
        'python',
        widget.topicId,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Topic marked as complete!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _loadContent() async {
    final firestore = context.read<FirestoreService>();
    try {
      final content = await firestore.getTechTopicContent(
        widget.subjectId,
        widget.chapterId,
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
      appBar: AppBar(
        title: Text(widget.topicName, style: const TextStyle(fontSize: 16)),
        actions: [
          // Mark Complete
          IconButton(
            icon: const Icon(Icons.check_circle_outline, size: 20),
            tooltip: 'Mark Complete',
            onPressed: _markComplete,
          ),
          // Handbook button
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded, size: 20),
            tooltip: 'Python Handbook',
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => const PdfReaderScreen(
                title: 'Python Handbook',
                assetPath: 'assets/pdfs/python_handbook.pdf',
              ),
            )),
          ),
          // Cheatsheet button
          IconButton(
            icon: const Icon(Icons.lightbulb_outline, size: 20),
            tooltip: 'Cheatsheet',
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => CheatsheetScreen(chapterId: widget.chapterId),
            )),
          ),
          // Notes PDF button
          IconButton(
            icon: const Icon(Icons.menu_book_rounded, size: 20),
            tooltip: 'Handwritten Notes',
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => const PdfReaderScreen(
                title: 'Python Notes',
                assetPath: 'assets/pdfs/python_notes.pdf',
              ),
            )),
          ),
        ],
      ),
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
    final tabs = [
      TechTab.learn,
      TechTab.practice,
      TechTab.challenge,
      TechTab.notes,
      TechTab.progress,
      TechTab.aiChat,
    ];
    final labels = ['Learn', 'Practice', 'Challenge', 'Notes', 'Progress', 'AI Chat'];
    final icons = [
      Icons.play_circle_outline_rounded,
      Icons.code_rounded,
      Icons.flag_rounded,
      Icons.sticky_note_2_rounded,
      Icons.bar_chart_rounded,
      Icons.smart_toy_rounded,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
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
                margin: const EdgeInsets.symmetric(horizontal: 1),
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (tabs[index] == TechTab.aiChat ? AppColors.tech.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.1))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icons[index],
                      size: 16,
                      color: isSelected
                          ? (tabs[index] == TechTab.aiChat ? AppColors.tech : AppColors.primary)
                          : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      labels[index],
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? (tabs[index] == TechTab.aiChat ? AppColors.tech : AppColors.primary)
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
        return NotesTab(content: content, chapterId: widget.chapterId);
      case TechTab.progress:
        return ProgressTab(content: content, roadmap: _roadmap, topicId: widget.topicId);
      case TechTab.aiChat:
        return AiChatTab(subjectId: widget.subjectId, chapterId: widget.chapterId, topicId: widget.topicId);
    }
  }
}
