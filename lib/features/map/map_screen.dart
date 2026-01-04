import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/app_state_provider.dart';
import '../../shared/widgets/app_header.dart';
import '../../core/theme/app_theme.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _tokenController = TextEditingController();
  String _mapboxToken = '';
  bool _showTokenInput = true;

  @override
  void initState() {
    super.initState();
    // In a real app, you'd load this from SharedPreferences
    _mapboxToken = '';
    _showTokenInput = _mapboxToken.isEmpty;
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  void _saveToken() {
    if (_tokenController.text.startsWith('pk.')) {
      setState(() {
        _mapboxToken = _tokenController.text;
        _showTokenInput = false;
      });
      // In a real app, you'd save this to SharedPreferences
    }
  }

  Color _getMarkerColor(FixType fixType) {
    switch (fixType) {
      case FixType.good:
        return AppTheme.successColor;
      case FixType.fair:
        return AppTheme.warningColor;
      case FixType.poor:
        return AppTheme.destructiveColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    final projectPoints = state.points
        .where((p) => p.projectId == state.activeProject?.id)
        .toList();

    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            title: 'Map View',
            subtitle: state.activeProject?.name ?? 'Select a project',
          ),
          Expanded(
            child: _showTokenInput
                ? _buildTokenSetup()
                : _buildMapView(projectPoints),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenSetup() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.key,
              size: 32,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Mapbox Token Required',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter your Mapbox public token to display the map. Get one free at mapbox.com',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.mutedColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _tokenController,
            decoration: InputDecoration(
              hintText: 'pk.eyJ1IjoieW91ci...',
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
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _tokenController.text.startsWith('pk.') ? _saveToken : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save Token'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView(List<SurveyPoint> projectPoints) {
    return Stack(
      children: [
        // Map placeholder
        Container(
          color: AppTheme.mutedColor.withOpacity(0.1),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map_outlined,
                  size: 64,
                  color: AppTheme.mutedColor,
                ),
                SizedBox(height: 16),
                Text(
                  'Interactive Map',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.mutedColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Map integration requires additional setup',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.mutedColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Map Controls
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: [
              _buildMapControl(Icons.layers, () {}),
              const SizedBox(height: 8),
              _buildMapControl(Icons.my_location, () {}),
            ],
          ),
        ),
        
        // Legend
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem('Good (≤3cm)', AppTheme.successColor),
                const SizedBox(height: 8),
                _buildLegendItem('Fair (3-8cm)', AppTheme.warningColor),
                const SizedBox(height: 8),
                _buildLegendItem('Poor (>8cm)', AppTheme.destructiveColor),
              ],
            ),
          ),
        ),
        
        // Points Count
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
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
                  '${projectPoints.length} points',
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
    );
  }

  Widget _buildMapControl(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
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
        icon: Icon(
          icon,
          size: 16,
          color: AppTheme.mutedColor,
        ),
        style: IconButton.styleFrom(
          padding: const EdgeInsets.all(8),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.mutedColor,
          ),
        ),
      ],
    );
  }
}