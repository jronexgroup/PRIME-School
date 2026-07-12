import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../blocs/study_os/study_os_bloc.dart';
import '../../blocs/study_os/study_os_event.dart';

class SecureExitDialog extends StatefulWidget {
  final VoidCallback? onExit;

  const SecureExitDialog({super.key, this.onExit});

  @override
  State<SecureExitDialog> createState() => _SecureExitDialogState();
}

class _SecureExitDialogState extends State<SecureExitDialog> {
  final _localAuth = LocalAuthentication();
  bool _isAuthenticating = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _tryBiometric();
  }

  Future<void> _tryBiometric() async {
    setState(() {
      _isAuthenticating = true;
      _error = '';
    });

    try {
      final isAvailable = await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
      if (!isAvailable) {
        setState(() {
          _isAuthenticating = false;
          _error = 'No biometric or PIN available. Use the button below to exit.';
        });
        return;
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to exit Study Mode',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );

      if (authenticated && mounted) {
        _exitStudyMode();
      } else {
        setState(() {
          _isAuthenticating = false;
          _error = 'Authentication failed. Try again.';
        });
      }
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
        _error = 'Error: $e';
      });
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
          Text('Your progress will be saved.', style: TextStyle(fontSize: 13, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
          const SizedBox(height: 20),

          if (_isAuthenticating)
            const Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text('Authenticating...', style: TextStyle(fontSize: 12)),
              ],
            )
          else ...[
            if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_error, style: const TextStyle(fontSize: 12, color: AppColors.error), textAlign: TextAlign.center),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _tryBiometric,
                icon: const Icon(Icons.fingerprint_rounded, size: 20),
                label: const Text('Authenticate & Exit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.studyOs,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: _exitStudyMode,
                icon: const Icon(Icons.exit_to_app_rounded, size: 18),
                label: const Text('Exit Without Auth'),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
              ),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(fontSize: 13)),
            ),
          ],
        ],
      ),
    );
  }
}
