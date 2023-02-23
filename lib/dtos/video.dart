import 'package:video_playbacker/dtos/video_category.dart';

class Video {
  final int id;
  VideoCategory? category;
  String title = "";
  final int videoDurationMillis;
  DateTime createdAt;
  final String videoPath;
  final String thumbnailPath;

  Video(this.id, this.title, this.category, this.videoDurationMillis, this.createdAt, this.videoPath, this.thumbnailPath);
}