// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Project _$ProjectFromJson(Map<String, dynamic> json) {
  return _Project.fromJson(json);
}

/// @nodoc
mixin _$Project {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  SurveyType get surveyType => throw _privateConstructorUsedError;
  String get coordinateSystem => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  int get pointsCount => throw _privateConstructorUsedError;
  ProjectStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Project to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectCopyWith<Project> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectCopyWith<$Res> {
  factory $ProjectCopyWith(Project value, $Res Function(Project) then) =
      _$ProjectCopyWithImpl<$Res, Project>;
  @useResult
  $Res call(
      {String id,
      String name,
      String location,
      SurveyType surveyType,
      String coordinateSystem,
      String notes,
      int pointsCount,
      ProjectStatus status,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ProjectCopyWithImpl<$Res, $Val extends Project>
    implements $ProjectCopyWith<$Res> {
  _$ProjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? location = null,
    Object? surveyType = null,
    Object? coordinateSystem = null,
    Object? notes = null,
    Object? pointsCount = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      surveyType: null == surveyType
          ? _value.surveyType
          : surveyType // ignore: cast_nullable_to_non_nullable
              as SurveyType,
      coordinateSystem: null == coordinateSystem
          ? _value.coordinateSystem
          : coordinateSystem // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      pointsCount: null == pointsCount
          ? _value.pointsCount
          : pointsCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProjectStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectImplCopyWith<$Res> implements $ProjectCopyWith<$Res> {
  factory _$$ProjectImplCopyWith(
          _$ProjectImpl value, $Res Function(_$ProjectImpl) then) =
      __$$ProjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String location,
      SurveyType surveyType,
      String coordinateSystem,
      String notes,
      int pointsCount,
      ProjectStatus status,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ProjectImplCopyWithImpl<$Res>
    extends _$ProjectCopyWithImpl<$Res, _$ProjectImpl>
    implements _$$ProjectImplCopyWith<$Res> {
  __$$ProjectImplCopyWithImpl(
      _$ProjectImpl _value, $Res Function(_$ProjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? location = null,
    Object? surveyType = null,
    Object? coordinateSystem = null,
    Object? notes = null,
    Object? pointsCount = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ProjectImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      surveyType: null == surveyType
          ? _value.surveyType
          : surveyType // ignore: cast_nullable_to_non_nullable
              as SurveyType,
      coordinateSystem: null == coordinateSystem
          ? _value.coordinateSystem
          : coordinateSystem // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      pointsCount: null == pointsCount
          ? _value.pointsCount
          : pointsCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProjectStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectImpl implements _Project {
  const _$ProjectImpl(
      {required this.id,
      required this.name,
      required this.location,
      required this.surveyType,
      required this.coordinateSystem,
      required this.notes,
      required this.pointsCount,
      required this.status,
      required this.createdAt,
      required this.updatedAt});

  factory _$ProjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String location;
  @override
  final SurveyType surveyType;
  @override
  final String coordinateSystem;
  @override
  final String notes;
  @override
  final int pointsCount;
  @override
  final ProjectStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Project(id: $id, name: $name, location: $location, surveyType: $surveyType, coordinateSystem: $coordinateSystem, notes: $notes, pointsCount: $pointsCount, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.surveyType, surveyType) ||
                other.surveyType == surveyType) &&
            (identical(other.coordinateSystem, coordinateSystem) ||
                other.coordinateSystem == coordinateSystem) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.pointsCount, pointsCount) ||
                other.pointsCount == pointsCount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, location, surveyType,
      coordinateSystem, notes, pointsCount, status, createdAt, updatedAt);

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectImplCopyWith<_$ProjectImpl> get copyWith =>
      __$$ProjectImplCopyWithImpl<_$ProjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectImplToJson(
      this,
    );
  }
}

abstract class _Project implements Project {
  const factory _Project(
      {required final String id,
      required final String name,
      required final String location,
      required final SurveyType surveyType,
      required final String coordinateSystem,
      required final String notes,
      required final int pointsCount,
      required final ProjectStatus status,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ProjectImpl;

  factory _Project.fromJson(Map<String, dynamic> json) = _$ProjectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get location;
  @override
  SurveyType get surveyType;
  @override
  String get coordinateSystem;
  @override
  String get notes;
  @override
  int get pointsCount;
  @override
  ProjectStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectImplCopyWith<_$ProjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SurveyPoint _$SurveyPointFromJson(Map<String, dynamic> json) {
  return _SurveyPoint.fromJson(json);
}

/// @nodoc
mixin _$SurveyPoint {
  String get id => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  String get pointId => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double get elevation => throw _privateConstructorUsedError;
  double get accuracy => throw _privateConstructorUsedError;
  FixType get fixType => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this SurveyPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SurveyPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SurveyPointCopyWith<SurveyPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SurveyPointCopyWith<$Res> {
  factory $SurveyPointCopyWith(
          SurveyPoint value, $Res Function(SurveyPoint) then) =
      _$SurveyPointCopyWithImpl<$Res, SurveyPoint>;
  @useResult
  $Res call(
      {String id,
      String projectId,
      String pointId,
      double latitude,
      double longitude,
      double elevation,
      double accuracy,
      FixType fixType,
      String description,
      String? photoUrl,
      DateTime timestamp});
}

/// @nodoc
class _$SurveyPointCopyWithImpl<$Res, $Val extends SurveyPoint>
    implements $SurveyPointCopyWith<$Res> {
  _$SurveyPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SurveyPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? pointId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? elevation = null,
    Object? accuracy = null,
    Object? fixType = null,
    Object? description = null,
    Object? photoUrl = freezed,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      pointId: null == pointId
          ? _value.pointId
          : pointId // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      elevation: null == elevation
          ? _value.elevation
          : elevation // ignore: cast_nullable_to_non_nullable
              as double,
      accuracy: null == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as double,
      fixType: null == fixType
          ? _value.fixType
          : fixType // ignore: cast_nullable_to_non_nullable
              as FixType,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SurveyPointImplCopyWith<$Res>
    implements $SurveyPointCopyWith<$Res> {
  factory _$$SurveyPointImplCopyWith(
          _$SurveyPointImpl value, $Res Function(_$SurveyPointImpl) then) =
      __$$SurveyPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String projectId,
      String pointId,
      double latitude,
      double longitude,
      double elevation,
      double accuracy,
      FixType fixType,
      String description,
      String? photoUrl,
      DateTime timestamp});
}

/// @nodoc
class __$$SurveyPointImplCopyWithImpl<$Res>
    extends _$SurveyPointCopyWithImpl<$Res, _$SurveyPointImpl>
    implements _$$SurveyPointImplCopyWith<$Res> {
  __$$SurveyPointImplCopyWithImpl(
      _$SurveyPointImpl _value, $Res Function(_$SurveyPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of SurveyPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? pointId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? elevation = null,
    Object? accuracy = null,
    Object? fixType = null,
    Object? description = null,
    Object? photoUrl = freezed,
    Object? timestamp = null,
  }) {
    return _then(_$SurveyPointImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      pointId: null == pointId
          ? _value.pointId
          : pointId // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      elevation: null == elevation
          ? _value.elevation
          : elevation // ignore: cast_nullable_to_non_nullable
              as double,
      accuracy: null == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as double,
      fixType: null == fixType
          ? _value.fixType
          : fixType // ignore: cast_nullable_to_non_nullable
              as FixType,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SurveyPointImpl implements _SurveyPoint {
  const _$SurveyPointImpl(
      {required this.id,
      required this.projectId,
      required this.pointId,
      required this.latitude,
      required this.longitude,
      required this.elevation,
      required this.accuracy,
      required this.fixType,
      required this.description,
      this.photoUrl,
      required this.timestamp});

  factory _$SurveyPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$SurveyPointImplFromJson(json);

  @override
  final String id;
  @override
  final String projectId;
  @override
  final String pointId;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double elevation;
  @override
  final double accuracy;
  @override
  final FixType fixType;
  @override
  final String description;
  @override
  final String? photoUrl;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'SurveyPoint(id: $id, projectId: $projectId, pointId: $pointId, latitude: $latitude, longitude: $longitude, elevation: $elevation, accuracy: $accuracy, fixType: $fixType, description: $description, photoUrl: $photoUrl, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SurveyPointImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.pointId, pointId) || other.pointId == pointId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.elevation, elevation) ||
                other.elevation == elevation) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy) &&
            (identical(other.fixType, fixType) || other.fixType == fixType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      projectId,
      pointId,
      latitude,
      longitude,
      elevation,
      accuracy,
      fixType,
      description,
      photoUrl,
      timestamp);

  /// Create a copy of SurveyPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SurveyPointImplCopyWith<_$SurveyPointImpl> get copyWith =>
      __$$SurveyPointImplCopyWithImpl<_$SurveyPointImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SurveyPointImplToJson(
      this,
    );
  }
}

abstract class _SurveyPoint implements SurveyPoint {
  const factory _SurveyPoint(
      {required final String id,
      required final String projectId,
      required final String pointId,
      required final double latitude,
      required final double longitude,
      required final double elevation,
      required final double accuracy,
      required final FixType fixType,
      required final String description,
      final String? photoUrl,
      required final DateTime timestamp}) = _$SurveyPointImpl;

  factory _SurveyPoint.fromJson(Map<String, dynamic> json) =
      _$SurveyPointImpl.fromJson;

  @override
  String get id;
  @override
  String get projectId;
  @override
  String get pointId;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double get elevation;
  @override
  double get accuracy;
  @override
  FixType get fixType;
  @override
  String get description;
  @override
  String? get photoUrl;
  @override
  DateTime get timestamp;

  /// Create a copy of SurveyPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SurveyPointImplCopyWith<_$SurveyPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  String get id => throw _privateConstructorUsedError;
  MessageRole get role => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
          ChatMessage value, $Res Function(ChatMessage) then) =
      _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call({String id, MessageRole role, String content, DateTime timestamp});
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as MessageRole,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
          _$ChatMessageImpl value, $Res Function(_$ChatMessageImpl) then) =
      __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, MessageRole role, String content, DateTime timestamp});
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
      _$ChatMessageImpl _value, $Res Function(_$ChatMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? timestamp = null,
  }) {
    return _then(_$ChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as MessageRole,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl(
      {required this.id,
      required this.role,
      required this.content,
      required this.timestamp});

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  final String id;
  @override
  final MessageRole role;
  @override
  final String content;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'ChatMessage(id: $id, role: $role, content: $content, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, role, content, timestamp);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(
      this,
    );
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage(
      {required final String id,
      required final MessageRole role,
      required final String content,
      required final DateTime timestamp}) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  String get id;
  @override
  MessageRole get role;
  @override
  String get content;
  @override
  DateTime get timestamp;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DataWarning _$DataWarningFromJson(Map<String, dynamic> json) {
  return _DataWarning.fromJson(json);
}

/// @nodoc
mixin _$DataWarning {
  String get id => throw _privateConstructorUsedError;
  WarningType get type => throw _privateConstructorUsedError;
  WarningSeverity get severity => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get pointId => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this DataWarning to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DataWarning
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DataWarningCopyWith<DataWarning> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataWarningCopyWith<$Res> {
  factory $DataWarningCopyWith(
          DataWarning value, $Res Function(DataWarning) then) =
      _$DataWarningCopyWithImpl<$Res, DataWarning>;
  @useResult
  $Res call(
      {String id,
      WarningType type,
      WarningSeverity severity,
      String message,
      String? pointId,
      DateTime timestamp});
}

/// @nodoc
class _$DataWarningCopyWithImpl<$Res, $Val extends DataWarning>
    implements $DataWarningCopyWith<$Res> {
  _$DataWarningCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DataWarning
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? severity = null,
    Object? message = null,
    Object? pointId = freezed,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as WarningType,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as WarningSeverity,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      pointId: freezed == pointId
          ? _value.pointId
          : pointId // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DataWarningImplCopyWith<$Res>
    implements $DataWarningCopyWith<$Res> {
  factory _$$DataWarningImplCopyWith(
          _$DataWarningImpl value, $Res Function(_$DataWarningImpl) then) =
      __$$DataWarningImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      WarningType type,
      WarningSeverity severity,
      String message,
      String? pointId,
      DateTime timestamp});
}

/// @nodoc
class __$$DataWarningImplCopyWithImpl<$Res>
    extends _$DataWarningCopyWithImpl<$Res, _$DataWarningImpl>
    implements _$$DataWarningImplCopyWith<$Res> {
  __$$DataWarningImplCopyWithImpl(
      _$DataWarningImpl _value, $Res Function(_$DataWarningImpl) _then)
      : super(_value, _then);

  /// Create a copy of DataWarning
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? severity = null,
    Object? message = null,
    Object? pointId = freezed,
    Object? timestamp = null,
  }) {
    return _then(_$DataWarningImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as WarningType,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as WarningSeverity,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      pointId: freezed == pointId
          ? _value.pointId
          : pointId // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DataWarningImpl implements _DataWarning {
  const _$DataWarningImpl(
      {required this.id,
      required this.type,
      required this.severity,
      required this.message,
      this.pointId,
      required this.timestamp});

  factory _$DataWarningImpl.fromJson(Map<String, dynamic> json) =>
      _$$DataWarningImplFromJson(json);

  @override
  final String id;
  @override
  final WarningType type;
  @override
  final WarningSeverity severity;
  @override
  final String message;
  @override
  final String? pointId;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'DataWarning(id: $id, type: $type, severity: $severity, message: $message, pointId: $pointId, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataWarningImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.pointId, pointId) || other.pointId == pointId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, type, severity, message, pointId, timestamp);

  /// Create a copy of DataWarning
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DataWarningImplCopyWith<_$DataWarningImpl> get copyWith =>
      __$$DataWarningImplCopyWithImpl<_$DataWarningImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DataWarningImplToJson(
      this,
    );
  }
}

abstract class _DataWarning implements DataWarning {
  const factory _DataWarning(
      {required final String id,
      required final WarningType type,
      required final WarningSeverity severity,
      required final String message,
      final String? pointId,
      required final DateTime timestamp}) = _$DataWarningImpl;

  factory _DataWarning.fromJson(Map<String, dynamic> json) =
      _$DataWarningImpl.fromJson;

  @override
  String get id;
  @override
  WarningType get type;
  @override
  WarningSeverity get severity;
  @override
  String get message;
  @override
  String? get pointId;
  @override
  DateTime get timestamp;

  /// Create a copy of DataWarning
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DataWarningImplCopyWith<_$DataWarningImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
