import 'dart:async';
import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../databases/database.dart';
import '../dtos/video.dart' as dto_video;

class VideoRepository {
  final _database = Database();
  String _docDirPath = "";
  String _tmpDirPath = "";

  static const _videoFolder = "video";
  static const _thumbnailFolder = "thumbnail";

  void init() async{
    final docDir = await getApplicationDocumentsDirectory();
    _docDirPath = docDir.path;

    final tmpDir = await getTemporaryDirectory();
    _tmpDirPath = tmpDir.path;
  }

  // ローカルDBとアプリ内ディレクトリに動画の情報を保存する
  // 動画とサムネイルは指定したディレクトリに'DBに保存される動画ID.拡張子'で保存される
  Future<dto_video.Video> saveVideoByUrl(String url) async {
    final youtubeExplode = YoutubeExplode();

    final videoInfo = await _database.createEmptyVideoInfo();

    final manifest = await youtubeExplode.videos.streamsClient.getManifest(url);

    final videoExtension = manifest.videoOnly.first.container.name.toString();
    final audioExtension = manifest.audioOnly.first.container.name.toString();

    final videoDirectory = Directory('$_docDirPath/$_videoFolder/');
    await videoDirectory.create(recursive: true);

    final thumbnailDirectory = Directory('$_docDirPath/$_thumbnailFolder/');
    await thumbnailDirectory.create(recursive: true);

    final outputVideoPath = '$_docDirPath/$_videoFolder/${videoInfo.id}.$videoExtension';
    final outputThumbnailPath = '$_docDirPath/$_thumbnailFolder/${videoInfo.id}.jpg';
    final videoTmpPath = '$_tmpDirPath/video${videoInfo.id}.$videoExtension';
    final audioTmpPath = '$_tmpDirPath/audio${videoInfo.id}.$audioExtension';

    await _writeStreamToFile(videoTmpPath,
                            youtubeExplode.videos.streamsClient.get(manifest.videoOnly.first),
                            manifest.videoOnly.first.size.totalBytes);

    await _writeStreamToFile(audioTmpPath,
                            youtubeExplode.videos.streamsClient.get(manifest.audioOnly.withHighestBitrate()),
                            manifest.audioOnly.withHighestBitrate().size.totalBytes);

    if(!await _muxVideoAndAudio(outputVideoPath, videoTmpPath, audioTmpPath)){
      throw Exception('Failed to mux video and audio');
    }

    final controller = VideoPlayerController.file(File(outputVideoPath));
    await controller.initialize();

    print('duration: ${controller.value.duration}');
    int duration = controller.value.duration.inMilliseconds;

    bool isSuccess = false;

    if(duration < 10000){
      isSuccess = await _createThumbnail(outputThumbnailPath, outputVideoPath, 5);
    }
    else {
      isSuccess = await _createThumbnail(outputThumbnailPath, outputVideoPath, 5);
    }

    if(!isSuccess){
      throw Exception('Failed to create thumbnail');
    }

    _database.saveVideoInfo(videoInfo.id, videoInfo.title, null, videoExtension, duration, true, DateTime.now());
    return _createVideoBy(videoInfo);
  }

  Future<List<dto_video.Video>> getAllVideos() async {

    List<dto_video.Video> video = [];

    List<VideoInfo> videoInfo = await _database.getAllVideoInfo();

    for (var info in videoInfo) {
      if(!info.isEnable) continue;
      video.add(await _createVideoBy(info));
    }

    return video;
  }

  Future<dto_video.Video> _createVideoBy(VideoInfo videoInfo) async{
    String videoPath = '$_docDirPath/$_videoFolder/${videoInfo.id}.${videoInfo.videoExtension}';
    String thumbnailPath = '$_docDirPath/$_thumbnailFolder/${videoInfo.id}.jpg';
    return dto_video.Video(videoInfo.id, videoInfo.title, null, videoInfo.videoDurationMillis, videoInfo.createdAt!, videoPath, thumbnailPath);
  }

  Future<void> _writeStreamToFile(String targetPath ,Stream<List<int>> stream, int length) async {
    final file = File(targetPath);
    final output = file.openWrite(mode: FileMode.writeOnlyAppend);
    var count = 0;
    print('write begin: $targetPath');
    await for (final data in stream){
      count += data.length;
      output.add(data);
    }
    await output.flush();
    await output.close();
    print('write complete: $targetPath');
  }

  Future<bool> _muxVideoAndAudio(String outputFilePath, String videoPath, String audioPath)async{
    File(outputFilePath);
    print('mux video and audio: $outputFilePath');
    bool isSuccess = false;
    await FFmpegKit.execute('-i "$videoPath" -i "$audioPath" -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 "$outputFilePath"').then((session) async {
      final returnCode = await session.getReturnCode();
      if(ReturnCode.isSuccess(returnCode)){
        print('mux video and audio success');
        isSuccess = true;
      }
      else {
        print('mux video and audio error');
        isSuccess = false;
      }
    });

    return isSuccess;
  }

  Future<bool> _createThumbnail(String outputFilePath, String videoPath, int offsetSeconds) async{
    File(outputFilePath);
    print('create thumbnail: $outputFilePath');
    bool isSuccess = false;
    print('-i "$videoPath" -r 1 -ss $offsetSeconds -frames 1 "$outputFilePath"');
    await FFmpegKit.execute('-ss $offsetSeconds -i "$videoPath" -frames:v 1 "$outputFilePath"').then((session) async {
      final returnCode = await session.getReturnCode();
      if(ReturnCode.isSuccess(returnCode)){
        print('create thumbnail success');
        isSuccess = true;
      }
      else {
        print('create thumbnail error');
        isSuccess = false;
      }
    });

    return isSuccess;
  }
}