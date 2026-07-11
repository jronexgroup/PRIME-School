import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/study_os/ai_hub_service.dart';

class AiHubScreen extends StatefulWidget {
  const AiHubScreen({super.key});

  @override
  State<AiHubScreen> createState() => _AiHubScreenState();
}

class _AiHubScreenState extends State<AiHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: AiHubTab.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Hub', style: TextStyle(fontSize: 16)),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.studyOs,
          labelColor: AppColors.studyOs,
          unselectedLabelColor: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
          tabs: AiHubTab.values.map((tab) => Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(AiHubService.tabIcons[tab], size: 16),
                const SizedBox(width: 6),
                Text(AiHubService.tabNames[tab]!, style: const TextStyle(fontSize: 12)),
              ],
            ),
          )).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: AiHubTab.values.map((tab) => _buildTabContent(tab, isDark)).toList(),
      ),
    );
  }

  Widget _buildTabContent(AiHubTab tab, bool isDark) {
    if (tab == AiHubTab.courses) {
      return _buildCoursesHub(isDark);
    }

    final url = AiHubService.tabUrls[tab]!;
    return _buildWebViewPlaceholder(tab, url, isDark);
  }

  Widget _buildCoursesHub(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_rounded, size: 48, color: AppColors.studyOs.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text('Courses & Study Materials', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
          const SizedBox(height: 8),
          Text('Access your enrolled courses here.\nStudy OS keeps you focused on learning.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _QuickLinkCard(isDark: isDark, icon: Icons.code_rounded, label: 'Python', color: AppColors.tech),
              _QuickLinkCard(isDark: isDark, icon: Icons.history_rounded, label: 'History', color: AppColors.school),
              _QuickLinkCard(isDark: isDark, icon: Icons.science_rounded, label: 'Science', color: AppColors.success),
              _QuickLinkCard(isDark: isDark, icon: Icons.calculate_rounded, label: 'Math', color: AppColors.accent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWebViewPlaceholder(AiHubTab tab, String url, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: isDark ? AppColors.cardDark : AppColors.dividerLight,
          child: Row(
            children: [
              Icon(Icons.lock_rounded, size: 12, color: AppColors.success),
              const SizedBox(width: 6),
              Expanded(
                child: Text(url, style: TextStyle(fontSize: 10, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
              ),
              Icon(Icons.open_in_new_rounded, size: 14, color: AppColors.studyOs),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(AiHubService.tabIcons[tab], size: 48, color: AppColors.studyOs.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                Text(AiHubService.tabNames[tab]!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'This tab opens $url in a secure WebView. '
                    'Install webview_flutter to enable live browsing.\n\n'
                    'For now, tap the button below to open in your browser.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () {
                    // Would use url_launcher or webview_flutter
                  },
                  icon: const Icon(Icons.open_in_browser_rounded, size: 16),
                  label: const Text('Open in Browser'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.studyOs),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String label;
  final Color color;

  const _QuickLinkCard({required this.isDark, required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}
