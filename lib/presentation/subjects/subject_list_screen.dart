import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/content/content_bloc.dart';
import '../../blocs/content/content_event.dart';
import '../../blocs/content/content_state.dart';
import '../../data/models/subject_model.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/chapter_tile.dart';
import '../study/study_screen.dart';

class SubjectListScreen extends StatelessWidget {
  final SubjectModel subject;

  const SubjectListScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    context.read<ContentBloc>().add(ContentChaptersLoaded(subject.id));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(subject.icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(subject.name),
          ],
        ),
      ),
      body: BlocBuilder<ContentBloc, ContentState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.chapters.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 48,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white24
                        : Colors.black26,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No chapters available yet',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white38
                          : Colors.black38,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.chapters.length,
            itemBuilder: (context, index) {
              final chapter = state.chapters[index];
              return ChapterTile(
                order: chapter.order,
                name: chapter.name,
                totalTopics: chapter.totalTopics,
                progress: chapter.progress,
                onTap: () {
                  context.read<ContentBloc>().add(
                        ContentTopicsLoaded(subject.id, chapter.id),
                      );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _TopicListScreen(
                        subjectId: subject.id,
                        chapterId: chapter.id,
                        chapterName: chapter.name,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _TopicListScreen extends StatelessWidget {
  final String subjectId;
  final String chapterId;
  final String chapterName;

  const _TopicListScreen({
    required this.subjectId,
    required this.chapterId,
    required this.chapterName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(chapterName)),
      body: BlocBuilder<ContentBloc, ContentState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.topics.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.topic_outlined,
                    size: 48,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white24
                        : Colors.black26,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No topics available yet',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white38
                          : Colors.black38,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.topics.length,
            itemBuilder: (context, index) {
              final topic = state.topics[index];
              return Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1A2035)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                    width: 0.5,
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${topic.order}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    topic.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFF1F5F9)
                          : const Color(0xFF0F172A),
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                  ),
                  onTap: () {
                    context.read<ContentBloc>().add(
                          ContentTopicSelected(subjectId, chapterId, topic.id),
                        );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StudyScreen(
                          subjectId: subjectId,
                          chapterId: chapterId,
                          topicId: topic.id,
                          topicName: topic.name,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
