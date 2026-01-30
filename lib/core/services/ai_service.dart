import 'package:atlas_field_companion/core/services/api_client.dart';
import 'package:atlas_field_companion/core/services/logger_service.dart';
import 'package:geobutler_backend_client/geobutler_backend_client.dart';

class AIService {
  static Client get _client => ApiClient.instance;

  /// Analyzes field data for accuracy, quality, and potential issues
  static Future<Map<String, dynamic>> analyzeFieldData({
    required int projectId,
    required String analysisType,
  }) async {
    LoggerService.info('Atlas AI: Analyzing field data for project $projectId');
    try {
      final result = await _client.atlas.analyzeFieldData(projectId, analysisType);
      LoggerService.info('Atlas AI: Analysis completed successfully');
      return {
        'analysis': result.analysis,
        'pointCount': result.pointCount,
        'boundaryCount': result.boundaryCount,
        'avgAccuracy': result.avgAccuracy,
        'qualityScore': result.qualityScore,
        'timestamp': result.timestamp,
      };
    } catch (e, stackTrace) {
      LoggerService.error('Atlas AI: Failed to analyze field data', e, stackTrace);
      return {
        'status': 'offline_analysis',
        'accuracy_summary': 'Analysis performed locally',
        'point_count': 0,
        'average_accuracy': 'Unknown',
        'warnings': [],
        'recommendations': ['Check internet connection for detailed analysis']
      };
    }
  }

  /// Gets AI-powered recommendations for survey optimization
  static Future<List<String>> getAIRecommendations(int projectId) async {
    LoggerService.info('Atlas AI: Getting recommendations for project $projectId');
    try {
      final result = await _client.atlas.getAIRecommendations(projectId);
      LoggerService.info('Atlas AI: Recommendations retrieved successfully');
      return result.map((r) => r.text).toList();
    } catch (e, stackTrace) {
      LoggerService.error('Atlas AI: Failed to get recommendations', e, stackTrace);
      return [
        'Ensure GPS accuracy is within acceptable limits (≤3m for good quality)',
        'Take multiple readings at critical survey points',
        'Avoid surveying during poor weather conditions',
        'Calibrate equipment regularly for optimal accuracy',
        'Document any obstacles or environmental factors'
      ];
    }
  }

  /// Generates comprehensive survey reports
  static Future<String> generateReport({
    required int projectId,
    required String reportType,
  }) async {
    LoggerService.info('Atlas AI: Generating $reportType report for project $projectId');
    try {
      final result = await _client.atlas.generateReport(projectId, reportType);
      LoggerService.info('Atlas AI: Report generated successfully');
      return result.content;
    } catch (e, stackTrace) {
      LoggerService.error('Atlas AI: Failed to generate report', e, stackTrace);
      return 'Report generation failed. Please check your internet connection and try again.';
    }
  }

  /// Performs real-time data quality checks
  static Future<Map<String, dynamic>> performQualityCheck({
    required int projectId,
    required List<Map<String, dynamic>> points,
  }) async {
    LoggerService.info('Atlas AI: Performing quality check for project $projectId');
    try {
      final result = await _client.atlas.analyzeFieldData(projectId, 'quality_check');
      return {
        'analysis': result.analysis,
        'pointCount': result.pointCount,
        'boundaryCount': result.boundaryCount,
        'avgAccuracy': result.avgAccuracy,
        'qualityScore': result.qualityScore,
        'timestamp': result.timestamp,
      };
    } catch (e, stackTrace) {
      LoggerService.error('Atlas AI: Quality check failed', e, stackTrace);
      return _performLocalQualityCheck(points);
    }
  }

  /// Local fallback for quality checks when offline
  static Map<String, dynamic> _performLocalQualityCheck(List<Map<String, dynamic>> points) {
    int goodPoints = 0;
    int fairPoints = 0;
    int poorPoints = 0;
    List<String> warnings = [];

    for (final point in points) {
      final accuracy = point['accuracy'] as double? ?? 999.0;
      if (accuracy <= 3.0) {
        goodPoints++;
      } else if (accuracy <= 8.0) {
        fairPoints++;
      } else {
        poorPoints++;
        warnings.add('Point ${point['pointId']} has poor accuracy: ${accuracy.toStringAsFixed(2)}m');
      }
    }

    return {
      'total_points': points.length,
      'good_points': goodPoints,
      'fair_points': fairPoints,
      'poor_points': poorPoints,
      'warnings': warnings,
      'overall_quality': poorPoints == 0 ? 'Good' : poorPoints < points.length * 0.1 ? 'Fair' : 'Poor',
      'recommendations': poorPoints > 0 ? [
        'Consider re-measuring points with poor accuracy',
        'Check GPS signal strength in problem areas',
        'Ensure clear sky view for better satellite reception'
      ] : ['Survey quality is acceptable']
    };
  }

  /// Chat with Atlas AI assistant
  static Future<String> chatWithAtlas(String message) async {
    LoggerService.info('Atlas AI: Processing chat message: $message');
    try {
      // Check if the method exists first
      final response = await _client.atlas.chat(message);
      LoggerService.info('Atlas AI: Chat response received');
      return response;
    } catch (e, stackTrace) {
      LoggerService.error('Atlas AI: Chat failed', e, stackTrace);
      
      // If method not found, return a helpful message
      if (e.toString().contains('Method not found in endpoint')) {
        return 'Atlas AI chat is currently unavailable. This feature is being updated.';
      }
      
      return 'I\'m experiencing connectivity issues. Please check your internet connection and try again.';
    }
  }
  static Future<List<Map<String, dynamic>>> detectAnomalies({
    required int projectId,
    required List<Map<String, dynamic>> points,
  }) async {
    LoggerService.info('Atlas AI: Detecting anomalies for project $projectId');
    try {
      final result = await _client.atlas.analyzeFieldData(projectId, 'anomaly_detection');
      return [];
    } catch (e, stackTrace) {
      LoggerService.error('Atlas AI: Anomaly detection failed', e, stackTrace);
      return _detectLocalAnomalies(points);
    }
  }

  /// Local anomaly detection fallback
  static List<Map<String, dynamic>> _detectLocalAnomalies(List<Map<String, dynamic>> points) {
    List<Map<String, dynamic>> anomalies = [];

    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final accuracy = point['accuracy'] as double? ?? 0.0;
      
      // Check for extremely poor accuracy
      if (accuracy > 50.0) {
        anomalies.add({
          'type': 'poor_accuracy',
          'point_id': point['pointId'],
          'severity': 'high',
          'message': 'Extremely poor GPS accuracy detected',
          'value': accuracy
        });
      }
      
      // Check for duplicate coordinates
      for (int j = i + 1; j < points.length; j++) {
        final otherPoint = points[j];
        final lat1 = point['latitude'] as double? ?? 0.0;
        final lon1 = point['longitude'] as double? ?? 0.0;
        final lat2 = otherPoint['latitude'] as double? ?? 0.0;
        final lon2 = otherPoint['longitude'] as double? ?? 0.0;
        
        if ((lat1 - lat2).abs() < 0.00001 && (lon1 - lon2).abs() < 0.00001) {
          anomalies.add({
            'type': 'duplicate_coordinates',
            'point_id': point['pointId'],
            'duplicate_id': otherPoint['pointId'],
            'severity': 'medium',
            'message': 'Potential duplicate coordinates detected'
          });
        }
      }
    }

    return anomalies;
  }
}