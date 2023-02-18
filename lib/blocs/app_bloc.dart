import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:video_playbacker/dtos/loading_state.dart';

import '../dtos/video.dart';
import '../repositories/video_repository.dart';

class AppBloc{
  final _videoRepository = VideoRepository();

  final _saveVideoProgressController = BehaviorSubject<LoadingState<void>>();

  Stream<LoadingState<void>> get onSaveVideoProgress => _saveVideoProgressController.stream;

  final _videoListController = BehaviorSubject<LoadingState<List<Video>>>.seeded(const LoadingState.completed([]));

  Stream<LoadingState<List<Video>>> get videoList => _videoListController.stream;

  void saveVideoByUrl(String url){
      _videoRepository.saveVideoByUrl(url).listen((event) {
      _saveVideoProgressController.sink.add(event);
    });
  }

  void getAllVideos() async{
    _videoListController.sink.add(LoadingState.completed(await _videoRepository.getAllVideos()) );
  }

  void dispose(){
    _saveVideoProgressController.close();
    _videoListController.close();
  }
}