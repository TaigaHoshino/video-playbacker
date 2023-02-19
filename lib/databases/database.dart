import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../dtos/video.dart';

part 'database.g.dart';

@DataClassName('VideoCategory')
class VideoCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

@DataClassName('VideoInfo')
class VideoInfoList extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  IntColumn get category => integer().references(VideoCategories, #id).nullable()();
  TextColumn get videoExtension => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

@DriftDatabase(tables: [VideoInfoList, VideoCategories])
class Database extends _$Database {
  Database():super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<VideoInfo> createEmptyVideoInfo() async {
    final id = await into(videoInfoList).insert(const VideoInfoListCompanion(title: Value(""), videoExtension: Value("")));
    return VideoInfo(id: id, title: "", category: null, videoExtension: "", createdAt: null);
  }

  Future<int> saveVideoInfo(int id, String title, int? categoryId, String videoExtension)async {
    return (update(videoInfoList)..where((tbl) => tbl.id.equals(id))).write(
      VideoInfoListCompanion(
        title: Value(title),
        category: Value(categoryId),
        videoExtension: Value(videoExtension)
      )
    );
  }

  Future<List<VideoInfo>> getAllVideoInfo() async {
    return await select(videoInfoList).get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}