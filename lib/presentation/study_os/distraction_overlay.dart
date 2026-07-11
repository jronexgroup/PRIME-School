import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../blocs/study_os/study_os_bloc.dart';
import '../../blocs/study_os/study_os_event.dart';

class DistractionOverlay extends StatefulWidget {
  final Widget child;
  const DistractionOverlay({super.key, required this.child});

  @override
  State<DistractionOverlay> createState() => _DistractionOverlayState();
}

class _DistractionOverlayState extends State<DistractionOverlay> with SingleTickerProviderStateMixin {
  bool _showWarning = false;
  late AnimationController _animCtrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _anim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void showDistractionWarning() {
    setState(() => _showWarning = true);
    _animCtrl.forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _animCtrl.reverse().then((_) {
          if (mounted) setState(() => _showWarning = false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        widget.child,
        if (_showWarning)
          Positioned.fill(
            child: FadeTransition(
              opacity: _anim,
              child: Container(
                color: Colors.black54,
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
                        const Text(
                          "It's study time.\nPlease stay focused.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'You can do this! Every minute counts.',
                          style: TextStyle(fontSize: 13, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            context.read<StudyOsBloc>().add(const StudyOsDistractionDetected());
                            setState(() => _showWarning = false);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.studyOs,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Get Back to Study'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
