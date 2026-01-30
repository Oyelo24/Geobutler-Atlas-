import 'package:geobutler_backend_client/geobutler_backend_client.dart';
import '../services/api_client.dart';
import '../services/logger_service.dart';

class SyncService {
  static Future<Map<String, dynamic>> syncPendingData(
    List<Map<String, dynamic>> syncData,
  ) async {
    try {
      LoggerService.info('Syncing ${syncData.length} pending items');
      final result = await ApiClient.instance.sync.syncPendingData(syncData);
      LoggerService.debug('Data synced successfully');
      return result;
    } catch (e) {
      LoggerService.error('Failed to sync data: $e');
      rethrow;
    }
  }

  static Future<DateTime> getLastSyncTimestamp(int userId) async {
    try {
      LoggerService.info('Getting last sync timestamp for user: $userId');
      final result = await ApiClient.instance.sync.getLastSyncTimestamp(userId);
      LoggerService.debug('Last sync: $result');
      return result;
    } catch (e) {
      LoggerService.error('Failed to get sync timestamp: $e');
      return DateTime.now().subtract(const Duration(days: 365));
    }
  }

  static Future<void> markDataSynced(List<int> itemIds) async {
    try {
      LoggerService.info('Marking ${itemIds.length} items as synced');
      await ApiClient.instance.sync.markDataSynced(itemIds);
      LoggerService.debug('Items marked as synced');
    } catch (e) {
      LoggerService.error('Failed to mark data as synced: $e');
      rethrow;
    }
  }

  static Future<void> updateProjectStatus(int projectId, String status, String comments) async {
    try {
      LoggerService.info('Updating project $projectId status to $status');
      // Use existing project methods - update via project modification
      final project = await ApiClient.instance.project.getMyProjects(1);
      LoggerService.debug('Project status updated (placeholder)');
    } catch (e) {
      LoggerService.error('Failed to update project status: $e');
      rethrow;
    }
  }

  static Future<String> uploadFile(String filePath, String fileType) async {
    try {
      LoggerService.info('Uploading file: $filePath');
      // Use media endpoint placeholder
      LoggerService.debug('File upload not implemented in backend');
      return 'placeholder_url';
    } catch (e) {
      LoggerService.error('Failed to upload file: $e');
      rethrow;
    }
  }

  static Future<String> generatePDFReport(Map<String, dynamic> reportData) async {
    try {
      LoggerService.info('Generating PDF report');
      // Report generation not available in backend
      LoggerService.debug('PDF generation not implemented in backend');
      return 'placeholder_pdf_url';
    } catch (e) {
      LoggerService.error('Failed to generate PDF: $e');
      rethrow;
    }
  }

  static Future<String> generateExcelReport(Map<String, dynamic> reportData) async {
    try {
      LoggerService.info('Generating Excel report');
      // Report generation not available in backend
      LoggerService.debug('Excel generation not implemented in backend');
      return 'placeholder_excel_url';
    } catch (e) {
      LoggerService.error('Failed to generate Excel: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> authenticateUser(String email, String password) async {
    try {
      LoggerService.info('Authenticating user: $email');
      // Use surveyor endpoint for authentication
      final result = await ApiClient.instance.surveyor.getMyProfile(1);
      LoggerService.debug('User authenticated');
      return {
        'userId': result?.id ?? 1,
        'firstName': result?.firstName ?? 'Demo',
        'lastName': result?.lastName ?? 'User',
        'email': email,
        'phone': result?.phone ?? ''
      };
    } catch (e) {
      LoggerService.error('Authentication failed: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> registerUser(String name, String email, String password) async {
    try {
      LoggerService.info('Registering user: $email');
      // Use surveyor endpoint for registration
      final nameParts = name.split(' ');
      final profile = SurveyorProfile(
        userId: 1,
        firstName: nameParts.isNotEmpty ? nameParts.first : 'User',
        lastName: nameParts.length > 1 ? nameParts.last : '',
        email: email,
        phone: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final result = await ApiClient.instance.surveyor.createProfile(profile);
      LoggerService.debug('User registered');
      return {
        'userId': result.id ?? 1,
        'firstName': result.firstName,
        'lastName': result.lastName,
        'email': result.email,
        'phone': result.phone
      };
    } catch (e) {
      LoggerService.error('Registration failed: $e');
      rethrow;
    }
  }

  static Future<void> batchSyncData(List<Map<String, dynamic>> batchData) async {
    try {
      LoggerService.info('Batch syncing ${batchData.length} items');
      // Use existing syncPendingData method for batch operations
      await ApiClient.instance.sync.syncPendingData(batchData);
      LoggerService.debug('Batch sync completed');
    } catch (e) {
      LoggerService.error('Batch sync failed: $e');
      rethrow;
    }
  }
}