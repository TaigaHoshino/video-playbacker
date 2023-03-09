import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:video_playbacker/screens/popupmenu_button_builder.dart';
import 'package:video_playbacker/screens/videolist_screen.dart';

import '../blocs/app_bloc.dart';
import '../dtos/loading_state.dart';
import '../dtos/video_category.dart';

class VideoCategoryListScreen extends StatelessWidget {
  const VideoCategoryListScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final appBloc = GetIt.I<AppBloc>();

    appBloc.getAllVideoCategories();

    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: () {
          String text = "";
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: const Text("カテゴリの追加"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const Text("カテゴリ名："),
                TextField(onChanged: (value) {
                  text = value;
                })
              ],),
              actions: <Widget>[
                TextButton(
                  child: const Text('キャンセル'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text('追加'),
                  onPressed: () async {
                    Navigator.pop(context);
                    await appBloc.addVideoCategory(text);
                    await appBloc.getAllVideoCategories();
                  },
                )
              ],
            );
          });
        }, icon: const Icon(Icons.add))
        ],),
      body: ListView(children: [
        ListTile(title: const Text('すべてのビデオ'),
          onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => VideoListScreen()));}
        ),
        StreamBuilder<LoadingState<List<VideoCategory>>>(
          stream: appBloc.videoCategoryList,
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
                    return VideoCategoryListItemWidget(videoCategory: content.elementAt(index));
                  },
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  )
              }),
              error: ((_) {
                
              }));
            return widget;
          }
        )
      ],)   
    );
  }
}

class VideoCategoryListItemWidget extends StatelessWidget {

  final VideoCategory videoCategory;

  const VideoCategoryListItemWidget({Key? key, required this.videoCategory}): super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final appBloc = GetIt.I<AppBloc>();
    final popupMenuButtonBuilder = PopupMenuButtonBuilder();
    popupMenuButtonBuilder.addMenu(const Text('編集'),
                                   (){});
    popupMenuButtonBuilder.addMenu(const Text('削除', style: TextStyle(color: Colors.red)),
                                   (){
                                    showDialog(context: context, builder: (context) {
                                      return AlertDialog(
                                        title: const Text("確認"),
                                        content: Text('カテゴリ:"${videoCategory.name}"を削除します。本当にいいですか?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('いいえ'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('はい'),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              await appBloc.deleteVideoCategory(videoCategory);
                                              await appBloc.getAllVideoCategories();
                                            },
                                          )
                                        ],
                                      );
                                   });});

    return ListTile(
      title: Text(videoCategory.name, overflow: TextOverflow.ellipsis),
      trailing: popupMenuButtonBuilder.build(),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => VideoListScreen(videoCategory: videoCategory)));
      }
    );
  }
}