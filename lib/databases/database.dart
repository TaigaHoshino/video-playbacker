import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DataClassName('VideoCategory')
class VideoCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class VideoCategorizations extends Table {
  IntColumn get id =>  integer().autoIncrement()();
  IntColumn get videoInfoId => integer().references(VideoInfoList, #id)();
  IntColumn get videoCategoryId => integer().references(VideoCategories, #id)();
}

@DataClassName('VideoInfo')
class VideoInfoList extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withDefault(const Constant(""))();
  TextColumn get videoExtension => text().withDefault(const Constant(""))();
  IntColumn get videoDurationMillis => integer().withDefault(const Constant(0))();
  BoolColumn get isEnable => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

@DriftDatabase(tables: [VideoInfoList, VideoCategorizations, VideoCategories])
class Database extends _$Database {
  Database():super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<VideoInfo> createEmptyVideoInfo() async {
    final id = await into(videoInfoList).insert(const VideoInfoListCompanion());
    return VideoInfo(id: id, title: "", videoExtension: "", videoDurationMillis: 0, isEnable: false, createdAt: null);
  }

  Future<int> saveVideoInfo(int id, String title, String videoExtension, int duration, bool isEnable, DateTime createdAt) async {
    return (update(videoInfoList)..where((tbl) => tbl.id.equals(id))).write(
      VideoInfoListCompanion(
        title: Value(title),
        videoExtension: Value(videoExtension),
        isEnable: Value(isEnable),
        videoDurationMillis: Value(duration),
        createdAt: Value(createdAt)
      )
    );
  }

  Future<int> updateVideoInfo(int id, String title, bool isEnable) async {
    return (update(videoInfoList)..where((tbl) => tbl.id.equals(id))).write(
      VideoInfoListCompanion(
        title: Value(title),
        isEnable: Value(isEnable),
      )
    );
  }

  Future<List<VideoInfo>> getVideoInfoListBy(bool isEnable) async {
    return await (select(videoInfoList)..where((tbl) => tbl.isEnable.equals(isEnable))).get();
  }

  Future<void> deleteVideoInfo(int id) async {
    await (delete(videoCategorizations)..where((tbl) => tbl.videoInfoId.equals(id))).go();
    await (delete(videoInfoList)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> addVideoCategorization(int videoInfoId, int videoCategoryId) async {
    await into(videoCategorizations).insert(
      VideoCategorizationsCompanion(
        videoInfoId: Value(videoInfoId),
        videoCategoryId: Value(videoCategoryId)
      ));
  }

  Future<void> removeVideoCategorization(int videoInfoId, int videoCategoryId) async {
    await (delete(videoCategorizations)..where((tbl) => tbl.videoInfoId.equals(videoInfoId) & tbl.videoCategoryId.equals(videoCategoryId))).go();
  }

  Future<void> createNewVideoCategory(String name) async {
    await into(videoCategories).insert(VideoCategoriesCompanion(name: Value(name)));
  }

  Future<List<VideoCategory>> getAllVideoCategory() async {
    return await (select(videoCategories).get());
  }

  Future<List<VideoCategory>> getVideoCategoriesByVideoInfoId(int videoInfoId) async {
    List<VideoCategory> categories = [];

    for(final categorization in await (select(videoCategorizations)..where((tbl) => tbl.videoInfoId.equals(videoInfoId))).get()) {  
      categories.add(await (select(videoCategories)..where((tbl) => tbl.id.equals(categorization.videoCategoryId))).getSingle());
    }

    return categories;
  }

  Future<int> updateVideoCategory(int id, String name) async {
    return await (update(videoCategories)..where((tbl) => tbl.id.equals(id))).write(VideoCategoriesCompanion(
      name: Value(name)
    ));
  }

  Future<void> deleteVideoCategory(int id) async {
    await (delete(videoCategorizations)..where((tbl) => tbl.videoCategoryId.equals(id))).go();
    await (delete(videoCategories)..where((tbl) => tbl.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}