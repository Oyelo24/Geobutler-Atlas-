export 'map_settings.dart';

class Project {
  final String id;
  final String name;
  final String location;
  final SurveyType surveyType;
  final String coordinateSystem;
  final String notes;
  final int pointsCount;
  final ProjectStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Project({
    required this.id,
    required this.name,
    required this.location,
    required this.surveyType,
    required this.coordinateSystem,
    required this.notes,
    required this.pointsCount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'],
    name: json['name'],
    location: json['location'],
    surveyType: SurveyType.values.firstWhere((e) => e.name == json['surveyType']),
    coordinateSystem: json['coordinateSystem'],
    notes: json['notes'],
    pointsCount: json['pointsCount'],
    status: ProjectStatus.values.firstWhere((e) => e.name == json['status']),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'surveyType': surveyType.name,
    'coordinateSystem': coordinateSystem,
    'notes': notes,
    'pointsCount': pointsCount,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  Project copyWith({
    String? id,
    String? name,
    String? location,
    SurveyType? surveyType,
    String? coordinateSystem,
    String? notes,
    int? pointsCount,
    ProjectStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    location: location ?? this.location,
    surveyType: surveyType ?? this.surveyType,
    coordinateSystem: coordinateSystem ?? this.coordinateSystem,
    notes: notes ?? this.notes,
    pointsCount: pointsCount ?? this.pointsCount,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

class SurveyPoint {
  final String id;
  final String projectId;
  final String pointId;
  final double latitude;
  final double longitude;
  final double elevation;
  final double accuracy;
  final FixType fixType;
  final String description;
  final String? photoUrl;
  final String? voiceNoteUrl;
  final List<Measurement> measurements;
  final DateTime timestamp;

  const SurveyPoint({
    required this.id,
    required this.projectId,
    required this.pointId,
    required this.latitude,
    required this.longitude,
    required this.elevation,
    required this.accuracy,
    required this.fixType,
    required this.description,
    this.photoUrl,
    this.voiceNoteUrl,
    this.measurements = const [],
    required this.timestamp,
  });

  factory SurveyPoint.fromJson(Map<String, dynamic> json) => SurveyPoint(
    id: json['id'],
    projectId: json['projectId'],
    pointId: json['pointId'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    elevation: json['elevation'],
    accuracy: json['accuracy'],
    fixType: FixType.values.firstWhere((e) => e.name == json['fixType']),
    description: json['description'],
    photoUrl: json['photoUrl'],
    voiceNoteUrl: json['voiceNoteUrl'],
    measurements: (json['measurements'] as List? ?? [])
        .map((m) => Measurement.fromJson(m))
        .toList(),
    timestamp: DateTime.parse(json['timestamp']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectId': projectId,
    'pointId': pointId,
    'latitude': latitude,
    'longitude': longitude,
    'elevation': elevation,
    'accuracy': accuracy,
    'fixType': fixType.name,
    'description': description,
    'photoUrl': photoUrl,
    'voiceNoteUrl': voiceNoteUrl,
    'measurements': measurements.map((m) => m.toJson()).toList(),
    'timestamp': timestamp.toIso8601String(),
  };

  SurveyPoint copyWith({
    String? id,
    String? projectId,
    String? pointId,
    double? latitude,
    double? longitude,
    double? elevation,
    double? accuracy,
    FixType? fixType,
    String? description,
    String? photoUrl,
    String? voiceNoteUrl,
    List<Measurement>? measurements,
    DateTime? timestamp,
  }) => SurveyPoint(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    pointId: pointId ?? this.pointId,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    elevation: elevation ?? this.elevation,
    accuracy: accuracy ?? this.accuracy,
    fixType: fixType ?? this.fixType,
    description: description ?? this.description,
    photoUrl: photoUrl ?? this.photoUrl,
    voiceNoteUrl: voiceNoteUrl ?? this.voiceNoteUrl,
    measurements: measurements ?? this.measurements,
    timestamp: timestamp ?? this.timestamp,
  );
}

class Measurement {
  final String id;
  final MeasurementType type;
  final double value;
  final String unit;
  final String? fromPointId;
  final String? toPointId;
  final String notes;
  final DateTime timestamp;

  const Measurement({
    required this.id,
    required this.type,
    required this.value,
    required this.unit,
    this.fromPointId,
    this.toPointId,
    required this.notes,
    required this.timestamp,
  });

  factory Measurement.fromJson(Map<String, dynamic> json) => Measurement(
    id: json['id'],
    type: MeasurementType.values.firstWhere((e) => e.name == json['type']),
    value: json['value'],
    unit: json['unit'],
    fromPointId: json['fromPointId'],
    toPointId: json['toPointId'],
    notes: json['notes'],
    timestamp: DateTime.parse(json['timestamp']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'value': value,
    'unit': unit,
    'fromPointId': fromPointId,
    'toPointId': toPointId,
    'notes': notes,
    'timestamp': timestamp.toIso8601String(),
  };
}

class ChatSession {
  final String id;
  final String title;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatSession({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
    id: json['id'],
    title: json['title'],
    messages: (json['messages'] as List).map((m) => ChatMessage.fromJson(m)).toList(),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'messages': messages.map((m) => m.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  ChatSession copyWith({
    String? id,
    String? title,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ChatSession(
    id: id ?? this.id,
    title: title ?? this.title,
    messages: messages ?? this.messages,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

class ChatMessage {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'],
    role: MessageRole.values.firstWhere((e) => e.name == json['role']),
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role.name,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };

  ChatMessage copyWith({
    String? id,
    MessageRole? role,
    String? content,
    DateTime? timestamp,
  }) => ChatMessage(
    id: id ?? this.id,
    role: role ?? this.role,
    content: content ?? this.content,
    timestamp: timestamp ?? this.timestamp,
  );
}

class DataWarning {
  final String id;
  final WarningType type;
  final WarningSeverity severity;
  final String message;
  final String? pointId;
  final DateTime timestamp;

  const DataWarning({
    required this.id,
    required this.type,
    required this.severity,
    required this.message,
    this.pointId,
    required this.timestamp,
  });

  factory DataWarning.fromJson(Map<String, dynamic> json) => DataWarning(
    id: json['id'],
    type: WarningType.values.firstWhere((e) => e.name == json['type']),
    severity: WarningSeverity.values.firstWhere((e) => e.name == json['severity']),
    message: json['message'],
    pointId: json['pointId'],
    timestamp: DateTime.parse(json['timestamp']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'severity': severity.name,
    'message': message,
    'pointId': pointId,
    'timestamp': timestamp.toIso8601String(),
  };
}

enum SurveyType {
  boundary,
  topographic,
  control,
  recon,
}

enum ProjectStatus {
  active,
  completed,
  underReview,
  approved,
}

enum FixType {
  good,
  fair,
  poor,
}

enum MessageRole {
  user,
  assistant,
}

enum WarningType {
  duplicate,
  poorAccuracy,
  missingControl,
  anomaly,
  closureError,
}

enum WarningSeverity {
  info,
  warning,
  critical,
}

enum MeasurementType {
  distance,
  bearing,
  angle,
  height,
}

enum TabType { dashboard, projects, collect, map, atlas, settings }
