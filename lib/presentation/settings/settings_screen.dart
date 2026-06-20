import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(context, isDark),
            const Divider(),
            _buildExamModeSection(context, isDark),
            const Divider(),
            _buildNotificationSection(isDark),
            const Divider(),
            _buildAppearanceSection(context, isDark),
            const Divider(),
            _buildAiSettingsSection(context, isDark),
            const Divider(),
            _buildOfflineSection(isDark),
            const Divider(),
            _buildAboutSection(isDark),
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

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: const Icon(Icons.person_rounded, color: AppColors.primary),
          ),
          title: Text(
            userName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          subtitle: Text(
            'Class $userClass · WB Madhyamik',
            style: TextStyle(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        );
      },
    );
  }

  Widget _buildExamModeSection(BuildContext context, bool isDark) {
    return BlocBuilder<ExamBloc, ExamState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.school_rounded,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Exam Mode',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: state.isExamMode,
                    onChanged: (value) {
                      context.read<ExamBloc>().add(ExamModeToggled(value));
                    },
                    activeThumbColor: AppColors.primary,
                  ),
                ],
              ),
              if (state.isExamMode) ...[
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Exam Date',
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  subtitle: Text(
                    state.examDate != null
                        ? '${state.examDate!.day}/${state.examDate!.month}/${state.examDate!.year}'
                        : 'Set exam date',
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  trailing: const Icon(Icons.calendar_today_rounded),
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

  Widget _buildNotificationSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_rounded,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              const SizedBox(width: 12),
              Text(
                'Notifications & Routine',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Smart Reminders',
              style: TextStyle(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            value: true,
            onChanged: (value) {},
            activeThumbColor: AppColors.primary,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Exam Countdown',
              style: TextStyle(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            value: true,
            onChanged: (value) {},
            activeThumbColor: AppColors.primary,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Achievement Alerts',
              style: TextStyle(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            value: true,
            onChanged: (value) {},
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.palette_rounded,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              const SizedBox(width: 12),
              Text(
                'Appearance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Dark Theme',
              style: TextStyle(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            value: isDark,
            onChanged: (value) {
              context.read<ThemeProvider>().toggleTheme();
            },
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildAiSettingsSection(BuildContext context, bool isDark) {
    return Consumer<ApiKeyProvider>(
      builder: (context, apiKeyProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.smart_toy_rounded,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AI Settings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const Spacer(),
                  if (apiKeyProvider.isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Cloudflare Worker URL
              _buildApiKeySection(
                title: 'Cloudflare Worker URL',
                icon: Icons.cloud_rounded,
                isDark: isDark,
                child: _buildTextField(
                  value: apiKeyProvider.cloudflareWorkerUrl,
                  onChanged: apiKeyProvider.updateCloudflareWorkerUrl,
                  hint: 'https://your-worker.workers.dev',
                  isDark: isDark,
                ),
              ),
              const SizedBox(height: 16),

              // Gemini API Keys
              _buildApiKeySection(
                title: 'Gemini API Keys',
                subtitle: '${apiKeyProvider.geminiKeysConfigured} keys configured',
                icon: Icons.auto_awesome_rounded,
                isDark: isDark,
                trailing: IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  onPressed: apiKeyProvider.addGeminiKey,
                  color: AppColors.primary,
                ),
                child: Column(
                  children: List.generate(apiKeyProvider.geminiKeys.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              value: apiKeyProvider.geminiKeys[index],
                              onChanged: (v) => apiKeyProvider.updateGeminiKey(index, v),
                              hint: 'Gemini Key ${index + 1}',
                              isDark: isDark,
                              isPassword: true,
                            ),
                          ),
                          if (apiKeyProvider.geminiKeys.length > 1)
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, size: 20),
                              onPressed: () => apiKeyProvider.removeGeminiKey(index),
                              color: AppColors.error,
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),

              // Groq API Keys
              _buildApiKeySection(
                title: 'Groq API Keys',
                subtitle: '${apiKeyProvider.groqKeysConfigured} keys configured',
                icon: Icons.bolt_rounded,
                isDark: isDark,
                trailing: IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  onPressed: apiKeyProvider.addGroqKey,
                  color: AppColors.primary,
                ),
                child: Column(
                  children: List.generate(apiKeyProvider.groqKeys.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              value: apiKeyProvider.groqKeys[index],
                              onChanged: (v) => apiKeyProvider.updateGroqKey(index, v),
                              hint: 'Groq Key ${index + 1}',
                              isDark: isDark,
                              isPassword: true,
                            ),
                          ),
                          if (apiKeyProvider.groqKeys.length > 1)
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, size: 20),
                              onPressed: () => apiKeyProvider.removeGroqKey(index),
                              color: AppColors.error,
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),

              // Sarvam API Keys
              _buildApiKeySection(
                title: 'Sarvam API Keys',
                subtitle: '${apiKeyProvider.sarvamKeysConfigured} keys configured',
                icon: Icons.record_voice_over_rounded,
                isDark: isDark,
                trailing: IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  onPressed: apiKeyProvider.addSarvamKey,
                  color: AppColors.primary,
                ),
                child: Column(
                  children: List.generate(apiKeyProvider.sarvamKeys.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              value: apiKeyProvider.sarvamKeys[index],
                              onChanged: (v) => apiKeyProvider.updateSarvamKey(index, v),
                              hint: 'Sarvam Key ${index + 1}',
                              isDark: isDark,
                              isPassword: true,
                            ),
                          ),
                          if (apiKeyProvider.sarvamKeys.length > 1)
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, size: 20),
                              onPressed: () => apiKeyProvider.removeSarvamKey(index),
                              color: AppColors.error,
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),

              // Cloudflare Account
              _buildApiKeySection(
                title: 'Cloudflare Workers AI',
                icon: Icons.cloud_queue_rounded,
                isDark: isDark,
                child: Column(
                  children: [
                    _buildTextField(
                      value: apiKeyProvider.cloudflareAccountId,
                      onChanged: apiKeyProvider.updateCloudflareAccountId,
                      hint: 'Account ID',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      value: apiKeyProvider.cloudflareApiToken,
                      onChanged: apiKeyProvider.updateCloudflareApiToken,
                      hint: 'API Token',
                      isDark: isDark,
                      isPassword: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // AI Response Language
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'AI Response Language',
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                trailing: DropdownButton<String>(
                  value: 'Bengali',
                  items: ['Bengali', 'Hindi', 'English'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {},
                ),
              ),

              const SizedBox(height: 16),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
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
                                    content: Text('Error saving: $e'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          }
                        },
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Save API Keys'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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
    String? subtitle,
    required IconData icon,
    required bool isDark,
    Widget? trailing,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String value,
    required Function(String) onChanged,
    required String hint,
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
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 13,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: const Icon(Icons.visibility_off_outlined, size: 18),
                onPressed: () {},
              )
            : null,
      ),
    );
  }

  Widget _buildOfflineSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.wifi_off_rounded,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              const SizedBox(width: 12),
              Text(
                'Offline Mode',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Downloaded Topics: 0',
              style: TextStyle(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Storage Used: 0 MB',
              style: TextStyle(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Clear Cache'),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              const SizedBox(width: 12),
              Text(
                'About',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'PRIME School v1.0.0',
              style: TextStyle(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            subtitle: Text(
              'Part of PRIME / JroNex Ecosystem',
              style: TextStyle(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
