import 'package:atlas_field_companion/core/services/survey_computations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/app_state_provider.dart';
import '../../shared/widgets/app_header.dart';
import '../../core/theme/app_theme.dart';


class EnhancedCollectScreen extends ConsumerStatefulWidget {
  const EnhancedCollectScreen({super.key});

  @override
  ConsumerState<EnhancedCollectScreen> createState() => _EnhancedCollectScreenState();
}

class _EnhancedCollectScreenState extends ConsumerState<EnhancedCollectScreen> {
  final _pointIdController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _distanceController = TextEditingController();
  final _bearingController = TextEditingController();
  final _angleController = TextEditingController();
  
  Position? _currentPosition;
  bool _isCollecting = false;
  bool _isListening = false;
  String? _photoPath;
  List<Measurement> _measurements = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _currentPosition = position;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  void _collectPoint() async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location not available')),
      );
      return;
    }

    final state = ref.read(appStateProvider);
    if (state.activeProject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active project selected')),
      );
      return;
    }

    setState(() => _isCollecting = true);

    try {
      final pointId = _pointIdController.text.isEmpty 
          ? 'P${state.points.length + 1}'
          : _pointIdController.text;

      final point = SurveyPoint(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        projectId: state.activeProject!.id,
        pointId: pointId,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        elevation: _currentPosition!.altitude ?? 0.0,
        accuracy: _currentPosition!.accuracy,
        fixType: _getFixType(_currentPosition!.accuracy),
        description: _descriptionController.text,
        photoUrl: _photoPath,
        measurements: List.from(_measurements),
        timestamp: DateTime.now(),
      );

      await ref.read(appStateProvider.notifier).addPoint(point);
      
      // Auto-generate measurements to previous point
      if (state.points.isNotEmpty) {
        _generateAutoMeasurements(state.points.last, point);
      }
      
      // Check for warnings
      try {
        final warnings = SurveyComputations.detectAnomalies([...state.points, point]);
        if (warnings.isNotEmpty) {
          _showWarningsDialog(warnings);
        }
      } catch (e) {
        // Skip warnings if method not available
      }

      _clearForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Point $pointId collected successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error collecting point: $e')),
      );
    }

    setState(() => _isCollecting = false);
  }

  void _generateAutoMeasurements(SurveyPoint lastPoint, SurveyPoint currentPoint) {
    final distance = SurveyComputations.calculateDistance(
      lastPoint.latitude,
      lastPoint.longitude,
      currentPoint.latitude,
      currentPoint.longitude,
    );
    
    final bearing = SurveyComputations.calculateBearing(
      lastPoint.latitude,
      lastPoint.longitude,
      currentPoint.latitude,
      currentPoint.longitude,
    );
    
    setState(() {
      _measurements.addAll([
        Measurement(
          id: '${lastPoint.id}_${currentPoint.id}_auto_dist',
          type: MeasurementType.distance,
          value: distance,
          unit: 'm',
          fromPointId: lastPoint.pointId,
          toPointId: currentPoint.pointId,
          notes: 'Auto-computed from GPS',
          timestamp: DateTime.now(),
        ),
        Measurement(
          id: '${lastPoint.id}_${currentPoint.id}_auto_bear',
          type: MeasurementType.bearing,
          value: bearing,
          unit: '°',
          fromPointId: lastPoint.pointId,
          toPointId: currentPoint.pointId,
          notes: 'Auto-computed from GPS',
          timestamp: DateTime.now(),
        ),
      ]);
    });
  }

  void _addManualMeasurement() {
    if (_distanceController.text.isNotEmpty) {
      setState(() {
        _measurements.add(Measurement(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: MeasurementType.distance,
          value: double.parse(_distanceController.text),
          unit: 'm',
          fromPointId: null,
          toPointId: _pointIdController.text,
          notes: 'Manual measurement',
          timestamp: DateTime.now(),
        ));
      });
      _distanceController.clear();
    }
  }

  void _takePhoto() async {
    try {
      // Use actual camera/file picker when available
      // For now, indicate feature needs backend support
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Photo capture requires backend file upload service'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo error: $e')),
      );
    }
  }

  void _startVoiceNote() async {
    try {
      // Use actual speech-to-text when available
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voice notes require speech-to-text service'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Voice note error: $e')),
      );
    }
  }

  void _showWarningsDialog(List<DataWarning> warnings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Data Quality Warnings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: warnings.map((w) => ListTile(
            leading: Icon(
              w.severity == WarningSeverity.critical 
                  ? Icons.error 
                  : Icons.warning,
              color: w.severity == WarningSeverity.critical 
                  ? Colors.red 
                  : Colors.orange,
            ),
            title: Text(w.message),
            subtitle: Text(w.type.name),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  FixType _getFixType(double accuracy) {
    if (accuracy <= 3.0) return FixType.good;
    if (accuracy <= 8.0) return FixType.fair;
    return FixType.poor;
  }

  void _clearForm() {
    _pointIdController.clear();
    _descriptionController.clear();
    _distanceController.clear();
    _bearingController.clear();
    _angleController.clear();
    setState(() {
      _photoPath = null;
      _measurements.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    
    return Scaffold(
      appBar: const AppHeader(
        title: 'Enhanced Data Collection',
        subtitle: 'Smart surveying with AI assistance',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Smart GPS Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: _currentPosition != null 
                    ? LinearGradient(colors: [AppTheme.successColor, AppTheme.successColor.withOpacity(0.7)])
                    : LinearGradient(colors: [AppTheme.destructiveColor, AppTheme.destructiveColor.withOpacity(0.7)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _currentPosition != null ? Icons.gps_fixed : Icons.gps_off,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _currentPosition != null ? 'GPS LOCKED' : 'GPS SEARCHING',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      if (_currentPosition != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '±${_currentPosition!.accuracy.toStringAsFixed(1)}m',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  if (_currentPosition != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('LAT: ${_currentPosition!.latitude.toStringAsFixed(6)}', 
                                   style: const TextStyle(color: Colors.white, fontFamily: 'monospace')),
                              Text('LNG: ${_currentPosition!.longitude.toStringAsFixed(6)}', 
                                   style: const TextStyle(color: Colors.white, fontFamily: 'monospace')),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getFixType(_currentPosition!.accuracy) == FixType.good 
                                ? Colors.green 
                                : _getFixType(_currentPosition!.accuracy) == FixType.fair 
                                    ? Colors.orange 
                                    : Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getFixType(_currentPosition!.accuracy).name.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Point Information
            const Text(
              'Point Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            
            TextField(
              controller: _pointIdController,
              decoration: InputDecoration(
                labelText: 'Point ID',
                hintText: 'Auto-generated if empty',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      prefixIcon: const Icon(Icons.notes),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    IconButton(
                      onPressed: _startVoiceNote,
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening ? Colors.red : null,
                      ),
                      tooltip: 'Voice to text',
                    ),
                    IconButton(
                      onPressed: _takePhoto,
                      icon: Icon(
                        Icons.camera_alt,
                        color: _photoPath != null ? AppTheme.successColor : null,
                      ),
                      tooltip: 'Take photo',
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Smart Measurements Section
            const Text(
              'Smart Measurements',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      const Text('Auto-computed measurements', 
                                 style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _distanceController,
                          decoration: InputDecoration(
                            labelText: 'Distance (m)',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addManualMeasurement,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  
                  if (_measurements.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const Text('Measurements:', style: TextStyle(fontWeight: FontWeight.w600)),
                    ..._measurements.map((m) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            m.type == MeasurementType.distance ? Icons.straighten : Icons.explore,
                            size: 16,
                            color: AppTheme.mutedColor,
                          ),
                          const SizedBox(width: 8),
                          Text('${m.type.name}: ${m.value.toStringAsFixed(3)} ${m.unit}'),
                          if (m.notes.contains('Auto-computed')) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.auto_awesome, size: 12, color: AppTheme.primaryColor),
                          ],
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Attachments
            if (_photoPath != null || _isListening) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    if (_photoPath != null) ...[
                      const Icon(Icons.photo, color: AppTheme.successColor),
                      const SizedBox(width: 8),
                      const Text('Photo attached'),
                    ],
                    if (_isListening) ...[
                      const Icon(Icons.mic, color: Colors.red),
                      const SizedBox(width: 8),
                      const Text('Recording voice note...'),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            // Smart Collect Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isCollecting || _currentPosition == null || state.activeProject == null
                    ? null
                    : _collectPoint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isCollecting
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(width: 16),
                          Text('Processing...'),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save),
                          SizedBox(width: 8),
                          Text(
                            'Collect Smart Point',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
              ),
            ),
            
            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }
}