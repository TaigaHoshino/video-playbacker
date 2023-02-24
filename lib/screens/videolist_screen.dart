import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:video_playbacker/dtos/loading_state.dart';
import 'package:video_playbacker/dtos/video.dart';
import 'package:video_playbacker/screens/video_player_handler.dart';
import 'package:video_playbacker/screens/video_player_screen.dart';

import '../blocs/app_bloc.dart';

class VideoListScreen extends StatelessWidget{
  const VideoListScreen({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBloc = GetIt.I<AppBloc>();

    appBloc.getAllVideos();

    return Scaffold(
      body: 
        StreamBuilder<LoadingState<List<Video>>>(
          stream: appBloc.videoList,
          builder: (context, snapshot){
            Widget widget = const Text("");

            if(!snapshot.hasData){
              return widget;
            }

            snapshot.data!.when(
              loading: (_, __) => {},
              completed: ((content) => {
                GetIt.I<VideoPlayerHandler>().setPlayList(content),
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

  const VideoListItemsWidget({Key? key, required this.video}): super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(video.title, overflow: TextOverflow.ellipsis),
      subtitle: Text(video.createdAt.toString(), overflow: TextOverflow.ellipsis),
      leading: Container(width:100, height: 100,
        decoration: const BoxDecoration(color: Colors.black), child: Stack(
        children: <Widget>[
          Image.file(File(video.thumbnailPath)),
          Container(
            margin: const EdgeInsets.all(3),
            child: 
              Align(
                alignment: Alignment.bottomRight,
                child: Text(video.durationString, style: const TextStyle(color: Colors.white, backgroundColor: Colors.black), textScaleFactor: 0.8)
              ))
        ]),
      ),
      trailing: PopupMenuButton<int>(
          onSelected: ((value) {
            switch(value) {
              case 1:
                break;
              case 2:
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: const Text("確認"),
                    content: Text('タイトル:"${video.title}"を削除します。本当にいいですか?'),
                    actions: <Widget>[
                      GestureDetector(
                        child: const Text('いいえ'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      GestureDetector(
                        child: const Text('はい'),
                        onTap: () {},
                      )
                    ],
                  );
                });
                break;
            }
          }),
          itemBuilder: (context) => <PopupMenuEntry<int>>[
            const PopupMenuItem(
              value: 1,
              child: Text('編集')
            ),
            const PopupMenuItem(
              value: 2,
              child: Text('削除', style: TextStyle(color: Colors.red))
            )
          ]
        ),
      onTap: () {
        GetIt.I<VideoPlayerHandler>().moveToTargetVideo(video.id);
        Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(video)));
      }
    );
  }
}