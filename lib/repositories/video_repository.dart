import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../databases/database.dart';
import '../dtos/loading_state.dart';

class VideoRepository {
  final _database = Database();

  static const _videoFolder = "video";
  static const _thumbnailFolder = "thumbnail";

  // ローカルDBとアプリ内ディレクトリに動画の情報を保存する
  // 動画とサムネイルは指定したディレクトリに'DBに保存される動画ID.拡張子'で保存される
  Stream<LoadingState<Video>> saveVideoByUrl(String url) async* {
    final youtubeExplode = YoutubeExplode();
    final video = await youtubeExplode.videos.get(url);

    final manifest = await youtubeExplode.videos.streamsClient.getManifest(url);
    final streams = manifest.muxed;
    final audio = streams.first;
    final audioStream = youtubeExplode.videos.streamsClient.get(audio);

    final videoDto = await _database.createEmptyVideo();

    final fileName = '${videoDto.id}.${audio.container.name.toString()}';

    final dir = await getApplicationDocumentsDirectory();
    final path = dir.path;
    final directory = Directory('$path/$_videoFolder/');
    await directory.create(recursive: true);
    final file = File('$path/$_videoFolder/$fileName');
    final output = file.openWrite(mode: FileMode.writeOnlyAppend);
    var len = audio.size.totalBytes;
    var count = 0;
    var msg = 'Downloading ${video.title}.${audio.container.name}';
    stdout.writeln(msg);
    await for (final data in audioStream){
      count += data.length;
      var progress = ((count / len) * 100).ceil();
      yield LoadingState.loading(null, progress);
      print(progress);
      output.add(data);
    }
    await output.flush();
    await output.close();

    _database.saveVideo(videoDto);
  }
}