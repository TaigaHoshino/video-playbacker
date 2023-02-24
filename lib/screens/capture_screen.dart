import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:video_playbacker/blocs/app_bloc.dart';
import 'package:video_playbacker/dtos/loading_state.dart';

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

    final appBloc = GetIt.I<AppBloc>();

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("動画URLを入力"),
          TextField(onChanged: (text) { _text = text;},),
          OutlinedButton(onPressed: () {
            appBloc.saveVideoByUrl(_text);
            showDialog(context: context, barrierDismissible: false, builder: (context) {
              return AlertDialog(
                content: StreamBuilder<LoadingState<void>>(
                  stream: appBloc.onSaveVideoProgress,
                  builder: (context, snapshot){
                    Widget widget = const Text("");

                    if(!snapshot.hasData){
                      return widget;
                    }

                    snapshot.data!.when(
                      loading: (_, int? progress) => { 
                        widget = Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            Text("ダウンロード中"),
                            LinearProgressIndicator()
                        ],)
                      },
                      completed: ((content) => {
                        widget = Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text("ダウンロードが完了しました"),
                            OutlinedButton(onPressed: () {Navigator.pop(context);}, child: const Text('とじる')),
                        ],)
                      }),
                      error: ((_) => {
                        widget = Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text("エラーが発生しました"),
                            OutlinedButton(onPressed: () {Navigator.pop(context);}, child: const Text('とじる')),
                        ],)
                      })
                    );
                  return widget;
                  }
                ),
              );
            });
          }, child: const Text('検索'))]),
          );
  }
}