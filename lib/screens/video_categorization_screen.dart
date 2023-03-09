import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:video_playbacker/blocs/app_bloc.dart';
import 'package:video_playbacker/screens/videolist_item_widget.dart';

import '../dtos/loading_state.dart';
import '../dtos/video.dart';
import '../dtos/video_category.dart';


class VideoCategorizationScreen extends StatelessWidget {

  final VideoCategory videoCategory;
  final List<Video> _selectedVideo = [];

  VideoCategorizationScreen({Key? key, required this.videoCategory}): super(key: key);

  @override
  Widget build(BuildContext context) {

    final appBloc = GetIt.I<AppBloc>();
    appBloc.getVideos(videoCategory: videoCategory, isCategoryExcluded: true);

    return Scaffold(
      appBar: AppBar(title: Text('${videoCategory.name}に追加'), leading: IconButton(icon: const Icon(Icons.arrow_back),onPressed: () {Navigator.pop(context);})),
      body:SafeArea(child: Column(children: [
        Expanded(
        child: StreamBuilder<LoadingState<List<Video>>>(
            stream: appBloc.videoList,
            builder: (context, snapshot){
              Widget widget = const Text("");

              if(!snapshot.hasData){
                return widget;
              }

              snapshot.data!.when(
                loading: (_, __) => {},
                completed: ((content) => {
                  widget = ListView.builder(
                    itemCount: content.length,
                    itemBuilder: (context, index) {
                      final video = content.elementAt(index);
                      return GestureDetector(
                        child: VideoListItemsWidget(video: video, videoCategory: videoCategory, selectedColor: Colors.blue, onTap: () {
                          if(_selectedVideo.contains(video)) {
                            _selectedVideo.remove(video);
                          }
                          else {
                            _selectedVideo.add(video);
                          }
                        }),
                        );
                    }
                  )
                }),
                error: ((_) {
                  
                }));
              return widget;
            }
          ),
        ),
        SizedBox(
          height: 50,
          child: TextButton(onPressed: () async {
              Navigator.pop(context);
              for(final video in _selectedVideo) {
                await appBloc.addVideoCategorization(video, videoCategory);
              }
            }, child: const Text('カテゴリに追加'))
        )
        
      ],)   
      ));
  }

}