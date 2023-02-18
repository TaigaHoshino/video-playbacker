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
  DateTimeColumn get createdAt => dateTime().nullable()();
}

@DriftDatabase(tables: [VideoInfoList, VideoCategories])
class Database extends _$Database {
  Database():super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<Video> createEmptyVideo() async {
    final id = await into(videoInfoList).insert(const VideoInfoListCompanion(title: Value("")));
    return Video(id, "", null, null);
  }

  Future<int> saveVideo(Video entry) async {
    return (update(videoInfoList)..where((tbl) => tbl.id.equals(entry.id))).write(
      VideoInfoListCompanion(
        title: Value(entry.title),
        category: Value(entry.category?.id),
      )
    );
  }

  Future<List<Video>> getAllVideos() async {
    final videoInfos = await select(videoInfoList).get();

    List<Video> video = [];

    for (var info in videoInfos) {
      video.add(Video(info.id, info.title, null, info.createdAt));
    }

    return video;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}