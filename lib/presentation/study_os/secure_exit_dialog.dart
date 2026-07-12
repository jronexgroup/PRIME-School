import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/study_os/study_mode_auth_service.dart';
import '../../blocs/study_os/study_os_bloc.dart';
import '../../blocs/study_os/study_os_event.dart';
import 'password_dialog.dart';

class SecureExitDialog extends StatefulWidget {
  final VoidCallback? onExit;
  final StudyModeAuthService? auth;

  const SecureExitDialog({super.key, this.onExit, this.auth});

  @override
  State<SecureExitDialog> createState() => _SecureExitDialogState();
}

class _SecureExitDialogState extends State<SecureExitDialog> {
  final _passwordCtrl = TextEditingController();
  String _error = '';
  bool _obscure = true;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _verifyAndExit() async {
    final auth = widget.auth ?? context.read<StudyModeAuthService>();
    final ok = await auth.verifyPassword(_passwordCtrl.text);
    if (ok && mounted) {
      _exitStudyMode();
    } else if (mounted) {
      setState(() => _error = 'Incorrect password');
    }
  }

  void _exitStudyMode() {
    if (widget.onExit != null) {
      widget.onExit!();
    } else {
      context.read<StudyOsBloc>().add(const StudyOsEndSession());
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_rounded, size: 48, color: AppColors.studyOs),
          const SizedBox(height: 16),
          Text('Exit Study Mode?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
          const SizedBox(height: 8),
          Text('Enter your password to exit.', style: TextStyle(fontSize: 13, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
          const SizedBox(height: 20),
          TextField(
            controller: _passwordCtrl,
            obscureText: _obscure,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Study Mode Password',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, size: 18),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          if (_error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_error, style: const TextStyle(color: AppColors.error, fontSize: 12)),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _verifyAndExit,
              icon: const Icon(Icons.lock_open_rounded, size: 20),
              label: const Text('Exit Study Mode'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.studyOs,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
