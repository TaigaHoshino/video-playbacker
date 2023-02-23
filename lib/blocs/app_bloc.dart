import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import 'package:video_playbacker/dtos/loading_state.dart';

import '../dtos/video.dart';
import '../repositories/video_repository.dart';

class AppBloc{
  final _videoRepository;

  final _saveVideoProgressController = BehaviorSubject<LoadingState<Video>>();

  Stream<LoadingState<Video>> get onSaveVideoProgress => _saveVideoProgressController.stream;

  final _videoListController = BehaviorSubject<LoadingState<List<Video>>>.seeded(const LoadingState.completed([]));

  Stream<LoadingState<List<Video>>> get videoList => _videoListController.stream;

  AppBloc(VideoRepository videoRepository): _videoRepository = videoRepository;

  void saveVideoByUrl(String url) async{
    _saveVideoProgressController.sink.add(const LoadingState.loading(null, null));
    try{
      final video = await _videoRepository.saveVideoByUrl(url);
      _saveVideoProgressController.sink.add(LoadingState.completed(video));
    }
    on Exception catch (e){
      _saveVideoProgressController.sink.add(LoadingState.error(e));
    }
    catch (e) {
      _saveVideoProgressController.sink.add(LoadingState.error(Exception('Enexpected error is happened')));
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