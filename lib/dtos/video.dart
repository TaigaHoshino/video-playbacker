import 'package:video_playbacker/dtos/video_category.dart';

class Video {
  final int id;
  VideoCategory? category;
  String title = "";
  DateTime? createdAt;
  final String videoPath;

  Video(this.id, this.title, this.category, this.createdAt, this.videoPath);
}