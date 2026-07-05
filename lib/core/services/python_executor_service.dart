import 'package:dio/dio.dart';

class PythonExecutorService {
  final Dio _dio = Dio();

  static const _primaryUrl = 'https://emkc.org/api/v2/piston/execute';
  static const _fallbackUrl = 'https://piston-api.mintlify.app/api/v2/piston/execute';

  Future<String> executeCode(String code) async {
    String? lastError;
    for (final url in [_primaryUrl, _fallbackUrl]) {
      try {
        final response = await _dio.post(
          url,
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
            headers: {'User-Agent': 'PRIME-School/1.0'},
          ),
        );
        final run = response.data['run'];
        final stdout = run['stdout'] as String? ?? '';
        final stderr = run['stderr'] as String? ?? '';
        final codeOut = run['code'] as int? ?? 0;
        if (stdout.isNotEmpty) return stdout;
        if (stderr.isNotEmpty) return 'Error:\n$stderr';
        return 'Exit code: $codeOut (no output)';
      } on DioException catch (e) {
        lastError = e.response?.statusCode == 401
            ? 'API authentication failed (401). The Piston API may require an API key.'
            : e.message;
      } catch (e) {
        lastError = e.toString();
      }
    }
    return 'Execution Error: $lastError\n\nTry the code in your local Python environment.';
  }
}
