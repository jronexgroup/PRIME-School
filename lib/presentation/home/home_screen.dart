import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/content/content_bloc.dart';
import '../../blocs/content/content_event.dart';
import '../../blocs/content/content_state.dart';
import '../../blocs/exam/exam_bloc.dart';
import '../../blocs/exam/exam_state.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/school_tech_toggle.dart';
import '../widgets/subject_card.dart';
import '../subjects/subject_list_screen.dart';
import '../study_os/study_os_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  AppMode _appSideToMode(AppSide side) {
    switch (side) {
      case AppSide.school: return AppMode.school;
      case AppSide.tech: return AppMode.tech;
      case AppSide.studyOs: return AppMode.studyOs;
    }
  }

  AppSide _modeToAppSide(AppMode mode) {
    switch (mode) {
      case AppMode.school: return AppSide.school;
      case AppMode.tech: return AppSide.tech;
      case AppMode.studyOs: return AppSide.studyOs;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ContentBloc, ContentState>(
      builder: (context, contentState) {
        return BlocBuilder<ExamBloc, ExamState>(
          builder: (context, examState) {
            if (contentState.currentSide == AppSide.studyOs) {
              return const StudyOsHome();
            }
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PRIME School',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  contentState.currentSide == AppSide.school
                                      ? 'Class 9 · WB Madhyamik'
                                      : 'Coding & Technology',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? AppColors.textTertiaryDark
                                        : AppColors.textTertiaryLight,
                                  ),
                                ),
                              ],
                            ),
                            SchoolTechToggle(
                              currentMode: _appSideToMode(contentState.currentSide),
                              onToggle: (mode) {
                                final side = _modeToAppSide(mode);
                                context.read<ContentBloc>().add(
                                      ContentSideChanged(side),
                                    );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Search Bar (functional)
                        TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Search topics, chapters...',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              size: 20,
                              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear_rounded,
                                        size: 18,
                                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                width: 0.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                width: 0.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                ),
                // Exam Mode Banner
                if (examState.isExamMode && examState.daysUntilExam != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.error,
                              AppColors.error.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_rounded, color: Colors.white, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Exam Mode Active',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'মাধ্যমিক পরীক্ষা — ${examState.daysUntilExam} দিন বাকি',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                // Section Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: Text(
                      'SUBJECTS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                // Subject Grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.15,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final subjects = contentState.currentSubjects;
                        if (index >= subjects.length) return null;
                        final subject = subjects[index];
                        return SubjectCard(
                          icon: subject.icon,
                          name: subject.name,
                          totalChapters: subject.totalChapters,
                          progress: subject.progress,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SubjectListScreen(subject: subject),
                              ),
                            );
                          },
                        );
                      },
                      childCount: contentState.currentSubjects.length,
                    ),
                  ),
                ),
                // Recent Activity Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Text(
                      'RECENT ACTIVITY',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                // Recent Activity List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildRecentActivity(
                        context,
                        '📜',
                        'Russian Revolution',
                        '2h ago',
                        AppColors.primary,
                        isDark,
                      ),
                      _buildRecentActivity(
                        context,
                        '🔬',
                        'Photosynthesis',
                        '1d ago',
                        AppColors.success,
                        isDark,
                      ),
                      _buildRecentActivity(
                        context,
                        '📐',
                        'Quadratic Equations',
                        '2d ago',
                        AppColors.accent,
                        isDark,
                      ),
                    ]),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRecentActivity(
    BuildContext context,
    String icon,
    String title,
    String time,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right_rounded,
            size: 16,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
          ),
        ],
      ),
    );
  }
}
