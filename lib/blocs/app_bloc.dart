import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:video_playbacker/dtos/loading_state.dart';

import '../dtos/video.dart';
import '../dtos/video_category.dart';
import '../repositories/video_repository.dart';

class AppBloc{
  final VideoRepository _videoRepository;

  final _saveVideoProgressController = BehaviorSubject<LoadingState<Video>>();

  Stream<LoadingState<Video>> get onSaveVideoProgress => _saveVideoProgressController.stream;

  final _videoListController = BehaviorSubject<LoadingState<List<Video>>>.seeded(const LoadingState.completed([]));

  Stream<LoadingState<List<Video>>> get videoList => _videoListController.stream;

  final _videoCategoryListController = BehaviorSubject<LoadingState<List<VideoCategory>>>.seeded(const LoadingState.completed([]));

  Stream<LoadingState<List<VideoCategory>>> get videoCategoryList => _videoCategoryListController.stream;

  AppBloc(VideoRepository videoRepository): _videoRepository = videoRepository;

  Future<void> saveVideoByUrl(String url) async{
    _saveVideoProgressController.sink.add(const LoadingState.loading(null, null));
    try{
      final video = await _videoRepository.saveVideoByUrl(url);
      _saveVideoProgressController.sink.add(LoadingState.completed(video));
    }
    on Exception catch (e){
      print(e);
      _saveVideoProgressController.sink.add(LoadingState.error(e));
    }
    catch (e) {
      print(e);
      _saveVideoProgressController.sink.add(LoadingState.error(Exception('Enexpected error is happened')));
    }
  }

  // ビデオカテゴリを指定しない場合、全てのビデオを取得する
  Future<void> getVideos({VideoCategory? videoCategory}) async{
    _videoListController.sink.add(LoadingState.completed(await _videoRepository.getAllVideos()) );
  }

  // 万が一削除に失敗しても次回起動時に再度削除を実施するため、削除可否のコールバックは返さない
  Future<void> deleteVideo(Video video) async {
    try {
      _videoRepository.deleteVideo(video);
    }
    catch (e) {
      print(e);
    }
  }

  Future<void> addVideoCategory(String name) async {
    await _videoRepository.addVideoCategory(name);
  }

  Future<void> getAllVideoCategories() async {
    _videoCategoryListController.sink.add(LoadingState.completed(await _videoRepository.getAllVideoCategory()));
  }

  Future<void> deleteVideoCategory(VideoCategory category) async {
    await _videoRepository.deleteVideoCategory(category);
  }

  void dispose(){
    _saveVideoProgressController.close();
    _videoListController.close();
    _videoCategoryListController.close();
  }
}