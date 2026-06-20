class ApiConstants {
  ApiConstants._();

  static const String cloudflareWorkerUrl = 'https://prime-school-api.jronex.workers.dev';

  static const String geminiEndpoint = '/gemini';
  static const String groqEndpoint = '/groq';
  static const String cloudflareEndpoint = '/cloudflare';
  static const String sarvamEndpoint = '/sarvam';

  static const String youtubeSearchUrl = 'https://www.youtube.com/results?search_query=';

  static const int maxRetryAttempts = 3;
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration cacheExpiry = Duration(hours: 24);
}
