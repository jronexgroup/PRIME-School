import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/study_os/ocr_service.dart';

class OcrScannerScreen extends StatefulWidget {
  const OcrScannerScreen({super.key});

  @override
  State<OcrScannerScreen> createState() => _OcrScannerScreenState();
}

class _OcrScannerScreenState extends State<OcrScannerScreen> {
  final _ocrService = OcrService();
  String? _extractedText;
  bool _processing = false;
  String? _imagePath;

  Future<void> _scanFromCamera() async {
    setState(() {
      _processing = true;
      _extractedText = null;
    });
    final text = await _ocrService.pickAndRecognizeText();
    if (mounted) setState(() {
      _extractedText = text;
      _processing = false;
    });
  }

  Future<void> _scanFromGallery() async {
    setState(() {
      _processing = true;
      _extractedText = null;
    });
    final text = await _ocrService.pickFromGallery();
    if (mounted) setState(() {
      _extractedText = text;
      _processing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('OCR Scanner', style: TextStyle(fontSize: 16))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.studyOs.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.studyOs.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 18, color: AppColors.studyOs),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Take a photo of a book page to extract text. '
                      'Works best with clear, well-lit images.',
                      style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action buttons
            Row(children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  color: AppColors.primary,
                  onTap: _scanFromCamera,
                  disabled: _processing,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  color: AppColors.accent,
                  onTap: _scanFromGallery,
                  disabled: _processing,
                ),
              ),
            ]),
            const SizedBox(height: 20),

            // Processing indicator
            if (_processing)
              const Column(children: [
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text('Processing image...', style: TextStyle(fontSize: 13)),
              ]),

            // Extracted text
            if (_extractedText != null) ...[
              Row(children: [
                Icon(Icons.text_snippet_rounded, size: 16, color: AppColors.success),
                const SizedBox(width: 6),
                Text('Extracted Text', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.success)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  onPressed: () {},
                  tooltip: 'Copy to clipboard',
                ),
              ]),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      _extractedText!.startsWith('Error:') || _extractedText!.startsWith('[OCR')
                          ? _extractedText!
                          : _extractedText!,
                      style: TextStyle(fontSize: 13, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight, height: 1.6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => _SaveOcrNote(text: _extractedText!),
                    ));
                  },
                  icon: const Icon(Icons.note_add_rounded, size: 18),
                  label: const Text('Save as Note'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.studyOs,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],

            if (_extractedText == null && !_processing)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.document_scanner_rounded, size: 64, color: AppColors.studyOs.withValues(alpha: 0.3)),
                      const SizedBox(height: 12),
                      Text('Capture a page to get started', style: TextStyle(fontSize: 14, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool disabled;

  const _ActionButton({required this.icon, required this.label, required this.color, required this.onTap, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: color.withValues(alpha: disabled ? 0.05 : 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: disabled ? 0.1 : 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: disabled ? color.withValues(alpha: 0.5) : color),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: disabled ? color.withValues(alpha: 0.5) : color)),
          ],
        ),
      ),
    );
  }
}

class _SaveOcrNote extends StatelessWidget {
  final String text;
  const _SaveOcrNote({required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Save OCR Note', style: TextStyle(fontSize: 16))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(text, style: const TextStyle(fontSize: 13, height: 1.6)),
      ),
    );
  }
}
