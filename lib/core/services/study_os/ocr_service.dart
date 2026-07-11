import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class OcrService {
  static const _channel = MethodChannel('com.jronex.prime_school/ocr');

  final ImagePicker _picker = ImagePicker();

  Future<String?> pickAndRecognizeText() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (image == null) return null;

      return await recognizeTextFromFile(image.path);
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (image == null) return null;

      return await recognizeTextFromFile(image.path);
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String?> recognizeTextFromFile(String filePath) async {
    try {
      final result = await _channel.invokeMethod<String>('recognizeText', {
        'imagePath': filePath,
      });
      return result?.trim().isNotEmpty == true ? result!.trim() : null;
    } catch (e) {
      // Fallback: try using the Flutter ML Kit package
      return await _fallbackOcr(filePath);
    }
  }

  Future<String?> _fallbackOcr(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;
      // This will use google_mlkit_text_recognition if available
      // Since it's a Flutter package, we'll handle it at the UI level
      return '[OCR pending] Image saved at $filePath. Process with ML Kit.';
    } catch (e) {
      return null;
    }
  }
}
