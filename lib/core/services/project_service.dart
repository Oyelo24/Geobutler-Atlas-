import 'package:geobutler_backend_client/geobutler_backend_client.dart';
import '../services/api_client.dart';
import '../services/logger_service.dart';

class ProjectService {
  static Future<Project> createProject(Project project) async {
    try {
      LoggerService.info('Creating project: ${project.name}');
      final result = await ApiClient.instance.project.createProject(project);
      LoggerService.debug('Project created successfully with ID: ${result.id}');
      return result;
    } catch (e) {
      LoggerService.error('Failed to create project: $e');
      rethrow;
    }
  }

  static Future<List<Project>> getMyProjects(int surveyorId) async {
    try {
      LoggerService.info('Fetching projects for surveyor: $surveyorId');
      final result = await ApiClient.instance.project.getMyProjects(surveyorId);
      LoggerService.debug('Retrieved ${result.length} projects');
      return result;
    } catch (e) {
      LoggerService.error('Failed to get projects: $e');
      return [];
    }
  }

  static Future<Project?> getProjectById(int projectId) async {
    try {
      LoggerService.info('Fetching project: $projectId');
      final result = await ApiClient.instance.project.getProjectById(projectId);
      LoggerService.debug('Project retrieved successfully');
      return result;
    } catch (e) {
      LoggerService.error('Failed to get project: $e');
      return null;
    }
  }

  static Future<Project> updateProject(Project project) async {
    try {
      LoggerService.info('Updating project: ${project.id}');
      final result = await ApiClient.instance.project.updateProject(project);
      LoggerService.debug('Project updated successfully');
      return result;
    } catch (e) {
      LoggerService.error('Failed to update project: $e');
      rethrow;
    }
  }

  static Future<void> deleteProject(int projectId) async {
    try {
      LoggerService.info('Deleting project: $projectId');
      await ApiClient.instance.project.deleteProject(projectId);
      LoggerService.debug('Project deleted successfully');
    } catch (e) {
      LoggerService.error('Failed to delete project: $e');
      rethrow;
    }
  }
}