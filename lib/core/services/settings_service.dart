import 'package:geobutler_backend_client/geobutler_backend_client.dart';
import '../services/api_client.dart';
import '../services/logger_service.dart';

class SettingsService {
  static Future<UserSettings?> getUserSettings(int userId) async {
    try {
      LoggerService.info('Fetching settings for user: $userId');
      final result = await ApiClient.instance.settings.getUserSettings(userId);
      LoggerService.debug('User settings retrieved');
      return result;
    } catch (e) {
      LoggerService.error('Failed to get user settings: $e');
      return null;
    }
  }

  static Future<UserSettings> updateUserSettings(
    int userId,
    UserSettings settings,
  ) async {
    try {
      LoggerService.info('Updating settings for user: $userId');
      final result = await ApiClient.instance.settings.updateUserSettings(userId, settings);
      LoggerService.debug('User settings updated');
      return result;
    } catch (e) {
      LoggerService.error('Failed to update user settings: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getAppConfiguration() async {
    try {
      LoggerService.info('Fetching app configuration');
      final result = await ApiClient.instance.settings.getAppConfiguration();
      LoggerService.debug('App configuration retrieved');
      return result;
    } catch (e) {
      LoggerService.error('Failed to get app configuration: $e');
      return {};
    }
  }
}