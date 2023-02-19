// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
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
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
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
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<int> category = GeneratedColumn<int>(
      'category', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES video_categories (id)'));
  static const VerificationMeta _videoExtensionMeta =
      const VerificationMeta('videoExtension');
  @override
  late final GeneratedColumn<String> videoExtension = GeneratedColumn<String>(
      'video_extension', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, category, videoExtension, createdAt];
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
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('video_extension')) {
      context.handle(
          _videoExtensionMeta,
          videoExtension.isAcceptableOrUnknown(
              data['video_extension']!, _videoExtensionMeta));
    } else if (isInserting) {
      context.missing(_videoExtensionMeta);
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
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category']),
      videoExtension: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}video_extension'])!,
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
  final int? category;
  final String videoExtension;
  final DateTime? createdAt;
  const VideoInfo(
      {required this.id,
      required this.title,
      this.category,
      required this.videoExtension,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<int>(category);
    }
    map['video_extension'] = Variable<String>(videoExtension);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  VideoInfoListCompanion toCompanion(bool nullToAbsent) {
    return VideoInfoListCompanion(
      id: Value(id),
      title: Value(title),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      videoExtension: Value(videoExtension),
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
      category: serializer.fromJson<int?>(json['category']),
      videoExtension: serializer.fromJson<String>(json['videoExtension']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<int?>(category),
      'videoExtension': serializer.toJson<String>(videoExtension),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  VideoInfo copyWith(
          {int? id,
          String? title,
          Value<int?> category = const Value.absent(),
          String? videoExtension,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      VideoInfo(
        id: id ?? this.id,
        title: title ?? this.title,
        category: category.present ? category.value : this.category,
        videoExtension: videoExtension ?? this.videoExtension,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('VideoInfo(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('videoExtension: $videoExtension, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, category, videoExtension, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VideoInfo &&
          other.id == this.id &&
          other.title == this.title &&
          other.category == this.category &&
          other.videoExtension == this.videoExtension &&
          other.createdAt == this.createdAt);
}

class VideoInfoListCompanion extends UpdateCompanion<VideoInfo> {
  final Value<int> id;
  final Value<String> title;
  final Value<int?> category;
  final Value<String> videoExtension;
  final Value<DateTime?> createdAt;
  const VideoInfoListCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.videoExtension = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  VideoInfoListCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.category = const Value.absent(),
    required String videoExtension,
    this.createdAt = const Value.absent(),
  })  : title = Value(title),
        videoExtension = Value(videoExtension);
  static Insertable<VideoInfo> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? category,
    Expression<String>? videoExtension,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (videoExtension != null) 'video_extension': videoExtension,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  VideoInfoListCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<int?>? category,
      Value<String>? videoExtension,
      Value<DateTime?>? createdAt}) {
    return VideoInfoListCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      videoExtension: videoExtension ?? this.videoExtension,
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
    if (category.present) {
      map['category'] = Variable<int>(category.value);
    }
    if (videoExtension.present) {
      map['video_extension'] = Variable<String>(videoExtension.value);
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
          ..write('category: $category, ')
          ..write('videoExtension: $videoExtension, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  late final $VideoCategoriesTable videoCategories =
      $VideoCategoriesTable(this);
  late final $VideoInfoListTable videoInfoList = $VideoInfoListTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [videoCategories, videoInfoList];
}
