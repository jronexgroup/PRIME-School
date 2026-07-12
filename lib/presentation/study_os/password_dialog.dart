import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/study_os/study_mode_auth_service.dart';

class PasswordSetupDialog extends StatefulWidget {
  final StudyModeAuthService auth;
  final VoidCallback onComplete;
  const PasswordSetupDialog({super.key, required this.auth, required this.onComplete});

  @override
  State<PasswordSetupDialog> createState() => _PasswordSetupDialogState();
}

class _PasswordSetupDialogState extends State<PasswordSetupDialog> {
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  String _error = '';
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final pw = _passwordCtrl.text;
    if (pw.length < 8) {
      setState(() => _error = 'Password must be at least 8 characters');
      return;
    }
    if (pw != _confirmCtrl.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }
    try {
      await widget.auth.setPassword(pw);
      widget.onComplete();
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AlertDialog(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Set Study Mode Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Create a password (min 8 characters) to secure Study Mode.',
              style: TextStyle(fontSize: 13, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordCtrl,
            obscureText: _obscure1,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              suffixIcon: IconButton(
                icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility, size: 18),
                onPressed: () => setState(() => _obscure1 = !_obscure1),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirmCtrl,
            obscureText: _obscure2,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              suffixIcon: IconButton(
                icon: Icon(_obscure2 ? Icons.visibility_off : Icons.visibility, size: 18),
                onPressed: () => setState(() => _obscure2 = !_obscure2),
              ),
            ),
          ),
          if (_error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_error, style: const TextStyle(color: AppColors.error, fontSize: 12)),
            ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.studyOs,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Save Password'),
        ),
      ],
    );
  }
}

class PasswordVerifyDialog extends StatefulWidget {
  final StudyModeAuthService auth;
  final String title;
  final String message;
  final VoidCallback onVerified;
  const PasswordVerifyDialog({
    super.key,
    required this.auth,
    this.title = 'Enter Password',
    this.message = 'Enter your Study Mode password to continue.',
    required this.onVerified,
  });

  @override
  State<PasswordVerifyDialog> createState() => _PasswordVerifyDialogState();
}

class _PasswordVerifyDialogState extends State<PasswordVerifyDialog> {
  final _passwordCtrl = TextEditingController();
  String _error = '';
  bool _obscure = true;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final ok = await widget.auth.verifyPassword(_passwordCtrl.text);
    if (ok && mounted) {
      widget.onVerified();
    } else if (mounted) {
      setState(() => _error = 'Incorrect password');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AlertDialog(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.message,
              style: TextStyle(fontSize: 13, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordCtrl,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: 'Password',
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
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _verify,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.studyOs,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
