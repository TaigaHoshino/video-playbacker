import 'package:flutter/material.dart';
import 'package:video_playbacker/blocs/bloc_provider.dart';
import 'package:video_playbacker/dtos/loading_state.dart';
import 'package:video_playbacker/dtos/video.dart';

class VideoListScreen extends StatelessWidget{
  const VideoListScreen({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final appModel = BlocProvider.of(context)!.bloc;

    appModel.getAllVideos();

    return Scaffold(
      body: 
        StreamBuilder<LoadingState<List<Video>>>(
          stream: appModel.videoList,
          builder: (context, snapshot){
            Widget widget = Text("");

            if(!snapshot.hasData){
              return widget;
            }

            snapshot.data!.when(
              loading: (_, __) => {},
              completed: ((content) => {
                widget = ListView.builder(
                  itemCount: content.length,
                  itemBuilder: (context, index) {
                    return VideoListItemsWidget(title: content.elementAt(index).id.toString());
                  }
                  )
              }),
              error: ((_) {
                
              }));
            return widget;
          }
        )
      );
  }
}

class VideoListItemsWidget extends StatelessWidget {

  String _title = "";

  VideoListItemsWidget({Key? key, required String title}): super(key: key){
    _title = title;
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(child: ListTile(
      title: Text(_title, textScaleFactor: 2),
      onTap: () {
        print(_title);
      }
    ));
  }
}