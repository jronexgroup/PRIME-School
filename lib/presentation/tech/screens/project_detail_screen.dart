import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/firestore_service.dart';
import '../widgets/youtube_embed_widget.dart';

class ProjectDetailScreen extends StatefulWidget {
  final String subjectId;
  final String chapterId;
  final String topicId;
  final String topicName;

  const ProjectDetailScreen({
    super.key,
    required this.subjectId,
    required this.chapterId,
    required this.topicId,
    required this.topicName,
  });

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  Map<String, dynamic>? _content;
  bool _isLoading = true;
  int _buildStepIndex = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final firestore = context.read<FirestoreService>();
    try {
      final content = await firestore.getTechTopicContent(
        widget.subjectId, widget.chapterId, widget.topicId,
      );
      if (mounted) setState(() { _content = content; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (_isLoading) return Scaffold(appBar: AppBar(title: Text(widget.topicName)), body: const Center(child: CircularProgressIndicator()));

    final content = _content ?? {};
    final keyPoints = (content['keyPoints'] as List?)?.cast<String>() ?? [];
    final codeExamples = (content['codeExamples'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final challenges = (content['challenges'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final aiCoachScript = content['aiCoachScript'] as String? ?? '';
    final videoUrl = content['videoUrl'] as String? ?? '';
    final importantSyntax = (content['importantSyntax'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(widget.topicName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // === OVERVIEW ===
          _buildSectionHeader('Project Overview', Icons.rocket_launch_rounded, AppColors.tech, isDark),
          const SizedBox(height: 8),
          if (aiCoachScript.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.tech.withValues(alpha: 0.08), AppColors.primary.withValues(alpha: 0.05)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.tech.withValues(alpha: 0.2)),
              ),
              child: Text(aiCoachScript, style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.7)),
            ),
          const SizedBox(height: 16),

          if (videoUrl.isNotEmpty) ...[
            YoutubeEmbedWidget(videoUrl: videoUrl),
            const SizedBox(height: 16),
          ],

          // === ROADMAP ===
          _buildSectionHeader('Build Roadmap', Icons.map_outlined, AppColors.warning, isDark),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
            ),
            child: Column(
              children: List.generate(keyPoints.length, (i) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.warning.withValues(alpha: 0.15)),
                      child: Center(child: Text('${i + 1}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.warning))),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(keyPoints[i], style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.4))),
                  ],
                ),
              )),
            ),
          ),
          const SizedBox(height: 20),

          // === GUIDED BUILD ===
          _buildSectionHeader('Guided Build', Icons.build_circle_outlined, AppColors.primary, isDark),
          const SizedBox(height: 8),
          if (codeExamples.isNotEmpty) ...[
            Row(
              children: [
                if (_buildStepIndex > 0)
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 20),
                    onPressed: () => setState(() => _buildStepIndex--),
                  ),
                Expanded(
                  child: Center(child: Text('Step ${_buildStepIndex + 1} of ${codeExamples.length}', style: TextStyle(fontSize: 11, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight))),
                ),
                if (_buildStepIndex < codeExamples.length - 1)
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 20),
                    onPressed: () => setState(() => _buildStepIndex++),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _buildCodeCard(codeExamples[_buildStepIndex], isDark),
          ],
          const SizedBox(height: 20),

          // === YOUR VERSION ===
          _buildSectionHeader('Build Your Version', Icons.code_rounded, AppColors.accent, isDark),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Try these challenges to build your own version:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                const SizedBox(height: 12),
                if (challenges.isNotEmpty)
                  ...challenges.map((c) => Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: c['difficulty'] == 'hard'
                          ? AppColors.error.withValues(alpha: 0.06)
                          : c['difficulty'] == 'medium'
                              ? AppColors.warning.withValues(alpha: 0.06)
                              : AppColors.success.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: c['difficulty'] == 'hard'
                            ? AppColors.error.withValues(alpha: 0.15)
                            : c['difficulty'] == 'medium'
                                ? AppColors.warning.withValues(alpha: 0.15)
                                : AppColors.success.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: c['difficulty'] == 'hard'
                                    ? AppColors.error.withValues(alpha: 0.15)
                                    : c['difficulty'] == 'medium'
                                        ? AppColors.warning.withValues(alpha: 0.15)
                                        : AppColors.success.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(c['difficulty'] ?? 'easy', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600,
                                  color: c['difficulty'] == 'hard' ? AppColors.error : c['difficulty'] == 'medium' ? AppColors.warning : AppColors.success)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(c['question'] ?? '', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
                          ],
                        ),
                        if ((c['hint'] as String?)?.isNotEmpty == true) ...[
                          const SizedBox(height: 6),
                          Text('💡 ${c['hint']}', style: TextStyle(fontSize: 11, color: AppColors.tech, fontStyle: FontStyle.italic)),
                        ],
                      ],
                    ),
                  )),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // === EXTENSION IDEAS ===
          _buildSectionHeader('Extension Ideas', Icons.auto_awesome_rounded, AppColors.tech, isDark),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.tech.withValues(alpha: 0.05), AppColors.primary.withValues(alpha: 0.03)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.tech.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Take your project to the next level:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                const SizedBox(height: 12),
                ..._getExtensionIdeas(challenges).map((idea) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.auto_awesome, size: 14, color: AppColors.tech),
                      const SizedBox(width: 8),
                      Expanded(child: Text(idea, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.4))),
                    ],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // === IMPORTANT SYNTAX REFERENCE ===
          if (importantSyntax.isNotEmpty) ...[
            _buildSectionHeader('Syntax Reference', Icons.code_rounded, AppColors.accent, isDark),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
              ),
              child: Column(
                children: importantSyntax.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 80, child: Text(s['syntax'] ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFE879F9), fontFamily: 'monospace'))),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if ((s['example'] as String?)?.isNotEmpty == true)
                              Text(s['example'] ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFFA6E3A1), fontFamily: 'monospace')),
                            Text(s['description'] ?? '', style: TextStyle(fontSize: 11, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<String> _getExtensionIdeas(List<Map<String, dynamic>> challenges) {
    final ideas = <String>[];
    for (final c in challenges) {
      if (c['difficulty'] == 'hard') {
        ideas.add(c['question'] as String? ?? '');
      }
    }
    ideas.add('Add a GUI interface using tkinter or PyQt');
    ideas.add('Save user progress/scores to a file or database');
    ideas.add('Add sound effects and animations');
    ideas.add('Deploy as a web app using Streamlit or Flask');
    ideas.add('Add multiplayer support via socket programming');
    return ideas;
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
      ],
    );
  }

  Widget _buildCodeCard(Map<String, dynamic> example, bool isDark) {
    final code = example['code'] as String? ?? '';
    final explanation = example['explanation'] as String? ?? '';
    final output = example['output'] as String? ?? '';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(example['title'] ?? '', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SelectableText(code, style: const TextStyle(fontSize: 11, color: Color(0xFFA6E3A1), fontFamily: 'monospace', height: 1.5)),
          ),
          if (output.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.terminal_rounded, size: 12, color: Colors.white38),
                  const SizedBox(width: 6),
                  Expanded(child: Text(output, style: const TextStyle(fontSize: 11, color: Colors.white54, fontFamily: 'monospace'))),
                ],
              ),
            ),
          ],
          if (explanation.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.info_outline, size: 12, color: AppColors.tech),
                const SizedBox(width: 6),
                Expanded(child: Text(explanation, style: TextStyle(fontSize: 11, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
