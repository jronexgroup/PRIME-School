import 'package:dio/dio.dart';

class PythonExecutorService {
  final Dio _dio = Dio();

  Future<String> executeCode(String code) async {
    try {
      final response = await _dio.post(
        'https://emkc.org/api/v2/piston/execute',
        data: {
          'language': 'python',
          'version': '3.10.0',
          'files': [
            {'content': code}
          ],
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 15),
        ),
      );
      final run = response.data['run'];
      final stdout = run['stdout'] as String? ?? '';
      final stderr = run['stderr'] as String? ?? '';
      final codeOut = run['code'] as int? ?? 0;
      if (stdout.isNotEmpty) return stdout;
      if (stderr.isNotEmpty) return 'Error:\n$stderr';
      return 'Exit code: $codeOut (no output)';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
