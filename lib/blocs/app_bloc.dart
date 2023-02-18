import 'dart:async';

import 'package:video_playbacker/dtos/loading_state.dart';

import '../dtos/video.dart';
import '../repositories/video_repository.dart';

class AppBloc{
  final _videoRepository = VideoRepository();

  final _saveVideoActionController = StreamController<String>();

  Sink<String> get saveVideoByUrl => _saveVideoActionController.sink;

  final _saveVideoProgressController = StreamController<LoadingState<void>>();

  Stream<LoadingState<void>> get onSaveVideoProgress => _saveVideoProgressController.stream;

  AppBloc(){
    _saveVideoActionController.stream.listen((url) {
      _saveVideoProgressController.sink.add(const LoadingState.completed(null));
    });
  }

  void dispose(){
    _videoRepository.saveVideoByUrl("https://www.youtube.com/watch?v=UzkiLRom6J8").listen((event) {
      event.when(loading: (content, progress) => print(progress), completed: ((content) => {}), error: (error) => {});
    });
  }
}