class AIConfig {
  // Use your hosted Serverpod backend with Gemini API
  static const String baseUrl = 'https://geobutler.api.serverpod.space'; // Your hosted backend
  static const bool useBackendAI = true;
  
  // Fallback settings (not used when backend is available)
  static const int maxTokens = 500;
  static const double temperature = 0.7;
  static const bool enableFallback = true;
}