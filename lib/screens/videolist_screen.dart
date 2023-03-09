import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:video_playbacker/dtos/loading_state.dart';
import 'package:video_playbacker/dtos/video.dart';
import 'package:video_playbacker/screens/popupmenu_button_builder.dart';
import 'package:video_playbacker/screens/video_categorization_screen.dart';
import 'package:video_playbacker/screens/video_player_handler.dart';
import 'package:video_playbacker/screens/video_player_screen.dart';

import '../blocs/app_bloc.dart';
import '../dtos/video_category.dart';
import 'videolist_item_widget.dart';

class VideoListScreen extends StatefulWidget {
  final VideoCategory? videoCategory;
  const VideoListScreen({Key? key, this.videoCategory}) : super(key: key);

  @override
  _WarpperStatelessState createState() => _WarpperStatelessState();
}

// rootNavigator以外からrootNavigatorにwidgetをpushするとプッシュしたwidgetが更新されるバグ？があるため、statefulWidgetでラップしてこの問題を対処する
class _WarpperStatelessState extends State<VideoListScreen> {
  late WrappedVideoListScreen screen;

  @override
  void initState() {
    super.initState();
    screen = WrappedVideoListScreen(videoCategory: widget.videoCategory);
  }

  @override
  Widget build(BuildContext context) {
    // return tabA;
    return screen;
  }

  @override
  void didUpdateWidget(VideoListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // setState(() {});
  }
}

class WrappedVideoListScreen extends StatelessWidget{
  final VideoCategory? videoCategory;

  const WrappedVideoListScreen({Key? key, this.videoCategory}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBloc = GetIt.I<AppBloc>();

    appBloc.getVideos(videoCategory: videoCategory);

    return Scaffold(
      appBar: AppBar(title: Text(videoCategory?.name ?? "すべてのビデオ"),
                     actions: videoCategory != null ? [IconButton(onPressed: (){
                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => VideoCategorizationScreen(videoCategory: videoCategory!,)))
                      .then((value) => {
                        appBloc.getVideos(videoCategory: videoCategory)
                      });
                     }, icon: const Icon(Icons.add))] : null,
                     leading: IconButton(icon: const Icon(Icons.arrow_back),
                     onPressed: () {Navigator.pop(context);},)),
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
                    final video = content.elementAt(index);

                    final popupMenuButtonBuilder = PopupMenuButtonBuilder();
                    popupMenuButtonBuilder.addMenu(const Text('編集'), () {});
                    if(videoCategory != null){
                      popupMenuButtonBuilder.addMenu(const Text('カテゴリから除外'), () {
                        showDialog(context: context, builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text("確認"),
                                                        content: Text('タイトル："${video.title}"を\nカテゴリ："${videoCategory!.name}"\nから除外します。本当にいいですか?'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text('いいえ'),
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: const Text('はい'),
                                                            onPressed: () {
                                                              appBloc.removeVideoCategorization(video, videoCategory!);
                                                              appBloc.getVideos(videoCategory: videoCategory);
                                                              Navigator.pop(context);
                                                            },
                                                          )
                                                        ],
                                                      );
                                                    });
                      });
                    }
                    popupMenuButtonBuilder.addMenu(const Text('削除', style: TextStyle(color: Colors.red)),
                                                   () {
                                                    showDialog(context: context, builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text("確認"),
                                                        content: Text('タイトル:"${video.title}"を削除します。本当にいいですか?'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text('いいえ'),
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: const Text('はい'),
                                                            onPressed: () {
                                                              appBloc.deleteVideo(video);
                                                              appBloc.getVideos(videoCategory: videoCategory);
                                                              Navigator.pop(context);
                                                            },
                                                          )
                                                        ],
                                                      );
                                                    });
                                                   });

                    return GestureDetector(
                      child: VideoListItemsWidget(video: content.elementAt(index), videoCategory: videoCategory,
                        popupMenuButton: popupMenuButtonBuilder.build(),
                        onTap: () {
                          GetIt.I<VideoPlayerHandler>().moveToTargetVideo(video.id);
                          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => VideoPlayerScreen(video)));
                        },
                        ),
                      );
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