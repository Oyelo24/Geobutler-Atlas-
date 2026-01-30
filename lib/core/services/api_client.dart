import 'package:atlas_field_companion/core/services/logger_service.dart';
import 'package:geobutler_backend_client/geobutler_backend_client.dart';

class ApiClient {
  static Client? _client;
  static String? _serverUrl;
  
  static void initialize({required String serverUrl}) {
    try {
      LoggerService.info('Initializing API client with server URL: $serverUrl');
      _serverUrl = serverUrl;
      _client = Client(serverUrl);
      LoggerService.debug('API client initialized successfully');
    } catch (e) {
      LoggerService.error('Failed to initialize API client', e);
      rethrow;
    }
  }
  
  static Client get instance {
    if (_client == null) {
      LoggerService.error('API client not initialized. Call initialize() first.');
      throw StateError('ApiClient not initialized. Call ApiClient.initialize() first.');
    }
    return _client!;
  }
  
  static String? get serverUrl => _serverUrl;
  
  static bool get isInitialized => _client != null;
}