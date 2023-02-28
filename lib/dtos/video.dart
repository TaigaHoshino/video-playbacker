import 'package:video_playbacker/dtos/video_category.dart';

class Video {
  final int id;
  List<VideoCategory> videoCategories;
  String title = "";
  final int videoDurationMillis;
  DateTime createdAt;
  final String videoPath;
  final String thumbnailPath;
  String get durationString {
    int durationSec = videoDurationMillis ~/ 1000;
    int hours = durationSec ~/ 3600;
    int minutes = (durationSec % 3600) ~/ 60;
    int seconds = durationSec % 60;
    if(hours != 0){
      return '$hours:$minutes:$seconds';
    }
    else if(minutes != 0){
      return '$minutes:$seconds';
    }
    else{
      return '$seconds';
    }
  }

  Video(this.id, this.title, this.videoCategories, this.videoDurationMillis, this.createdAt, this.videoPath, this.thumbnailPath);
}