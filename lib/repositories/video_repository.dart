import 'dart:async';
import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../databases/database.dart';
import '../dtos/loading_state.dart';
import '../dtos/video.dart' as dto_video;

class VideoRepository {
  final _database = Database();
  String _docDirPath = "";

  static const _videoFolder = "video";
  static const _thumbnailFolder = "thumbnail";

  // ローカルDBとアプリ内ディレクトリに動画の情報を保存する
  // 動画とサムネイルは指定したディレクトリに'DBに保存される動画ID.拡張子'で保存される
  Future<dto_video.Video> saveVideoByUrl(String url) async {
    final youtubeExplode = YoutubeExplode();

    final videoInfo = await _database.createEmptyVideoInfo();

    final dirPath = await _getDocumentDirPath();
    final tempDir = await getTemporaryDirectory();
    final tempDirPath = tempDir.path;

    final manifest = await youtubeExplode.videos.streamsClient.getManifest(url);

    final videoExtension = manifest.videoOnly.first.container.name.toString();
    final audioExtension = manifest.audioOnly.first.container.name.toString();

    final directory = Directory('$dirPath/$_videoFolder/');
    await directory.create(recursive: true);

    final outputPath = '$dirPath/$_videoFolder/${videoInfo.id}.$videoExtension';
    final videoTmpPath = '$tempDirPath/video${videoInfo.id}.$videoExtension';
    final audioTmpPath = '$tempDirPath/audio${videoInfo.id}.$audioExtension';

    await _writeStreamToFile(videoTmpPath,
                            youtubeExplode.videos.streamsClient.get(manifest.videoOnly.first),
                            manifest.videoOnly.first.size.totalBytes);

    await _writeStreamToFile(audioTmpPath,
                            youtubeExplode.videos.streamsClient.get(manifest.audioOnly.withHighestBitrate()),
                            manifest.audioOnly.withHighestBitrate().size.totalBytes);

    bool isSuccess = await _muxVideoAndAudio(outputPath, videoTmpPath, audioTmpPath);

    if(!isSuccess){
      throw Exception('Failed to muxing video and audio');
    }

    _database.saveVideoInfo(videoInfo.id, videoInfo.title, null, videoExtension);
    return _createVideoBy(videoInfo);
  }

  Future<List<dto_video.Video>> getAllVideos() async {

    List<dto_video.Video> video = [];

    List<VideoInfo> videoInfo = await _database.getAllVideoInfo();

    for (var info in videoInfo) {
      video.add(await _createVideoBy(info));
    }

    return video;
  }

  Future<dto_video.Video> _createVideoBy(VideoInfo videoInfo) async{
    final dirPath = await _getDocumentDirPath();
    String videoPath = '$dirPath/$_videoFolder/${videoInfo.id}.${videoInfo.videoExtension}';
    return dto_video.Video(videoInfo.id, videoInfo.title, null, videoInfo.createdAt, videoPath);
  }

  Future<String> _getDocumentDirPath() async {
    if(_docDirPath.isNotEmpty){
      return _docDirPath;
    }

    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<void> _writeStreamToFile(String targetPath ,Stream<List<int>> stream, int length) async {
    final file = File(targetPath);
    final output = file.openWrite(mode: FileMode.writeOnlyAppend);
    var count = 0;
    print('write bigin: $targetPath');
    await for (final data in stream){
      count += data.length;
      var progress = ((count / length) * 100).ceil();
      output.add(data);
    }
    await output.flush();
    await output.close();
    print('write complete: $targetPath');
  }

  Future<bool> _muxVideoAndAudio(String outputFilePath, String videoPath, String audioPath)async{
    File(outputFilePath);
    print('mix video and audio: $outputFilePath');
    bool isSuccess = false;
    await FFmpegKit.execute('-i "$videoPath" -i "$audioPath" -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 "$outputFilePath"').then((session) async {
      final returnCode = await session.getReturnCode();
      if(ReturnCode.isSuccess(returnCode)){
        print('save video succes');
        isSuccess = true;
      }
      else {
        print('save video error');
        isSuccess = false;
      }
    });

    return isSuccess;
  }
}