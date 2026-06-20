abstract class AppException implements Exception {
  final String message;
  const AppException({this.message = ''});

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException({super.message = 'Server error'});
}

class AuthException extends AppException {
  const AuthException({super.message = 'Auth error'});
}

class CacheException extends AppException {
  const CacheException({super.message = 'Cache error'});
}

class AIProviderException extends AppException {
  const AIProviderException({super.message = 'AI provider error'});
}
