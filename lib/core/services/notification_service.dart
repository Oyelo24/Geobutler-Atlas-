import 'package:geobutler_backend_client/geobutler_backend_client.dart';
import '../services/api_client.dart';
import '../services/logger_service.dart';

class NotificationService {
  static Future<Notification> sendNotification(
    int userId,
    Notification notification,
  ) async {
    try {
      LoggerService.info('Sending notification to user: $userId');
      final result = await ApiClient.instance.notification.sendNotification(
        userId,
        notification,
      );
      LoggerService.debug('Notification sent successfully');
      return result;
    } catch (e) {
      LoggerService.error('Failed to send notification: $e');
      rethrow;
    }
  }

  static Future<List<Notification>> getNotifications(int userId) async {
    try {
      LoggerService.info('Fetching notifications for user: $userId');
      final result = await ApiClient.instance.notification.getNotifications(userId);
      LoggerService.debug('Retrieved ${result.length} notifications');
      return result;
    } catch (e) {
      LoggerService.error('Failed to get notifications: $e');
      return [];
    }
  }

  static Future<Notification> markNotificationRead(int notificationId) async {
    try {
      LoggerService.info('Marking notification as read: $notificationId');
      final result = await ApiClient.instance.notification.markNotificationRead(notificationId);
      LoggerService.debug('Notification marked as read');
      return result;
    } catch (e) {
      LoggerService.error('Failed to mark notification as read: $e');
      rethrow;
    }
  }
}