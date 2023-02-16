import 'dart:async';

import 'package:video_playbacker/dtos/loading_state.dart';

class AppBloc{

  final _saveVideoActionController = StreamController<String>();

  Sink<void> get saveVideoByUrl => _saveVideoActionController.sink;

  final _saveVideoProgressController = StreamController<LoadingState<int>>();

  Stream<LoadingState<int>> get onSaveVideoProgress => _saveVideoProgressController.stream;

  AppBloc(){
    _saveVideoActionController.stream.listen((url) {
      _saveVideoProgressController.sink.add(const LoadingState.completed(100));
    });
  }

  void dispose(){
    _saveVideoActionController.close();
    _saveVideoProgressController.close();
  }
}