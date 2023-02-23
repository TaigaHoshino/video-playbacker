import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:video_playbacker/dtos/loading_state.dart';

import '../dtos/video.dart';
import '../repositories/video_repository.dart';

class AppBloc{
  final _videoRepository = VideoRepository();

  final _saveVideoProgressController = BehaviorSubject<LoadingState<Video>>();

  Stream<LoadingState<Video>> get onSaveVideoProgress => _saveVideoProgressController.stream;

  final _videoListController = BehaviorSubject<LoadingState<List<Video>>>.seeded(const LoadingState.completed([]));

  Stream<LoadingState<List<Video>>> get videoList => _videoListController.stream;

  void saveVideoByUrl(String url) async{
    _saveVideoProgressController.sink.add(const LoadingState.loading(null, null));
    try{
      final video = await _videoRepository.saveVideoByUrl(url);
      _saveVideoProgressController.sink.add(LoadingState.completed(video));
    }
    on Exception catch (e){
      _saveVideoProgressController.sink.add(LoadingState.error(e));
    }
  }

  void getAllVideos() async{
    _videoListController.sink.add(LoadingState.completed(await _videoRepository.getAllVideos()) );
  }

  void dispose(){
    _saveVideoProgressController.close();
    _videoListController.close();
  }
}