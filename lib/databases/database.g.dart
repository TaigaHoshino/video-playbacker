// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $VideoInfoListTable extends VideoInfoList
    with TableInfo<$VideoInfoListTable, VideoInfo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VideoInfoListTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(""));
  static const VerificationMeta _videoExtensionMeta =
      const VerificationMeta('videoExtension');
  @override
  late final GeneratedColumn<String> videoExtension = GeneratedColumn<String>(
      'video_extension', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(""));
  static const VerificationMeta _videoDurationMillisMeta =
      const VerificationMeta('videoDurationMillis');
  @override
  late final GeneratedColumn<int> videoDurationMillis = GeneratedColumn<int>(
      'video_duration_millis', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isEnableMeta =
      const VerificationMeta('isEnable');
  @override
  late final GeneratedColumn<bool> isEnable =
      GeneratedColumn<bool>('is_enable', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_enable" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, videoExtension, videoDurationMillis, isEnable, createdAt];
  @override
  String get aliasedName => _alias ?? 'video_info_list';
  @override
  String get actualTableName => 'video_info_list';
  @override
  VerificationContext validateIntegrity(Insertable<VideoInfo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('video_extension')) {
      context.handle(
          _videoExtensionMeta,
          videoExtension.isAcceptableOrUnknown(
              data['video_extension']!, _videoExtensionMeta));
    }
    if (data.containsKey('video_duration_millis')) {
      context.handle(
          _videoDurationMillisMeta,
          videoDurationMillis.isAcceptableOrUnknown(
              data['video_duration_millis']!, _videoDurationMillisMeta));
    }
    if (data.containsKey('is_enable')) {
      context.handle(_isEnableMeta,
          isEnable.isAcceptableOrUnknown(data['is_enable']!, _isEnableMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VideoInfo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VideoInfo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      videoExtension: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}video_extension'])!,
      videoDurationMillis: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}video_duration_millis'])!,
      isEnable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_enable'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $VideoInfoListTable createAlias(String alias) {
    return $VideoInfoListTable(attachedDatabase, alias);
  }
}

class VideoInfo extends DataClass implements Insertable<VideoInfo> {
  final int id;
  final String title;
  final String videoExtension;
  final int videoDurationMillis;
  final bool isEnable;
  final DateTime? createdAt;
  const VideoInfo(
      {required this.id,
      required this.title,
      required this.videoExtension,
      required this.videoDurationMillis,
      required this.isEnable,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['video_extension'] = Variable<String>(videoExtension);
    map['video_duration_millis'] = Variable<int>(videoDurationMillis);
    map['is_enable'] = Variable<bool>(isEnable);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  VideoInfoListCompanion toCompanion(bool nullToAbsent) {
    return VideoInfoListCompanion(
      id: Value(id),
      title: Value(title),
      videoExtension: Value(videoExtension),
      videoDurationMillis: Value(videoDurationMillis),
      isEnable: Value(isEnable),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory VideoInfo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VideoInfo(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      videoExtension: serializer.fromJson<String>(json['videoExtension']),
      videoDurationMillis:
          serializer.fromJson<int>(json['videoDurationMillis']),
      isEnable: serializer.fromJson<bool>(json['isEnable']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'videoExtension': serializer.toJson<String>(videoExtension),
      'videoDurationMillis': serializer.toJson<int>(videoDurationMillis),
      'isEnable': serializer.toJson<bool>(isEnable),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  VideoInfo copyWith(
          {int? id,
          String? title,
          String? videoExtension,
          int? videoDurationMillis,
          bool? isEnable,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      VideoInfo(
        id: id ?? this.id,
        title: title ?? this.title,
        videoExtension: videoExtension ?? this.videoExtension,
        videoDurationMillis: videoDurationMillis ?? this.videoDurationMillis,
        isEnable: isEnable ?? this.isEnable,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('VideoInfo(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('videoExtension: $videoExtension, ')
          ..write('videoDurationMillis: $videoDurationMillis, ')
          ..write('isEnable: $isEnable, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, videoExtension, videoDurationMillis, isEnable, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VideoInfo &&
          other.id == this.id &&
          other.title == this.title &&
          other.videoExtension == this.videoExtension &&
          other.videoDurationMillis == this.videoDurationMillis &&
          other.isEnable == this.isEnable &&
          other.createdAt == this.createdAt);
}

class VideoInfoListCompanion extends UpdateCompanion<VideoInfo> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> videoExtension;
  final Value<int> videoDurationMillis;
  final Value<bool> isEnable;
  final Value<DateTime?> createdAt;
  const VideoInfoListCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.videoExtension = const Value.absent(),
    this.videoDurationMillis = const Value.absent(),
    this.isEnable = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  VideoInfoListCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.videoExtension = const Value.absent(),
    this.videoDurationMillis = const Value.absent(),
    this.isEnable = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<VideoInfo> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? videoExtension,
    Expression<int>? videoDurationMillis,
    Expression<bool>? isEnable,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (videoExtension != null) 'video_extension': videoExtension,
      if (videoDurationMillis != null)
        'video_duration_millis': videoDurationMillis,
      if (isEnable != null) 'is_enable': isEnable,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  VideoInfoListCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? videoExtension,
      Value<int>? videoDurationMillis,
      Value<bool>? isEnable,
      Value<DateTime?>? createdAt}) {
    return VideoInfoListCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      videoExtension: videoExtension ?? this.videoExtension,
      videoDurationMillis: videoDurationMillis ?? this.videoDurationMillis,
      isEnable: isEnable ?? this.isEnable,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (videoExtension.present) {
      map['video_extension'] = Variable<String>(videoExtension.value);
    }
    if (videoDurationMillis.present) {
      map['video_duration_millis'] = Variable<int>(videoDurationMillis.value);
    }
    if (isEnable.present) {
      map['is_enable'] = Variable<bool>(isEnable.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VideoInfoListCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('videoExtension: $videoExtension, ')
          ..write('videoDurationMillis: $videoDurationMillis, ')
          ..write('isEnable: $isEnable, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $VideoCategoriesTable extends VideoCategories
    with TableInfo<$VideoCategoriesTable, VideoCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VideoCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? 'video_categories';
  @override
  String get actualTableName => 'video_categories';
  @override
  VerificationContext validateIntegrity(Insertable<VideoCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VideoCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VideoCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $VideoCategoriesTable createAlias(String alias) {
    return $VideoCategoriesTable(attachedDatabase, alias);
  }
}

class VideoCategory extends DataClass implements Insertable<VideoCategory> {
  final int id;
  final String name;
  const VideoCategory({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  VideoCategoriesCompanion toCompanion(bool nullToAbsent) {
    return VideoCategoriesCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory VideoCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VideoCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  VideoCategory copyWith({int? id, String? name}) => VideoCategory(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('VideoCategory(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VideoCategory &&
          other.id == this.id &&
          other.name == this.name);
}

class VideoCategoriesCompanion extends UpdateCompanion<VideoCategory> {
  final Value<int> id;
  final Value<String> name;
  const VideoCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  VideoCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<VideoCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  VideoCategoriesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return VideoCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VideoCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $VideoCategorizationsTable extends VideoCategorizations
    with TableInfo<$VideoCategorizationsTable, VideoCategorization> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VideoCategorizationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _videoInfoIdMeta =
      const VerificationMeta('videoInfoId');
  @override
  late final GeneratedColumn<int> videoInfoId = GeneratedColumn<int>(
      'video_info_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES video_info_list (id)'));
  static const VerificationMeta _videoCategoryIdMeta =
      const VerificationMeta('videoCategoryId');
  @override
  late final GeneratedColumn<int> videoCategoryId = GeneratedColumn<int>(
      'video_category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES video_categories (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, videoInfoId, videoCategoryId];
  @override
  String get aliasedName => _alias ?? 'video_categorizations';
  @override
  String get actualTableName => 'video_categorizations';
  @override
  VerificationContext validateIntegrity(
      Insertable<VideoCategorization> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('video_info_id')) {
      context.handle(
          _videoInfoIdMeta,
          videoInfoId.isAcceptableOrUnknown(
              data['video_info_id']!, _videoInfoIdMeta));
    } else if (isInserting) {
      context.missing(_videoInfoIdMeta);
    }
    if (data.containsKey('video_category_id')) {
      context.handle(
          _videoCategoryIdMeta,
          videoCategoryId.isAcceptableOrUnknown(
              data['video_category_id']!, _videoCategoryIdMeta));
    } else if (isInserting) {
      context.missing(_videoCategoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VideoCategorization map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VideoCategorization(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      videoInfoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}video_info_id'])!,
      videoCategoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}video_category_id'])!,
    );
  }

  @override
  $VideoCategorizationsTable createAlias(String alias) {
    return $VideoCategorizationsTable(attachedDatabase, alias);
  }
}

class VideoCategorization extends DataClass
    implements Insertable<VideoCategorization> {
  final int id;
  final int videoInfoId;
  final int videoCategoryId;
  const VideoCategorization(
      {required this.id,
      required this.videoInfoId,
      required this.videoCategoryId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['video_info_id'] = Variable<int>(videoInfoId);
    map['video_category_id'] = Variable<int>(videoCategoryId);
    return map;
  }

  VideoCategorizationsCompanion toCompanion(bool nullToAbsent) {
    return VideoCategorizationsCompanion(
      id: Value(id),
      videoInfoId: Value(videoInfoId),
      videoCategoryId: Value(videoCategoryId),
    );
  }

  factory VideoCategorization.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VideoCategorization(
      id: serializer.fromJson<int>(json['id']),
      videoInfoId: serializer.fromJson<int>(json['videoInfoId']),
      videoCategoryId: serializer.fromJson<int>(json['videoCategoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'videoInfoId': serializer.toJson<int>(videoInfoId),
      'videoCategoryId': serializer.toJson<int>(videoCategoryId),
    };
  }

  VideoCategorization copyWith(
          {int? id, int? videoInfoId, int? videoCategoryId}) =>
      VideoCategorization(
        id: id ?? this.id,
        videoInfoId: videoInfoId ?? this.videoInfoId,
        videoCategoryId: videoCategoryId ?? this.videoCategoryId,
      );
  @override
  String toString() {
    return (StringBuffer('VideoCategorization(')
          ..write('id: $id, ')
          ..write('videoInfoId: $videoInfoId, ')
          ..write('videoCategoryId: $videoCategoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, videoInfoId, videoCategoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VideoCategorization &&
          other.id == this.id &&
          other.videoInfoId == this.videoInfoId &&
          other.videoCategoryId == this.videoCategoryId);
}

class VideoCategorizationsCompanion
    extends UpdateCompanion<VideoCategorization> {
  final Value<int> id;
  final Value<int> videoInfoId;
  final Value<int> videoCategoryId;
  const VideoCategorizationsCompanion({
    this.id = const Value.absent(),
    this.videoInfoId = const Value.absent(),
    this.videoCategoryId = const Value.absent(),
  });
  VideoCategorizationsCompanion.insert({
    this.id = const Value.absent(),
    required int videoInfoId,
    required int videoCategoryId,
  })  : videoInfoId = Value(videoInfoId),
        videoCategoryId = Value(videoCategoryId);
  static Insertable<VideoCategorization> custom({
    Expression<int>? id,
    Expression<int>? videoInfoId,
    Expression<int>? videoCategoryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (videoInfoId != null) 'video_info_id': videoInfoId,
      if (videoCategoryId != null) 'video_category_id': videoCategoryId,
    });
  }

  VideoCategorizationsCompanion copyWith(
      {Value<int>? id, Value<int>? videoInfoId, Value<int>? videoCategoryId}) {
    return VideoCategorizationsCompanion(
      id: id ?? this.id,
      videoInfoId: videoInfoId ?? this.videoInfoId,
      videoCategoryId: videoCategoryId ?? this.videoCategoryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (videoInfoId.present) {
      map['video_info_id'] = Variable<int>(videoInfoId.value);
    }
    if (videoCategoryId.present) {
      map['video_category_id'] = Variable<int>(videoCategoryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VideoCategorizationsCompanion(')
          ..write('id: $id, ')
          ..write('videoInfoId: $videoInfoId, ')
          ..write('videoCategoryId: $videoCategoryId')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  late final $VideoInfoListTable videoInfoList = $VideoInfoListTable(this);
  late final $VideoCategoriesTable videoCategories =
      $VideoCategoriesTable(this);
  late final $VideoCategorizationsTable videoCategorizations =
      $VideoCategorizationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [videoInfoList, videoCategories, videoCategorizations];
}
