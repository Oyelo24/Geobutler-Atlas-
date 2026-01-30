import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/app_state_provider.dart';
import '../../shared/providers/map_settings_provider.dart';
import '../../shared/widgets/app_header.dart';
import '../../core/theme/app_theme.dart';
import 'map_settings_panel.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            15.0,
          ),
        );
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _centerOnUser() {
    if (_currentPosition != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          16.0,
        ),
      );
    }
  }

  void _updateMarkers() {
    final state = ref.read(appStateProvider);
    final mapSettings = ref.read(mapSettingsProvider);
    final markers = <Marker>{};

    // Current location marker
    if (mapSettings.showCurrentLocation && _currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Current Location'),
        ),
      );
    }

    // Survey points markers
    if (mapSettings.showSurveyPoints) {
      for (final point in state.points) {
        markers.add(
          Marker(
            markerId: MarkerId(point.id),
            position: LatLng(point.latitude, point.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerHue(point.fixType)),
            infoWindow: InfoWindow(
              title: point.pointId,
              snippet: 'Accuracy: ${point.accuracy.toStringAsFixed(1)}m',
            ),
            onTap: () => _showPointDetails(point),
          ),
        );
      }
    }

    setState(() {
      _markers = markers;
    });
  }

  double _getMarkerHue(FixType fixType) {
    switch (fixType) {
      case FixType.good:
        return BitmapDescriptor.hueGreen;
      case FixType.fair:
        return BitmapDescriptor.hueOrange;
      case FixType.poor:
        return BitmapDescriptor.hueRed;
    }
  }

  void _showPointDetails(SurveyPoint point) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Point ${point.pointId}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Latitude: ${point.latitude.toStringAsFixed(6)}'),
            Text('Longitude: ${point.longitude.toStringAsFixed(6)}'),
            Text('Elevation: ${point.elevation.toStringAsFixed(2)}m'),
            Text('Accuracy: ${point.accuracy.toStringAsFixed(1)}m'),
            Text('Fix Type: ${point.fixType.name}'),
            if (point.description.isNotEmpty) Text('Description: ${point.description}'),
          ],
        ),
      ),
    );
  }

  void _showMapSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const MapSettingsPanel(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    final mapSettings = ref.watch(mapSettingsProvider);
    final projectPoints = state.points
        .where((p) => p.projectId == state.activeProject?.id)
        .toList();

    // Update markers when state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateMarkers();
    });

    return Scaffold(
      appBar: AppHeader(
        title: 'Map View',
        subtitle: state.activeProject?.name ?? 'Select a project',
        action: IconButton(
          onPressed: () => _showMapSettings(context),
          icon: const Icon(Icons.tune),
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _updateMarkers();
            },
            initialCameraPosition: CameraPosition(
              target: _currentPosition != null
                  ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                  : const LatLng(6.5244, 3.3792),
              zoom: mapSettings.zoom,
            ),
            markers: _markers,
            myLocationEnabled: mapSettings.showCurrentLocation,
            myLocationButtonEnabled: false,
            mapType: mapSettings.getGoogleMapType(),
            zoomControlsEnabled: false,
          ),
          
          // My Location Button
          Positioned(
            top: 16,
            right: 16,
            child: _buildMapControl(Icons.my_location, _centerOnUser),
          ),
          
          // Points Count
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${projectPoints.length}/${state.points.length} points',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControl(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        style: IconButton.styleFrom(
          padding: const EdgeInsets.all(8),
        ),
      ),
    );
  }
}