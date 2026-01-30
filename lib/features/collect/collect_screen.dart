import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/app_state_provider.dart';
import '../../shared/widgets/app_header.dart';
import '../../core/theme/app_theme.dart';

class CollectScreen extends ConsumerStatefulWidget {
  const CollectScreen({super.key});

  @override
  ConsumerState<CollectScreen> createState() => _CollectScreenState();
}

class _CollectScreenState extends ConsumerState<CollectScreen> {
  final _pointIdController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  Position? _currentPosition;
  bool _isLoading = false;
  String? _error;
  bool _isWatching = false;

  @override
  void initState() {
    super.initState();
    _updatePointId();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _pointIdController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updatePointId() {
    if (!mounted) return;
    
    final state = ref.read(appStateProvider);
    if (state.activeProject != null) {
      final nextNum = state.points
          .where((p) => p.projectId == state.activeProject!.id)
          .length + 1;
      _pointIdController.text = 'P${nextNum.toString().padLeft(3, '0')}';
    }
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied, we cannot request permissions.';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;
      
      setState(() {
        _currentPosition = position;
        _isLoading = false;
        _isWatching = true;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  FixType _getFixType(double accuracy) {
    if (accuracy <= 3) return FixType.good;
    if (accuracy <= 8) return FixType.fair;
    return FixType.poor;
  }

  void _savePoint() async {
    final state = ref.read(appStateProvider);
    
    if (state.activeProject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No active project. Please select a project first.'),
          backgroundColor: AppTheme.destructiveColor,
        ),
      );
      return;
    }

    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No GPS position. Please wait for GPS signal.'),
          backgroundColor: AppTheme.destructiveColor,
        ),
      );
      return;
    }

    final point = SurveyPoint(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      projectId: state.activeProject!.id,
      pointId: _pointIdController.text,
      latitude: _currentPosition!.latitude,
      longitude: _currentPosition!.longitude,
      elevation: _currentPosition!.altitude ?? 0,
      accuracy: _currentPosition!.accuracy / 100, // Convert to meters
      fixType: _getFixType(_currentPosition!.accuracy),
      description: _descriptionController.text,
      timestamp: DateTime.now(),
    );

    await ref.read(appStateProvider.notifier).addPoint(point);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${point.pointId} has been recorded'),
          backgroundColor: AppTheme.successColor,
        ),
      );

      _descriptionController.clear();
      _updatePointId();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    
    return Scaffold(
      appBar: AppHeader(
        title: 'Collect Point',
        subtitle: state.activeProject?.name ?? 'No project selected',
      ),
      body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GPS Status
                  Row(
                    children: [
                      _buildGPSStatusIndicator(),
                      const Spacer(),
                      if (_currentPosition != null)
                        Text(
                          '±${_currentPosition!.accuracy.toStringAsFixed(1)}m',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.mutedColor,
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // GPS Error Message
                  if (_error != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.destructiveColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.destructiveColor.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.warning_outlined,
                            color: AppTheme.destructiveColor,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'GPS Error',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.destructiveColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _error!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.mutedColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: _getCurrentLocation,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  if (_error != null) const SizedBox(height: 16),
                  
                  // Live Coordinates Card
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: AppTheme.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.gps_fixed,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isLoading ? 'Acquiring GPS...' : 'Live Position',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: _isLoading ? null : _getCurrentLocation,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppTheme.primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation(
                                                AppTheme.primaryColor,
                                              ),
                                            ),
                                          )
                                        : const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.navigation, size: 16),
                                              SizedBox(width: 4),
                                              Text('Locate'),
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 16),
                              
                              _buildCoordinateRow(
                                'LATITUDE',
                                _currentPosition?.latitude.toStringAsFixed(6) ?? '—',
                              ),
                              const SizedBox(height: 12),
                              _buildCoordinateRow(
                                'LONGITUDE',
                                _currentPosition?.longitude.toStringAsFixed(6) ?? '—',
                              ),
                              const SizedBox(height: 12),
                              _buildCoordinateRow(
                                'ELEVATION',
                                _currentPosition?.altitude != null
                                    ? '${_currentPosition!.altitude!.toStringAsFixed(2)} m'
                                    : '—',
                              ),
                            ],
                          ),
                        ),
                        
                        // Accuracy Indicator
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: AppTheme.cardColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Survey Accuracy',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.mutedColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _currentPosition != null
                                          ? '${(_currentPosition!.accuracy / 10).toStringAsFixed(1)} cm'
                                          : '—',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_currentPosition != null)
                                _buildFixTypeIndicator(_getFixType(_currentPosition!.accuracy)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Point Details
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
                        const Text(
                          'Point ID',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _pointIdController,
                          style: const TextStyle(fontFamily: 'monospace'),
                          decoration: InputDecoration(
                            hintText: 'P001',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppTheme.borderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppTheme.borderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppTheme.primaryColor),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        const Text(
                          'Description / Notes',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Corner marker, iron rod...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppTheme.borderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppTheme.borderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppTheme.primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Add photo functionality
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.secondaryColor,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, size: 20),
                              SizedBox(width: 8),
                              Text('Add Photo'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _currentPosition != null ? _savePoint : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.successColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save, size: 20),
                              SizedBox(width: 8),
                              Text('Save Point'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildGPSStatusIndicator() {
    Color color;
    IconData icon;
    String label;

    if (_isLoading) {
      color = AppTheme.mutedColor;
      icon = Icons.gps_not_fixed;
      label = 'Acquiring GPS...';
    } else if (_error != null) {
      color = AppTheme.destructiveColor;
      icon = Icons.gps_off;
      label = 'GPS Error';
    } else if (_currentPosition != null) {
      if (_currentPosition!.accuracy <= 5) {
        color = AppTheme.successColor;
        icon = Icons.gps_fixed;
        label = 'Excellent';
      } else if (_currentPosition!.accuracy <= 15) {
        color = AppTheme.successColor;
        icon = Icons.gps_fixed;
        label = 'Good';
      } else if (_currentPosition!.accuracy <= 30) {
        color = AppTheme.warningColor;
        icon = Icons.gps_not_fixed;
        label = 'Fair';
      } else {
        color = AppTheme.destructiveColor;
        icon = Icons.gps_not_fixed;
        label = 'Poor';
      }
    } else {
      color = AppTheme.mutedColor;
      icon = Icons.gps_off;
      label = 'GPS Off';
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildCoordinateRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildFixTypeIndicator(FixType fixType) {
    Color color;
    String label;

    switch (fixType) {
      case FixType.good:
        color = AppTheme.successColor;
        label = 'Good Fix';
        break;
      case FixType.fair:
        color = AppTheme.warningColor;
        label = 'Fair Fix';
        break;
      case FixType.poor:
        color = AppTheme.destructiveColor;
        label = 'Poor Fix';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}