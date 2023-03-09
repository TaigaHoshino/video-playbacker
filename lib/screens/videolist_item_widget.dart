import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../blocs/app_bloc.dart';
import '../dtos/video.dart';
import '../dtos/video_category.dart';

class VideoListItemsWidget extends StatefulWidget {
  final Video video;
  final VideoCategory? videoCategory;
  final PopupMenuButton? popupMenuButton;
  final Color? selectedColor;
  bool _isSelected = false; 
  final Function? onTap;

  VideoListItemsWidget({Key? key, required this.video, this.videoCategory, this.popupMenuButton, this.selectedColor, this.onTap}): super(key: key);

  @override
  _VideoListItemsWidgetState createState() => _VideoListItemsWidgetState();
}

class _VideoListItemsWidgetState extends State<VideoListItemsWidget> {
  
  @override
  Widget build(BuildContext context) {

    final appBloc = GetIt.I<AppBloc>();

    return ListTile(
      title: Text(widget.video.title, overflow: TextOverflow.ellipsis),
      subtitle: Text(widget.video.createdAt.toString(), overflow: TextOverflow.ellipsis),
      leading: Container(width:100, height: 100,
        decoration: const BoxDecoration(color: Colors.black), child: Stack(
        children: <Widget>[
          Image.file(File(widget.video.thumbnailPath)),
          Container(
            margin: const EdgeInsets.all(3),
            child: 
              Align(
                alignment: Alignment.bottomRight,
                child: Text(widget.video.durationString, style: const TextStyle(color: Colors.white, backgroundColor: Colors.black), textScaleFactor: 0.8)
              ))
        ]),
      ),
      trailing: widget.popupMenuButton,
      tileColor: widget._isSelected ? widget.selectedColor : null,
      onTap: () {
        setState(() {
          widget._isSelected = !widget._isSelected;
          widget.onTap?.call();
        });
      },
    );
  }
}