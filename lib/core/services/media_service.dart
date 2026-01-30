import 'package:geobutler_backend_client/geobutler_backend_client.dart';
import '../services/api_client.dart';
import '../services/logger_service.dart';

class MediaService {
  static Future<Photo> uploadPhoto(
    int projectId,
    String? pointId,
    String filename,
    String url,
  ) async {
    try {
      LoggerService.info('Uploading photo: $filename for project: $projectId');
      final result = await ApiClient.instance.media.uploadPhoto(
        projectId,
        pointId,
        filename,
        url,
      );
      LoggerService.debug('Photo uploaded successfully with ID: ${result.id}');
      return result;
    } catch (e) {
      LoggerService.error('Failed to upload photo: $e');
      rethrow;
    }
  }

  static Future<List<Photo>> getPhotos(int projectId, [String? pointId]) async {
    try {
      LoggerService.info('Fetching photos for project: $projectId, point: $pointId');
      final result = await ApiClient.instance.media.getPhotos(projectId, pointId);
      LoggerService.debug('Retrieved ${result.length} photos');
      return result;
    } catch (e) {
      LoggerService.error('Failed to get photos: $e');
      return [];
    }
  }

  static Future<void> deletePhoto(int photoId) async {
    try {
      LoggerService.info('Deleting photo: $photoId');
      await ApiClient.instance.media.deletePhoto(photoId);
      LoggerService.debug('Photo deleted successfully');
    } catch (e) {
      LoggerService.error('Failed to delete photo: $e');
      rethrow;
    }
  }
}