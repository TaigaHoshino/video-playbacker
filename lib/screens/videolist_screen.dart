import 'package:flutter/material.dart';
import 'package:video_playbacker/blocs/bloc_provider.dart';
import 'package:video_playbacker/dtos/loading_state.dart';
import 'package:video_playbacker/dtos/video.dart';
import 'package:video_playbacker/screens/video_player_handler.dart';
import 'package:video_playbacker/screens/video_player_screen.dart';

class VideoListScreen extends StatelessWidget{
  const VideoListScreen({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of(context)!.bloc;

    appBloc.getAllVideos();

    return Scaffold(
      body: 
        StreamBuilder<LoadingState<List<Video>>>(
          stream: appBloc.videoList,
          builder: (context, snapshot){
            Widget widget = Text("");

            if(!snapshot.hasData){
              return widget;
            }

            snapshot.data!.when(
              loading: (_, __) => {},
              completed: ((content) => {
                VideoPlayerHandler.instance!.setPlayList(content),
                widget = ListView.builder(
                  itemCount: content.length,
                  itemBuilder: (context, index) {
                    return VideoListItemsWidget(video: content.elementAt(index));
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

  final Video video;
  String _title = "";

  VideoListItemsWidget({Key? key, required this.video}): super(key: key){
    _title = video.id.toString();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(child: ListTile(
      title: Text(_title, textScaleFactor: 2),
      onTap: () {
        print(_title);
        VideoPlayerHandler.instance!.moveToTargetVideo(video.id);
        Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(video)));
      }
    ));
  }
}