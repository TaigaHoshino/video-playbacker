import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:video_playbacker/screens/video_player_handler.dart';
import 'blocs/bloc_holder.dart';
import 'screens/main_screen.dart';

Future<void> main() async {
  VideoPlayerHandler.initHandler();
  final session = await AudioSession.instance;
  session.configure(const AudioSessionConfiguration.music());
  runApp(const VideoPlaybackApp());
}

class VideoPlaybackApp extends StatelessWidget {
  const VideoPlaybackApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '動画再生',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const BlocHolder(child: MainScreen()),
    );
  }
}