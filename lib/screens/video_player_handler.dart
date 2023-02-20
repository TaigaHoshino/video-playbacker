import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerHandler extends BaseAudioHandler with QueueHandler {
  static late final VideoPlayerHandler? instance;

  static final _items = [
    MediaItem(
      id: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      album: "Bee",
      title: "Bee",
      artist: "Bee",
      duration: const Duration(milliseconds: 4000),
      artUri: Uri.parse(
          'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
    ),
    MediaItem(
      id: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      album: "Butterfly",
      title: "Butterfly",
      artist: "Butterfly",
      duration: const Duration(milliseconds: 7000),
      artUri: Uri.parse(
          'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
    ),
    MediaItem(
      id: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      album: "Bee",
      title: "Bee",
      artist: "Bee",
      duration: const Duration(milliseconds: 4000),
      artUri: Uri.parse(
          'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
    ),
    MediaItem(
      id: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      album: "Butterfly",
      title: "Butterfly",
      artist: "Butterfly",
      duration: const Duration(milliseconds: 7000),
      artUri: Uri.parse(
          'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
    ),
  ];
  int _currentMediaItemIndex = 0;

  bool _isStopped = false;
  VideoPlayerController? _controller;
  Duration? _previousPosition;
  final BehaviorSubject<VideoPlayerController?> _controllerSubject =
      BehaviorSubject.seeded(null);

  Stream<VideoPlayerController?> get controllerStream =>
      _controllerSubject.stream;

  static void initHandler() async {
    instance = await AudioService.init(
    builder: () => VideoPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.tanukis.videoPlayBacker',
      androidNotificationChannelName: 'Audio playback',
      androidStopForegroundOnPause: true,
    ),
  );
  }

  /// Initialise our video handler.
  VideoPlayerHandler() {
    _reinitController();
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
    _controller = VideoPlayerController.network(
      _items[_currentMediaItemIndex].id,
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