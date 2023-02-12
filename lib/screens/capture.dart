import 'package:flutter/material.dart';

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
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("動画URLを入力"),
          TextField(),
          OutlinedButton(onPressed: () {}, child: Text('検索'))]),
          );
  }
}