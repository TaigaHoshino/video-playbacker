import 'package:flutter/material.dart';
import 'package:video_playbacker/blocs/bloc_provider.dart';

class CaptureScreen extends StatelessWidget{
  const CaptureScreen({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UrlForm()
    );
  }
}

class UrlForm extends StatefulWidget {
  @override
  _UrlFormState createState() => _UrlFormState();
}

class _UrlFormState extends State<UrlForm> {
  @override
  Widget build(BuildContext context){
    String _text = "";

    final appBloc = BlocProvider.of(context)!.bloc;

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("動画URLを入力"),
          TextField(onChanged: (text) { _text = text;},),
          OutlinedButton(onPressed: () {
            appBloc.saveVideoByUrl(_text);
          }, child: Text('検索'))]),
          );
  }
}