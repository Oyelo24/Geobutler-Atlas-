import 'package:geobutler_backend_client/geobutler_backend_client.dart';
import '../services/api_client.dart';
import '../services/logger_service.dart';

class TaskService {
  static Future<Task> createTask(Task task) async {
    try {
      LoggerService.info('Creating task: ${task.title}');
      final result = await ApiClient.instance.tasks.createTask(task);
      LoggerService.debug('Task created successfully with ID: ${result.id}');
      return result;
    } catch (e) {
      LoggerService.error('Failed to create task: $e');
      rethrow;
    }
  }

  static Future<List<Task>> getTasksByProject(int projectId) async {
    try {
      LoggerService.info('Fetching tasks for project: $projectId');
      final result = await ApiClient.instance.tasks.getTasksByProject(projectId);
      LoggerService.debug('Retrieved ${result.length} tasks');
      return result;
    } catch (e) {
      LoggerService.error('Failed to get tasks: $e');
      return [];
    }
  }

  static Future<Task> updateTaskStatus(int taskId, String status) async {
    try {
      LoggerService.info('Updating task status: $taskId to $status');
      final result = await ApiClient.instance.tasks.updateTaskStatus(taskId, status);
      LoggerService.debug('Task status updated');
      return result;
    } catch (e) {
      LoggerService.error('Failed to update task status: $e');
      rethrow;
    }
  }

  static Future<Task> assignTask(int taskId, int assigneeId) async {
    try {
      LoggerService.info('Assigning task: $taskId to user: $assigneeId');
      final result = await ApiClient.instance.tasks.assignTask(taskId, assigneeId);
      LoggerService.debug('Task assigned successfully');
      return result;
    } catch (e) {
      LoggerService.error('Failed to assign task: $e');
      rethrow;
    }
  }
}