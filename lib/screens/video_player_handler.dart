import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_player/video_player.dart';

import '../dtos/video.dart';

class VideoPlayerHandler extends BaseAudioHandler with QueueHandler {
  List<_VideoItem> _items = [];
  int _currentMediaItemIndex = 0;

  bool _isStopped = false;
  VideoPlayerController? _controller;
  Duration? _previousPosition;
  final BehaviorSubject<VideoPlayerController?> _controllerSubject =
      BehaviorSubject.seeded(null);

  Stream<VideoPlayerController?> get controllerStream =>
      _controllerSubject.stream;

  Future<void> setPlayList(List<Video> videos) async {

    if(!_isStopped){
      stop();
    }

    if(videos.isEmpty){
      return;
    }

    _items = [];
    for(final video in videos){
      _items.add(_VideoItem(video));
    } 

    _currentMediaItemIndex = 0;

    await _reinitController();
  }

  Future<void> moveToTargetVideo(int videoId) async {
    if(!_isStopped){
      stop();
    }

    bool notFoundFlag = true;

    for(int i=0; i<_items.length; i++){
      if(_items[i].videoId == videoId){
        _currentMediaItemIndex = i;
        notFoundFlag = false;
      }
    }

    if(notFoundFlag){
      // TODO: 何かエラーを吐く
      return;
    }

    await _reinitController();
  }

  // In this simple example, we handle only 4 actions: play, pause, seek and
  // stop. Any button press from the Flutter UI, notification, lock screen or
  // headset will be routed through to these 4 methods so that you can handle
  // your audio playback logic in one place.

  @override
  Future<void> play() => _controller!.play();

  @override
  Future<void> pause() => _controller!.pause();

  @override
  Future<void> seek(Duration position) => _controller!.seekTo(position);

  @override
  Future<void> stop() async {
    _controller?.pause();
    await super.stop();
    _isStopped = true;
  }

  @override
  Future<void> skipToNext() async {
    if (_currentMediaItemIndex == _items.length - 1) return;
    _currentMediaItemIndex++;
    await _reinitController();
  }

  @override
  Future<void> skipToPrevious() async {
    if (_currentMediaItemIndex == 0) return;
    _currentMediaItemIndex--;
    await _reinitController();
  }

  Future<void> _reinitController() async {
    final previousController = _controller;
    previousController?.removeListener(_broadcastState);
    previousController?.pause();
    mediaItem.add(_items[_currentMediaItemIndex]);
    _previousPosition = null;
    _controller = VideoPlayerController.file(
      File(_items[_currentMediaItemIndex].videoPath),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: false,
        allowBackgroundPlayback: false,
      ),
    );

    _controllerSubject.add(_controller);
    _controller?.setLooping(true);
    _controller?.initialize();
    _controller?.addListener(_broadcastState);
    _controller?.play();
    Future<void>.delayed(
      const Duration(milliseconds: 100),
      () => previousController?.dispose(),
    );
  }

  /// Broadcasts the current state to all clients.
  Future<void> _broadcastState() async {
    final videoControllerValue = _controller?.value;

    if (videoControllerValue?.isPlaying ?? false) _isStopped = false;
    if (_isStopped) return;
    final AudioProcessingState processingState;
    if (videoControllerValue == null) {
      processingState = AudioProcessingState.idle;
    } else if (videoControllerValue.isBuffering) {
      processingState = AudioProcessingState.buffering;
    } else if (!videoControllerValue.isInitialized) {
      processingState = AudioProcessingState.loading;
    } else if (videoControllerValue.duration.inMilliseconds -
            videoControllerValue.position.inMilliseconds <
        100) {
      processingState = AudioProcessingState.completed;
    } else if (videoControllerValue.isInitialized) {
      processingState = AudioProcessingState.ready;
    } else {
      if (!videoControllerValue.hasError) {
        throw Exception('Unknown processing state');
      }
      processingState = AudioProcessingState.error;
    }
    final previousPositionInMilliseconds = _previousPosition?.inMilliseconds;
    final currentPositionInMilliseconds =
        videoControllerValue?.position.inMilliseconds;
    int? diff;
    if (previousPositionInMilliseconds != null &&
        currentPositionInMilliseconds != null) {
      diff = currentPositionInMilliseconds - previousPositionInMilliseconds;
    }
    _previousPosition = videoControllerValue?.position;
    final newState = PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (videoControllerValue?.isPlaying ?? false)
          MediaControl.pause
        else
          MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      bufferedPosition: Duration.zero,
      updatePosition: (diff != null && diff > 0 && diff < 600)
          ? playbackState.value.updatePosition
          : videoControllerValue?.position ?? Duration.zero,
      playing: videoControllerValue?.isPlaying ?? false,
      processingState: processingState,
    );
    playbackState.add(newState);
  }
}

class _VideoItem extends MediaItem {

  final int videoId;
  final String videoPath;

  _VideoItem(Video video): videoId = video.id, videoPath = video.videoPath, super(id: video.id.toString(), title: video.title, 
  artUri: Uri.parse('https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),);
}