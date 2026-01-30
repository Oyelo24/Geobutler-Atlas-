import 'dart:math';
import '../../shared/models/models.dart';

class SurveyComputations {
  
  /// Calculate distance between two points using Haversine formula
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Earth radius in meters
    
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }
  
  /// Calculate bearing from point 1 to point 2
  static double calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    double dLon = _toRadians(lon2 - lon1);
    double lat1Rad = _toRadians(lat1);
    double lat2Rad = _toRadians(lat2);
    
    double y = sin(dLon) * cos(lat2Rad);
    double x = cos(lat1Rad) * sin(lat2Rad) - sin(lat1Rad) * cos(lat2Rad) * cos(dLon);
    
    double bearing = atan2(y, x);
    return _toDegrees(bearing);
  }
  
  /// Calculate closure error for a traverse
  static ClosureResult calculateClosure(List<SurveyPoint> points) {
    if (points.length < 3) {
      return ClosureResult(
        linearError: 0,
        angularError: 0,
        precision: 0,
        isAcceptable: false,
        message: 'Insufficient points for closure calculation',
      );
    }
    
    double totalEasting = 0;
    double totalNorthing = 0;
    double perimeter = 0;
    
    for (int i = 0; i < points.length; i++) {
      int nextIndex = (i + 1) % points.length;
      
      double distance = calculateDistance(
        points[i].latitude,
        points[i].longitude,
        points[nextIndex].latitude,
        points[nextIndex].longitude,
      );
      
      double bearing = calculateBearing(
        points[i].latitude,
        points[i].longitude,
        points[nextIndex].latitude,
        points[nextIndex].longitude,
      );
      
      totalEasting += distance * sin(_toRadians(bearing));
      totalNorthing += distance * cos(_toRadians(bearing));
      perimeter += distance;
    }
    
    double linearError = sqrt(totalEasting * totalEasting + totalNorthing * totalNorthing);
    double precision = perimeter > 0 ? linearError / perimeter : 0;
    
    return ClosureResult(
      linearError: linearError,
      angularError: 0,
      precision: precision,
      isAcceptable: precision < 1 / 5000,
      message: precision < 1 / 5000 
          ? 'Closure within acceptable limits'
          : 'Closure error exceeds acceptable limits',
    );
  }
  
  /// Detect anomalous readings
  static List<DataWarning> detectAnomalies(List<SurveyPoint> points) {
    List<DataWarning> warnings = [];
    
    // Check for duplicate points
    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        double distance = calculateDistance(
          points[i].latitude,
          points[i].longitude,
          points[j].latitude,
          points[j].longitude,
        );
        
        if (distance < 0.1) {
          warnings.add(DataWarning(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            type: WarningType.duplicate,
            severity: WarningSeverity.warning,
            message: 'Points ${points[i].pointId} and ${points[j].pointId} are very close (${distance.toStringAsFixed(2)}m)',
            pointId: points[i].pointId,
            timestamp: DateTime.now(),
          ));
        }
      }
    }
    
    // Check accuracy thresholds
    for (var point in points) {
      if (point.accuracy > 8.0) {
        warnings.add(DataWarning(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: WarningType.poorAccuracy,
          severity: WarningSeverity.critical,
          message: 'Point ${point.pointId} has poor accuracy: ${point.accuracy.toStringAsFixed(2)}m',
          pointId: point.pointId,
          timestamp: DateTime.now(),
        ));
      }
    }
    
    return warnings;
  }
  
  /// Generate automatic measurements between points
  static List<Measurement> generateMeasurements(List<SurveyPoint> points) {
    List<Measurement> measurements = [];
    
    for (int i = 0; i < points.length - 1; i++) {
      double distance = calculateDistance(
        points[i].latitude,
        points[i].longitude,
        points[i + 1].latitude,
        points[i + 1].longitude,
      );
      
      double bearing = calculateBearing(
        points[i].latitude,
        points[i].longitude,
        points[i + 1].latitude,
        points[i + 1].longitude,
      );
      
      measurements.addAll([
        Measurement(
          id: '${points[i].id}_${points[i + 1].id}_dist',
          type: MeasurementType.distance,
          value: distance,
          unit: 'm',
          fromPointId: points[i].pointId,
          toPointId: points[i + 1].pointId,
          notes: 'Auto-computed distance',
          timestamp: DateTime.now(),
        ),
        Measurement(
          id: '${points[i].id}_${points[i + 1].id}_bear',
          type: MeasurementType.bearing,
          value: bearing,
          unit: '°',
          fromPointId: points[i].pointId,
          toPointId: points[i + 1].pointId,
          notes: 'Auto-computed bearing',
          timestamp: DateTime.now(),
        ),
      ]);
    }
    
    return measurements;
  }
  
  static double _toRadians(double degrees) => degrees * pi / 180;
  static double _toDegrees(double radians) => radians * 180 / pi;
}

class ClosureResult {
  final double linearError;
  final double angularError;
  final double precision;
  final bool isAcceptable;
  final String message;
  
  const ClosureResult({
    required this.linearError,
    required this.angularError,
    required this.precision,
    required this.isAcceptable,
    required this.message,
  });
}