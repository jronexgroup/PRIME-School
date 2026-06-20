import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/content/content_bloc.dart';
import '../../blocs/content/content_event.dart';
import '../../blocs/content/content_state.dart';
import '../../data/models/chapter_model.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/topic_tile.dart';
import '../study/study_screen.dart';

class ChapterListScreen extends StatelessWidget {
  final String subjectId;
  final ChapterModel chapter;

  const ChapterListScreen({
    super.key,
    required this.subjectId,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    context.read<ContentBloc>().add(ContentTopicsLoaded(subjectId, chapter.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(chapter.name),
      ),
      body: BlocBuilder<ContentBloc, ContentState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    state.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ContentBloc>().add(
                            ContentTopicsLoaded(subjectId, chapter.id),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.topics.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.topic_outlined,
                    size: 64,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No topics available yet',
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

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.topics.length,
            itemBuilder: (context, index) {
              final topic = state.topics[index];
              return TopicTile(
                topic: topic,
                onTap: () {
                  context.read<ContentBloc>().add(
                        ContentTopicSelected(subjectId, chapter.id, topic.id),
                      );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StudyScreen(
                        subjectId: subjectId,
                        chapterId: chapter.id,
                        topicId: topic.id,
                        topicName: topic.name,
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
