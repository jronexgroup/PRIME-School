import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../blocs/exam/exam_bloc.dart';
import '../../blocs/exam/exam_event.dart';
import '../../blocs/exam/exam_state.dart';
import '../../providers/theme_provider.dart';
import '../../providers/api_key_provider.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../core/constants/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(context, isDark),
            const SizedBox(height: 8),
            _buildExamModeSection(context, isDark),
            const SizedBox(height: 8),
            _buildAppearanceSection(context, isDark),
            const SizedBox(height: 8),
            _buildAiSettingsSection(context, isDark),
            const SizedBox(height: 8),
            _buildOfflineSection(isDark),
            const SizedBox(height: 8),
            _buildAboutSection(isDark),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required bool isDark,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, bool isDark) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final userName = state is Authenticated ? state.user.name : 'Supreme Prime';
        final userClass = state is Authenticated ? state.user.classLevel : 9;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text('👤', style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Class $userClass · WB Madhyamik',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExamModeSection(BuildContext context, bool isDark) {
    return BlocBuilder<ExamBloc, ExamState>(
      builder: (context, state) {
        return _buildSection(
          icon: Icons.school_rounded,
          title: 'Exam Mode',
          isDark: isDark,
          child: Column(
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Enable Exam Mode',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                value: state.isExamMode,
                onChanged: (value) {
                  context.read<ExamBloc>().add(ExamModeToggled(value));
                },
                activeThumbColor: AppColors.primary,
              ),
              if (state.isExamMode) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Exam Date',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  subtitle: Text(
                    state.examDate != null
                        ? '${state.examDate!.day}/${state.examDate!.month}/${state.examDate!.year}'
                        : 'Set exam date',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                    ),
                  ),
                  trailing: const Icon(Icons.calendar_today_rounded, size: 20),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: state.examDate ?? DateTime.now().add(const Duration(days: 30)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null && context.mounted) {
                      context.read<ExamBloc>().add(ExamDateSet(date));
                    }
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppearanceSection(BuildContext context, bool isDark) {
    return _buildSection(
      icon: Icons.palette_rounded,
      title: 'Appearance',
      isDark: isDark,
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Dark Theme',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        value: isDark,
        onChanged: (value) {
          context.read<ThemeProvider>().toggleTheme();
        },
        activeThumbColor: AppColors.primary,
      ),
    );
  }

  Widget _buildAiSettingsSection(BuildContext context, bool isDark) {
    return Consumer<ApiKeyProvider>(
      builder: (context, apiKeyProvider, child) {
        return _buildSection(
          icon: Icons.smart_toy_rounded,
          title: 'AI Settings',
          isDark: isDark,
          child: Column(
            children: [
              // Cloudflare Worker URL
              _buildApiKeyField(
                label: 'Cloudflare Worker URL',
                value: apiKeyProvider.cloudflareWorkerUrl,
                onChanged: apiKeyProvider.updateCloudflareWorkerUrl,
                isDark: isDark,
              ),
              const SizedBox(height: 12),

              // Gemini Keys
              _buildApiKeySection(
                title: 'Gemini API Keys',
                count: apiKeyProvider.geminiKeysConfigured,
                onAdd: apiKeyProvider.addGeminiKey,
                isDark: isDark,
                children: List.generate(apiKeyProvider.geminiKeys.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildApiKeyField(
                            label: 'Key ${index + 1}',
                            value: apiKeyProvider.geminiKeys[index],
                            onChanged: (v) => apiKeyProvider.updateGeminiKey(index, v),
                            isDark: isDark,
                            isPassword: true,
                          ),
                        ),
                        if (apiKeyProvider.geminiKeys.length > 1)
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, size: 18),
                            onPressed: () => apiKeyProvider.removeGeminiKey(index),
                            color: AppColors.error,
                          ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),

              // Groq Keys
              _buildApiKeySection(
                title: 'Groq API Keys',
                count: apiKeyProvider.groqKeysConfigured,
                onAdd: apiKeyProvider.addGroqKey,
                isDark: isDark,
                children: List.generate(apiKeyProvider.groqKeys.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildApiKeyField(
                            label: 'Key ${index + 1}',
                            value: apiKeyProvider.groqKeys[index],
                            onChanged: (v) => apiKeyProvider.updateGroqKey(index, v),
                            isDark: isDark,
                            isPassword: true,
                          ),
                        ),
                        if (apiKeyProvider.groqKeys.length > 1)
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, size: 18),
                            onPressed: () => apiKeyProvider.removeGroqKey(index),
                            color: AppColors.error,
                          ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),

              // Sarvam Keys
              _buildApiKeySection(
                title: 'Sarvam TTS Keys',
                count: apiKeyProvider.sarvamKeysConfigured,
                onAdd: apiKeyProvider.addSarvamKey,
                isDark: isDark,
                children: List.generate(apiKeyProvider.sarvamKeys.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildApiKeyField(
                            label: 'Key ${index + 1}',
                            value: apiKeyProvider.sarvamKeys[index],
                            onChanged: (v) => apiKeyProvider.updateSarvamKey(index, v),
                            isDark: isDark,
                            isPassword: true,
                          ),
                        ),
                        if (apiKeyProvider.sarvamKeys.length > 1)
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, size: 18),
                            onPressed: () => apiKeyProvider.removeSarvamKey(index),
                            color: AppColors.error,
                          ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),

              // Cloudflare Workers AI
              _buildApiKeyField(
                label: 'Cloudflare Account ID',
                value: apiKeyProvider.cloudflareAccountId,
                onChanged: apiKeyProvider.updateCloudflareAccountId,
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              _buildApiKeyField(
                label: 'Cloudflare API Token',
                value: apiKeyProvider.cloudflareApiToken,
                onChanged: apiKeyProvider.updateCloudflareApiToken,
                isDark: isDark,
                isPassword: true,
              ),
              const SizedBox(height: 16),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: apiKeyProvider.isLoading
                      ? null
                      : () async {
                          final authState = context.read<AuthBloc>().state;
                          if (authState is Authenticated) {
                            try {
                              await apiKeyProvider.saveKeys(authState.user.uid);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('API keys saved successfully'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          }
                        },
                  child: apiKeyProvider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Save API Keys'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildApiKeySection({
    required String title,
    required int count,
    required VoidCallback onAdd,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onAdd,
              child: Icon(
                Icons.add_circle_outline,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildApiKeyField({
    required String label,
    required String value,
    required Function(String) onChanged,
    required bool isDark,
    bool isPassword = false,
  }) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      obscureText: isPassword,
      style: TextStyle(
        fontSize: 13,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(
          fontSize: 12,
          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        filled: true,
        fillColor: isDark ? AppColors.surfaceDark : AppColors.dividerLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1),
        ),
      ),
    );
  }

  Widget _buildOfflineSection(bool isDark) {
    return _buildSection(
      icon: Icons.wifi_off_rounded,
      title: 'Offline Mode',
      isDark: isDark,
      child: Column(
        children: [
          _buildInfoRow('Downloaded Topics', '0', isDark),
          const SizedBox(height: 8),
          _buildInfoRow('Storage Used', '0 MB', isDark),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {},
            child: const Text('Clear Cache'),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(bool isDark) {
    return _buildSection(
      icon: Icons.info_outline_rounded,
      title: 'About',
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRIME School v1.0.0',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Part of PRIME / JroNex Ecosystem',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}
