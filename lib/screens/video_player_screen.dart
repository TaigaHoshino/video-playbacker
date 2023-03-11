import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:video_playbacker/screens/video_player_handler.dart';
import 'package:video_player/video_player.dart';

import '../dtos/video.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Video _video;

  VideoPlayerScreen(this._video);
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerScreen> {
  final VideoPlayerHandler _videoHandler = GetIt.I<VideoPlayerHandler>();
  ChewieController? _chewieController;

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: AppBar(
        title: Text('サンプル'),
      ),
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(
              child: 
                StreamBuilder<VideoPlayerController?>(
                  stream: _videoHandler.controllerStream,
                  builder: (context, snapshot) {
                    final controller = snapshot.data;
                    if (controller == null) return const Text('With remote mp4');
                    controller.addListener(() {
                      if (controller.value.position == controller.value.duration){
                        _videoHandler.skipToNext();
                      }
                    });
                    ChewieController? previousController = _chewieController;
                    _chewieController = ChewieController(
                      videoPlayerController: controller,
                      aspectRatio: controller.value.aspectRatio,
                      autoPlay: true,
                      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp]);
                    Future<void>.delayed(
                      const Duration(milliseconds: 100),
                      () => previousController?.dispose(),
                    );
                    return Chewie(controller: _chewieController!);
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:[
                IconButton(icon: const Icon(Icons.skip_previous), onPressed: () {_videoHandler.skipToPrevious();}),
                IconButton(icon: const Icon(Icons.skip_next), onPressed: () {_videoHandler.skipToNext();})]
            )
          ]
        ),
      )
    );
    
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController?.pause();
    _chewieController?.dispose();
  }
}