import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        OutlinedButton(onPressed: () {
            _videoHandler.stop();
            Navigator.pop(context);
          }, child: Text('検索')),
        const Text('With remote mp4'),
        StreamBuilder<VideoPlayerController?>(
          stream: _videoHandler.controllerStream,
          builder: (context, snapshot) {
            final controller = snapshot.data;
            if (controller == null) return const Text('With remote mp4');
            return AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            );
          },
        ),
        SizedBox(
          height: 100.0,
          child: StreamBuilder<bool>(
            stream: _videoHandler.playbackState
                .map((state) => state.playing)
                .distinct(),
            builder: (context, snapshot) {
              final playing = snapshot.data ?? false;

              return GestureDetector(
                onTap: (playing) ? _videoHandler.pause : _videoHandler.play,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 50),
                  reverseDuration: const Duration(milliseconds: 200),
                  child: Container(
                    color: Colors.black26,
                    child: Center(
                      child: Icon(
                        playing ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 100.0,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}