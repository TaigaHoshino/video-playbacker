import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../blocs/app_bloc.dart';
import '../dtos/video.dart';

class EditVideoInfoWidget extends StatefulWidget {
  final AppBloc _appBloc = GetIt.I<AppBloc>(); 
  final Video video;
  String _title = "";

  EditVideoInfoWidget({Key? key, required this.video}): super(key: key) {
    _title = video.title;
  }

  @override
  _EditVideoInfoWidgetState createState() => _EditVideoInfoWidgetState();

  Future<void> saveVideoInfo() async {
    video.title = _title;
    await _appBloc.updateVideo(video);
  }
}

class _EditVideoInfoWidgetState extends State<EditVideoInfoWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('動画タイトル：'),
        TextFormField(initialValue: widget._title ,onChanged: (text) {widget._title = text;},)
      ],
    );
  }
}