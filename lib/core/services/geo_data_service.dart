import 'package:geobutler_backend_client/geobutler_backend_client.dart';
import '../services/api_client.dart';
import '../services/logger_service.dart';

class GeoDataService {
  static Future<GeoPoint> addPoint(GeoPoint point) async {
    try {
      LoggerService.info('Adding geo point: ${point.pointId}');
      final result = await ApiClient.instance.geoData.addPoint(point);
      LoggerService.debug('Point added successfully');
      return result;
    } catch (e) {
      LoggerService.error('Failed to add point: $e');
      rethrow;
    }
  }

  static Future<List<GeoPoint>> getPointsByProject(int projectId) async {
    try {
      LoggerService.info('Fetching points for project: $projectId');
      final result = await ApiClient.instance.geoData.getPointsByProject(projectId);
      LoggerService.debug('Retrieved ${result.length} points');
      return result;
    } catch (e) {
      LoggerService.error('Failed to get points: $e');
      return [];
    }
  }

  static Future<GeoPoint> updatePoint(GeoPoint point) async {
    try {
      LoggerService.info('Updating point: ${point.pointId}');
      final result = await ApiClient.instance.geoData.updatePoint(point);
      LoggerService.debug('Point updated successfully');
      return result;
    } catch (e) {
      LoggerService.error('Failed to update point: $e');
      rethrow;
    }
  }

  static Future<void> deletePoint(int pointId) async {
    try {
      LoggerService.info('Deleting point: $pointId');
      await ApiClient.instance.geoData.deletePoint(pointId);
      LoggerService.debug('Point deleted successfully');
    } catch (e) {
      LoggerService.error('Failed to delete point: $e');
      rethrow;
    }
  }

  static Future<GeoBoundary> addBoundary(GeoBoundary boundary) async {
    try {
      LoggerService.info('Adding boundary');
      final result = await ApiClient.instance.geoData.addBoundary(boundary);
      LoggerService.debug('Boundary added successfully');
      return result;
    } catch (e) {
      LoggerService.error('Failed to add boundary: $e');
      rethrow;
    }
  }

  static Future<List<GeoBoundary>> getBoundariesByProject(int projectId) async {
    try {
      LoggerService.info('Fetching boundaries for project: $projectId');
      final result = await ApiClient.instance.geoData.getBoundariesByProject(projectId);
      LoggerService.debug('Retrieved ${result.length} boundaries');
      return result;
    } catch (e) {
      LoggerService.error('Failed to get boundaries: $e');
      return [];
    }
  }

  static Future<String> exportProjectData(int projectId, String format) async {
    try {
      LoggerService.info('Exporting project data: $projectId as $format');
      final result = await ApiClient.instance.geoData.exportProjectData(projectId, format);
      LoggerService.debug('Data exported successfully');
      return result;
    } catch (e) {
      LoggerService.error('Failed to export data: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getProjectGeoData(int projectId) async {
    try {
      LoggerService.info('Fetching geo data for project: $projectId');
      final result = await ApiClient.instance.geoData.getProjectGeoData(projectId);
      LoggerService.debug('Geo data retrieved successfully');
      return result;
    } catch (e) {
      LoggerService.error('Failed to get geo data: $e');
      return {};
    }
  }
}