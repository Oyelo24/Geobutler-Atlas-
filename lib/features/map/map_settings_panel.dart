import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/map_settings.dart';
import '../../shared/providers/map_settings_provider.dart';
import '../../core/theme/app_theme.dart';

class MapSettingsPanel extends ConsumerWidget {
  const MapSettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(mapSettingsProvider);
    final notifier = ref.read(mapSettingsProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.tune,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Map Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.mutedColor.withOpacity(0.1),
                    foregroundColor: AppTheme.mutedColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Settings List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // Map Style
                _buildSection('Map Style', [
                  _buildDropdown<MapStyle>(
                    'Style',
                    settings.mapStyle,
                    MapStyle.values,
                    (value) => notifier.updateMapStyle(value!),
                    (style) => style.name.toUpperCase(),
                  ),
                ]),
                
                // Zoom Controls
                _buildSection('Zoom', [
                  _buildSlider(
                    'Current Zoom',
                    settings.zoom,
                    settings.minZoom,
                    settings.maxZoom,
                    (value) => notifier.updateZoom(value),
                    context,
                  ),
                  _buildSlider(
                    'Min Zoom',
                    settings.minZoom,
                    1.0,
                    settings.maxZoom - 1,
                    (value) => notifier.updateZoomLimits(value, settings.maxZoom),
                    context,
                  ),
                  _buildSlider(
                    'Max Zoom',
                    settings.maxZoom,
                    settings.minZoom + 1,
                    22.0,
                    (value) => notifier.updateZoomLimits(settings.minZoom, value),
                    context,
                  ),
                ]),
                
                // Display Options
                _buildSection('Display', [
                  _buildSwitch('Current Location', settings.showCurrentLocation, notifier.toggleCurrentLocation),
                  _buildSwitch('Survey Points', settings.showSurveyPoints, notifier.toggleSurveyPoints),
                  _buildSwitch('Point Labels', settings.showPointLabels, notifier.togglePointLabels),
                  _buildSwitch('Accuracy Circles', settings.showAccuracyCircles, notifier.toggleAccuracyCircles),
                  _buildSwitch('Grid Lines', settings.showGrid, notifier.toggleGrid),
                  _buildSwitch('Scale Bar', settings.showScale, notifier.toggleScale),
                  _buildSwitch('Compass', settings.showCompass, notifier.toggleCompass),
                ]),
                
                // Marker Settings
                _buildSection('Markers', [
                  _buildDropdown<MarkerStyle>(
                    'Marker Style',
                    settings.markerStyle,
                    MarkerStyle.values,
                    (value) => notifier.updateMarkerStyle(value!),
                    (style) => style.name.toUpperCase(),
                  ),
                  _buildSlider(
                    'Marker Size',
                    settings.markerSize,
                    12.0,
                    48.0,
                    (value) => notifier.updateMarkerSize(value),
                    context,
                  ),
                ]),
                
                // Advanced Options
                _buildSection('Advanced', [
                  _buildSlider(
                    'Map Opacity',
                    settings.opacity,
                    0.3,
                    1.0,
                    (value) => notifier.updateOpacity(value),
                    context,
                  ),
                  _buildSwitch('Cluster Points', settings.clusteredPoints, notifier.toggleClustering),
                  _buildSwitch('Show Trails', settings.showTrails, notifier.toggleTrails),
                  _buildSwitch('Night Mode', settings.nightMode, notifier.toggleNightMode),
                ]),
                
                // Reset Button
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.destructiveColor, AppTheme.destructiveColor.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: notifier.resetToDefaults,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.refresh, size: 20),
                        const SizedBox(width: 8),
                        const Text('Reset to Defaults', style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitch(String label, bool value, VoidCallback onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: (_) => onChanged(),
            activeColor: AppTheme.primaryColor,
            activeTrackColor: AppTheme.primaryColor.withOpacity(0.3),
            inactiveThumbColor: AppTheme.mutedColor,
            inactiveTrackColor: AppTheme.mutedColor.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, ValueChanged<double> onChanged, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.primaryColor,
              inactiveTrackColor: AppTheme.primaryColor.withOpacity(0.2),
              thumbColor: AppTheme.primaryColor,
              overlayColor: AppTheme.primaryColor.withOpacity(0.1),
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: ((max - min) * 2).round(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>(
    String label,
    T value,
    List<T> items,
    ValueChanged<T?> onChanged,
    String Function(T) itemLabel,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<T>(
              value: value,
              underline: const SizedBox(),
              items: items.map((item) => DropdownMenuItem(
                value: item,
                child: Text(
                  itemLabel(item),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}