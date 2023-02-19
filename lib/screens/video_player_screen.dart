import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../dtos/video.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Video _video;

  VideoPlayerScreen(this._video);
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState(_video);
}

class _VideoPlayerPageState extends State<VideoPlayerScreen> {
  final Video _video;
  late VideoPlayerController _controller;

  _VideoPlayerPageState(this._video);

  @override
  void initState() {
    _controller = VideoPlayerController.file(File(_video.videoPath));
    _controller.initialize().then((_) {
      // 最初のフレームを描画するため初期化後に更新
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // 動画を表示
              child: VideoPlayer(_controller),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    // 動画を最初から再生
                    _controller
                        .seekTo(Duration.zero)
                        .then((_) => _controller.play());
                  },
                  icon: Icon(Icons.refresh),
                ),
                IconButton(
                  onPressed: () {
                    // 動画を再生
                    _controller.play();
                  },
                  icon: Icon(Icons.play_arrow),
                ),
                IconButton(
                  onPressed: () {
                    // 動画を一時停止
                    _controller.pause();
                  },
                  icon: Icon(Icons.pause),
                ),
              ],
            ),
          ],
        ),
      );
  }
}