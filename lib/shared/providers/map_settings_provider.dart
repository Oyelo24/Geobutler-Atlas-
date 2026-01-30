import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/map_settings.dart';

class MapSettingsNotifier extends StateNotifier<MapSettings> {
  MapSettingsNotifier() : super(const MapSettings());

  void updateMapStyle(MapStyle style) {
    state = state.copyWith(mapStyle: style);
  }

  void updateZoom(double zoom) {
    state = state.copyWith(zoom: zoom);
  }

  void updateZoomLimits(double min, double max) {
    state = state.copyWith(minZoom: min, maxZoom: max);
  }

  void toggleCurrentLocation() {
    state = state.copyWith(showCurrentLocation: !state.showCurrentLocation);
  }

  void toggleSurveyPoints() {
    state = state.copyWith(showSurveyPoints: !state.showSurveyPoints);
  }

  void togglePointLabels() {
    state = state.copyWith(showPointLabels: !state.showPointLabels);
  }

  void toggleAccuracyCircles() {
    state = state.copyWith(showAccuracyCircles: !state.showAccuracyCircles);
  }

  void updateMarkerStyle(MarkerStyle style) {
    state = state.copyWith(markerStyle: style);
  }

  void updateMarkerSize(double size) {
    state = state.copyWith(markerSize: size);
  }

  void toggleGrid() {
    state = state.copyWith(showGrid: !state.showGrid);
  }

  void toggleScale() {
    state = state.copyWith(showScale: !state.showScale);
  }

  void toggleCompass() {
    state = state.copyWith(showCompass: !state.showCompass);
  }

  void updateOpacity(double opacity) {
    state = state.copyWith(opacity: opacity);
  }

  void toggleClustering() {
    state = state.copyWith(clusteredPoints: !state.clusteredPoints);
  }

  void toggleTrails() {
    state = state.copyWith(showTrails: !state.showTrails);
  }

  void toggleNightMode() {
    state = state.copyWith(nightMode: !state.nightMode);
  }

  void resetToDefaults() {
    state = const MapSettings();
  }
}

final mapSettingsProvider = StateNotifierProvider<MapSettingsNotifier, MapSettings>((ref) {
  return MapSettingsNotifier();
});