import 'package:flutter/material.dart';

class VideoListScreen extends StatelessWidget{
  const VideoListScreen({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          VideoListItemsWidget(title: "ビデオ1"),
          VideoListItemsWidget(title: "ビデオ2"),
          VideoListItemsWidget(title: "ビデオ3"),
        ],
      ),
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