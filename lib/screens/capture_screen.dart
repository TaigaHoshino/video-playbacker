import 'package:flutter/material.dart';
import 'package:video_playbacker/blocs/bloc_provider.dart';
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

    final appBloc = BlocProvider.of(context)!.bloc;

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("動画URLを入力"),
          TextField(onChanged: (text) { _text = text;},),
          OutlinedButton(onPressed: () {
            appBloc.saveVideoByUrl(_text);
            showDialog(context: context, builder: (context) {
              return AlertDialog(
                title:  const Text('ダウンロード中'),
                content: StreamBuilder<LoadingState<void>>(
                  stream: appBloc.onSaveVideoProgress,
                  builder: (context, snapshot){
                    Widget widget = const Text("");

                    if(!snapshot.hasData){
                      return widget;
                    }

                    snapshot.data!.when(
                      loading: (_, int? progress) => { 
                        widget = const LinearProgressIndicator()
                      },
                      completed: ((content) => {
                        Navigator.pop(context)
                      }),
                      error: ((_) {
                        widget = const Text("エラーが発生しました");
                      })
                    );
                      return widget;
                  }
                ),
                actions: <Widget>[
                    GestureDetector(
                      child: const Text('キャンセル'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ]
              );
            });
          }, child: const Text('検索'))]),
          );
  }
}