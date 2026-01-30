import 'package:google_maps_flutter/google_maps_flutter.dart';

enum MapStyle {
  normal,
  satellite,
  terrain,
  hybrid,
}

enum MarkerStyle {
  circle,
  pin,
  square,
  diamond,
}

class MapSettings {
  final MapStyle mapStyle;
  final double zoom;
  final double minZoom;
  final double maxZoom;
  final bool showCurrentLocation;
  final bool showSurveyPoints;
  final bool showPointLabels;
  final bool showAccuracyCircles;
  final MarkerStyle markerStyle;
  final double markerSize;
  final bool showGrid;
  final bool showScale;
  final bool showCompass;
  final double opacity;
  final bool clusteredPoints;
  final bool showTrails;
  final bool nightMode;

  const MapSettings({
    this.mapStyle = MapStyle.normal,
    this.zoom = 14.0,
    this.minZoom = 5.0,
    this.maxZoom = 22.0,
    this.showCurrentLocation = true,
    this.showSurveyPoints = true,
    this.showPointLabels = true,
    this.showAccuracyCircles = false,
    this.markerStyle = MarkerStyle.circle,
    this.markerSize = 24.0,
    this.showGrid = false,
    this.showScale = true,
    this.showCompass = true,
    this.opacity = 1.0,
    this.clusteredPoints = false,
    this.showTrails = false,
    this.nightMode = false,
  });

  MapSettings copyWith({
    MapStyle? mapStyle,
    double? zoom,
    double? minZoom,
    double? maxZoom,
    bool? showCurrentLocation,
    bool? showSurveyPoints,
    bool? showPointLabels,
    bool? showAccuracyCircles,
    MarkerStyle? markerStyle,
    double? markerSize,
    bool? showGrid,
    bool? showScale,
    bool? showCompass,
    double? opacity,
    bool? clusteredPoints,
    bool? showTrails,
    bool? nightMode,
  }) => MapSettings(
    mapStyle: mapStyle ?? this.mapStyle,
    zoom: zoom ?? this.zoom,
    minZoom: minZoom ?? this.minZoom,
    maxZoom: maxZoom ?? this.maxZoom,
    showCurrentLocation: showCurrentLocation ?? this.showCurrentLocation,
    showSurveyPoints: showSurveyPoints ?? this.showSurveyPoints,
    showPointLabels: showPointLabels ?? this.showPointLabels,
    showAccuracyCircles: showAccuracyCircles ?? this.showAccuracyCircles,
    markerStyle: markerStyle ?? this.markerStyle,
    markerSize: markerSize ?? this.markerSize,
    showGrid: showGrid ?? this.showGrid,
    showScale: showScale ?? this.showScale,
    showCompass: showCompass ?? this.showCompass,
    opacity: opacity ?? this.opacity,
    clusteredPoints: clusteredPoints ?? this.clusteredPoints,
    showTrails: showTrails ?? this.showTrails,
    nightMode: nightMode ?? this.nightMode,
  );

  MapType getGoogleMapType() {
    switch (mapStyle) {
      case MapStyle.normal:
        return MapType.normal;
      case MapStyle.satellite:
        return MapType.satellite;
      case MapStyle.terrain:
        return MapType.terrain;
      case MapStyle.hybrid:
        return MapType.hybrid;
    }
  }
}