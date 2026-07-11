import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/study_os/voice_tutor_service.dart';

class VoiceTutorScreen extends StatelessWidget {
  final VoiceTutorService voiceTutorService;

  const VoiceTutorScreen({super.key, required this.voiceTutorService});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Voice Tutor', style: TextStyle(fontSize: 16))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Voice tutor avatar
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [AppColors.studyOs, AppColors.studyOs.withValues(alpha: 0.6)]),
              ),
              child: Icon(
                voiceTutorService.isSpeaking ? Icons.volume_up_rounded : Icons.record_voice_over_rounded,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text('Voice Tutor', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
            const SizedBox(height: 8),
            Text('Listen to study tips and motivation', style: TextStyle(fontSize: 13, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
            const SizedBox(height: 32),

            // Speed control
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Speed', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                const SizedBox(width: 12),
                SizedBox(
                  width: 200,
                  child: Slider(
                    value: voiceTutorService.speed,
                    min: 0.5,
                    max: 1.5,
                    divisions: 10,
                    label: '${voiceTutorService.speed.toStringAsFixed(1)}x',
                    activeColor: AppColors.studyOs,
                    onChanged: (v) => voiceTutorService.setSpeed(v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Action buttons
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _VoiceButton(icon: Icons.play_circle_rounded, label: 'Motivational Tip', color: AppColors.studyOs, onTap: () => voiceTutorService.speakMotivationalTip(), disabled: voiceTutorService.isSpeaking),
                _VoiceButton(icon: Icons.play_circle_filled_rounded, label: 'Start Session', color: AppColors.success, onTap: () => voiceTutorService.speakSessionStart(), disabled: voiceTutorService.isSpeaking),
                _VoiceButton(icon: Icons.stop_circle_rounded, label: 'Stop', color: AppColors.error, onTap: () => voiceTutorService.stop(), disabled: !voiceTutorService.isSpeaking),
              ],
            ),
            const SizedBox(height: 32),

            // Tip preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('STUDY TIPS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  ...VoiceTutorService.studyTips.take(3).map((tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle_outline_rounded, size: 14, color: AppColors.studyOs),
                        const SizedBox(width: 8),
                        Expanded(child: Text(tip, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight))),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoiceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool disabled;

  const _VoiceButton({required this.icon, required this.label, required this.color, required this.onTap, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: disabled ? 0.05 : 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: disabled ? 0.1 : 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: disabled ? color.withValues(alpha: 0.5) : color),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: disabled ? color.withValues(alpha: 0.5) : color)),
          ],
        ),
      ),
    );
  }
}
