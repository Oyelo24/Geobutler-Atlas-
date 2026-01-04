import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String name,
    required String location,
    required SurveyType surveyType,
    required String coordinateSystem,
    required String notes,
    required int pointsCount,
    required ProjectStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
}

@freezed
class SurveyPoint with _$SurveyPoint {
  const factory SurveyPoint({
    required String id,
    required String projectId,
    required String pointId,
    required double latitude,
    required double longitude,
    required double elevation,
    required double accuracy,
    required FixType fixType,
    required String description,
    String? photoUrl,
    required DateTime timestamp,
  }) = _SurveyPoint;

  factory SurveyPoint.fromJson(Map<String, dynamic> json) => _$SurveyPointFromJson(json);
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required MessageRole role,
    required String content,
    required DateTime timestamp,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}

@freezed
class DataWarning with _$DataWarning {
  const factory DataWarning({
    required String id,
    required WarningType type,
    required WarningSeverity severity,
    required String message,
    String? pointId,
    required DateTime timestamp,
  }) = _DataWarning;

  factory DataWarning.fromJson(Map<String, dynamic> json) => _$DataWarningFromJson(json);
}

enum SurveyType {
  @JsonValue('boundary')
  boundary,
  @JsonValue('topographic')
  topographic,
  @JsonValue('control')
  control,
  @JsonValue('recon')
  recon,
}

enum ProjectStatus {
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
}

enum FixType {
  @JsonValue('good')
  good,
  @JsonValue('fair')
  fair,
  @JsonValue('poor')
  poor,
}

enum MessageRole {
  @JsonValue('user')
  user,
  @JsonValue('assistant')
  assistant,
}

enum WarningType {
  @JsonValue('duplicate')
  duplicate,
  @JsonValue('poor_accuracy')
  poorAccuracy,
  @JsonValue('missing_control')
  missingControl,
  @JsonValue('anomaly')
  anomaly,
}

enum WarningSeverity {
  @JsonValue('info')
  info,
  @JsonValue('warning')
  warning,
  @JsonValue('critical')
  critical,
}

enum TabType {
  dashboard,
  projects,
  collect,
  map,
  atlas,
  settings,
}