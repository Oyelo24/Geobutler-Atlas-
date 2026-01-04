// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectImpl _$$ProjectImplFromJson(Map<String, dynamic> json) =>
    _$ProjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      surveyType: $enumDecode(_$SurveyTypeEnumMap, json['surveyType']),
      coordinateSystem: json['coordinateSystem'] as String,
      notes: json['notes'] as String,
      pointsCount: (json['pointsCount'] as num).toInt(),
      status: $enumDecode(_$ProjectStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ProjectImplToJson(_$ProjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'surveyType': _$SurveyTypeEnumMap[instance.surveyType]!,
      'coordinateSystem': instance.coordinateSystem,
      'notes': instance.notes,
      'pointsCount': instance.pointsCount,
      'status': _$ProjectStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$SurveyTypeEnumMap = {
  SurveyType.boundary: 'boundary',
  SurveyType.topographic: 'topographic',
  SurveyType.control: 'control',
  SurveyType.recon: 'recon',
};

const _$ProjectStatusEnumMap = {
  ProjectStatus.active: 'active',
  ProjectStatus.completed: 'completed',
};

_$SurveyPointImpl _$$SurveyPointImplFromJson(Map<String, dynamic> json) =>
    _$SurveyPointImpl(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      pointId: json['pointId'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      elevation: (json['elevation'] as num).toDouble(),
      accuracy: (json['accuracy'] as num).toDouble(),
      fixType: $enumDecode(_$FixTypeEnumMap, json['fixType']),
      description: json['description'] as String,
      photoUrl: json['photoUrl'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$SurveyPointImplToJson(_$SurveyPointImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'pointId': instance.pointId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'elevation': instance.elevation,
      'accuracy': instance.accuracy,
      'fixType': _$FixTypeEnumMap[instance.fixType]!,
      'description': instance.description,
      'photoUrl': instance.photoUrl,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$FixTypeEnumMap = {
  FixType.good: 'good',
  FixType.fair: 'fair',
  FixType.poor: 'poor',
};

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      role: $enumDecode(_$MessageRoleEnumMap, json['role']),
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': _$MessageRoleEnumMap[instance.role]!,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$MessageRoleEnumMap = {
  MessageRole.user: 'user',
  MessageRole.assistant: 'assistant',
};

_$DataWarningImpl _$$DataWarningImplFromJson(Map<String, dynamic> json) =>
    _$DataWarningImpl(
      id: json['id'] as String,
      type: $enumDecode(_$WarningTypeEnumMap, json['type']),
      severity: $enumDecode(_$WarningSeverityEnumMap, json['severity']),
      message: json['message'] as String,
      pointId: json['pointId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$DataWarningImplToJson(_$DataWarningImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$WarningTypeEnumMap[instance.type]!,
      'severity': _$WarningSeverityEnumMap[instance.severity]!,
      'message': instance.message,
      'pointId': instance.pointId,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$WarningTypeEnumMap = {
  WarningType.duplicate: 'duplicate',
  WarningType.poorAccuracy: 'poor_accuracy',
  WarningType.missingControl: 'missing_control',
  WarningType.anomaly: 'anomaly',
};

const _$WarningSeverityEnumMap = {
  WarningSeverity.info: 'info',
  WarningSeverity.warning: 'warning',
  WarningSeverity.critical: 'critical',
};
