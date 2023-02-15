import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoDownloadFunction{
  static void downloadVideoBy(String url) async{
    final youtubeExplode = YoutubeExplode();
    final video = await youtubeExplode.videos.get(url);

    final manifest = await youtubeExplode.videos.streamsClient.getManifest(url);
    final streams = manifest.muxed;
    final audio = streams.first;
    final audioStream = youtubeExplode.videos.streamsClient.get(audio);
    final fileName = '${video.title}.${audio.container.name.toString()}'
      .replaceAll(r'\', '')
      .replaceAll('/', '')
      .replaceAll('*', '')
      .replaceAll('?', '')
      .replaceAll('"', '')
      .replaceAll('<', '')
      .replaceAll('>', '')
      .replaceAll('|', '');
    
    final dir = await getApplicationDocumentsDirectory();
    final path = dir.path;
    final directory = Directory('$path/video/');
    await directory.create(recursive: true);
    final file = File('$path/video/$fileName');
    final output = file.openWrite(mode: FileMode.writeOnlyAppend);
    var len = audio.size.totalBytes;
    var count = 0;
    var msg = 'Downloading ${video.title}.${audio.container.name}';
    stdout.writeln(msg);
    await for (final data in audioStream){
      count += data.length;
      var progress = ((count / len) * 100).ceil();
      print(progress);
      output.add(data);
    }
    await output.flush();
    await output.close();
  }
}