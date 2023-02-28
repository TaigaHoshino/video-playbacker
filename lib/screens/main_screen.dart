import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_playbacker/screens/capture_screen.dart';
import 'package:video_playbacker/screens/video_categorylist_screen.dart';
import 'package:video_playbacker/screens/videolist_screen.dart';

class MainScreen extends StatefulWidget {

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  _MainScreenState();

  int _currentIndex = 0;
  final _pageWidgets = [
    const CaptureScreen(),
    const VideoCategoryListScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('動画再生'),
      ),
      body: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.download), label: 'Download'),
            BottomNavigationBarItem(icon: Icon(Icons.video_collection), label: 'Video')
          ],
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(builder: (context) {
            return CupertinoPageScaffold(
              child: _pageWidgets[index]
            );
          });
        },
      )
    );
  }

  void _onItemTapped(int index) => setState(() => _currentIndex = index );
}