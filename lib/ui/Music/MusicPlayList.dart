import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MusicPlayList extends StatefulWidget {
  const MusicPlayList({Key key}) : super(key: key);

  @override
  _MusicPlayListState createState() => _MusicPlayListState();
}

class _MusicPlayListState extends State<MusicPlayList> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
