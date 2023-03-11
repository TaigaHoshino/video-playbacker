import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:video_playbacker/blocs/app_bloc.dart';
import 'package:video_playbacker/repositories/video_repository.dart';
import 'package:video_playbacker/screens/video_player_handler.dart';
import 'screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);

  final videoPlayerHandler = await AudioService.init(
    builder: () => VideoPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.tanukis.videoPlayBacker',
      androidNotificationChannelName: 'Audio playback',
      androidStopForegroundOnPause: true,
    )
  );
  final videoRepository = VideoRepository();
  videoRepository.init();

  // TODO: DIライブラリとして`GetIt`を使用しているが、ライブラリを変更する可能性を考えてDIライブラリをラップするオブジェクトを作った方がよい
  GetIt.I.registerSingleton(videoPlayerHandler);
  GetIt.I.registerSingleton(AppBloc(videoRepository));

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
      home: const MainScreen(),
    );
  }
}