import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class FocusOverlay extends StatelessWidget {
  final String? message;
  final VoidCallback? onDismiss;

  const FocusOverlay({super.key, this.message, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: Colors.black87,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.psychology_rounded, size: 48, color: AppColors.studyOs),
              const SizedBox(height: 16),
              Text(
                message ?? "It's study time.\nPlease stay focused.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Text(
                'Every minute counts toward your goals.',
                style: TextStyle(fontSize: 13, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
              ),
              if (onDismiss != null) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onDismiss,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.studyOs,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Continue Studying'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
