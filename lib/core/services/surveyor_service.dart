import 'package:geobutler_backend_client/geobutler_backend_client.dart';
import '../services/api_client.dart';
import '../services/logger_service.dart';

class SurveyorService {
  static Future<SurveyorProfile> createProfile(SurveyorProfile profile) async {
    try {
      LoggerService.info('Creating surveyor profile');
      final result = await ApiClient.instance.surveyor.createProfile(profile);
      LoggerService.debug('Surveyor profile created successfully');
      return result;
    } catch (e) {
      LoggerService.error('Failed to create surveyor profile: $e');
      rethrow;
    }
  }

  static Future<SurveyorProfile?> getMyProfile(int userId) async {
    try {
      LoggerService.info('Fetching profile for user: $userId');
      final result = await ApiClient.instance.surveyor.getMyProfile(userId);
      LoggerService.debug('Surveyor profile retrieved');
      return result;
    } catch (e) {
      LoggerService.error('Failed to get surveyor profile: $e');
      return null;
    }
  }

  static Future<SurveyorProfile> updateProfile(SurveyorProfile profile) async {
    try {
      LoggerService.info('Updating surveyor profile');
      final result = await ApiClient.instance.surveyor.updateProfile(profile);
      LoggerService.debug('Surveyor profile updated');
      return result;
    } catch (e) {
      LoggerService.error('Failed to update surveyor profile: $e');
      rethrow;
    }
  }
}