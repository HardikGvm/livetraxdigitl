import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:need_resume/need_resume.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tomo_app/Helper/common.dart';
import 'package:tomo_app/ui/server/musicplaylist.dart';
import 'package:tomo_app/widgets/colorloader2.dart';
import 'package:tomo_app/widgets/ibutton3.dart';

//import 'package:audioplayers/audioplayers.dart';
import '../../main.dart';

class MusicPlayList extends StatefulWidget {
  const MusicPlayList({Key key}) : super(key: key);

  @override
  _MusicPlayListState createState() => _MusicPlayListState();
}

class AudioMetadata {
  final String album;
  final String title;
  final String artwork;

  AudioMetadata({
    this.album,
    this.title,
    this.artwork,
  });
}

class _MusicPlayListState extends ResumableState<MusicPlayList> {
  bool _wait = false,dataReady=false;
  var windowWidth;
  var windowHeight;
  bool isChanges = false;
  List<MusicData> list = new List();
  double _show = 0;
  Widget _dialogBody = Container();
  var _playlist;
  AudioPlayer _player;
  List<AudioSource> _mList = List<AudioSource>();

  @override
  void onReady() {
    callAPI();
    super.onReady();
  }

  _waits(bool value) {
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  _error(String error) {
    _waits(false);
    print("Get message here " + error);
    openDialog("${strings.get(158)} $error"); // "Something went wrong. ",
  }

  void callAPI() {
    _waits(true);
    if (list != null && list.length > 0) {
      print(":::Call API:::");
      list.clear();
    }
    _music(1, 5);
  }

  _music(int page, int limit) {
    print("::::Data::::");

    musicList(page, limit, _onSuccessMusicList, _error);
  }

  openDialog(String _text) {
    _dialogBody = Column(
      children: [
        Text(
          _text,
          style: theme.text14,
        ),
        SizedBox(
          height: 40,
        ),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(66), // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: () {
              setState(() {
                _show = 0;
              });
            }),
      ],
    );

    setState(() {
      _show = 1;
    });
  }

  _onSuccessMusicList(List<MusicData> list) {
    _waits(false);
    this.list = list;
    var i;
    /*_mList.add(ClippingAudioSource(
      start: Duration(seconds: 60),
      end: Duration(seconds: 90),
      child: AudioSource.uri(Uri.parse(list[0].music)),
      tag: AudioMetadata(
        album: list[0].title,
        title: list[0].desc,
        artwork: list[0].image,
      ),
    ));*/

    for (int i = 0; i < list.length; i++) {
      print(":::ID::: " + list[i].id.toString());
      _mList.add(AudioSource.uri(
        Uri.parse(list[i].music),
        tag: AudioMetadata(
          album: list[i].title,
          title: list[i].desc,
          artwork: list[i].image,
        ),
      ));
    }

    _playlist = ConcatenatingAudioSource(children: _mList);
    _init();
    setState(() {
      dataReady =true;
    });
  }

  @override
  void initState() {
    _player = AudioPlayer();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);


    super.initState();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      // Catch load errors: 404, invalid url...
      print("Error loading audio source: $e");
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !_wait && _mList.length>0 && dataReady
            ?  Container(color: Colors.black87, child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder<SequenceState>(
                stream: _player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state.sequence.isEmpty ?? true) return SizedBox();
                  final metadata = state.currentSource.tag as AudioMetadata;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          Center(child: Image.network(metadata.artwork)),
                        ),
                      ),
                      Text(metadata.album,
                          style: TextStyle(color: Colors.white)),
                      Text(metadata.title,style: TextStyle(color: Colors.white)),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ControlButtons(_player),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  duration: positionData?.duration ?? Duration.zero,
                  position: positionData?.position ?? Duration.zero,
                  bufferedPosition:
                  positionData?.bufferedPosition ?? Duration.zero,
                  onChangeEnd: (newPosition) {
                    _player.seek(newPosition);
                  },
                );
              },
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                StreamBuilder<LoopMode>(
                  stream: _player.loopModeStream,
                  builder: (context, snapshot) {
                    final loopMode = snapshot.data ?? LoopMode.off;
                    const icons = [
                      Icon(Icons.repeat, color: Colors.grey),
                      Icon(Icons.repeat, color: Colors.orange),
                      Icon(Icons.repeat_one, color: Colors.orange),
                    ];
                    const cycleModes = [
                      LoopMode.off,
                      LoopMode.all,
                      LoopMode.one,
                    ];
                    final index = cycleModes.indexOf(loopMode);
                    return IconButton(
                      icon: icons[index],
                      onPressed: () {
                        _player.setLoopMode(cycleModes[
                        (cycleModes.indexOf(loopMode) + 1) %
                            cycleModes.length]);
                      },
                    );
                  },
                ),
                Expanded(
                  child: Text(
                      "Playlist",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white,fontSize: 20)
                  ),
                ),
                StreamBuilder<bool>(
                  stream: _player.shuffleModeEnabledStream,
                  builder: (context, snapshot) {
                    final shuffleModeEnabled = snapshot.data ?? false;
                    return IconButton(
                      icon: shuffleModeEnabled
                          ? Icon(Icons.shuffle, color: Colors.orange)
                          : Icon(Icons.shuffle, color: Colors.grey),
                      onPressed: () async {
                        final enable = !shuffleModeEnabled;
                        if (enable) {
                          await _player.shuffle();
                        }
                        await _player.setShuffleModeEnabled(enable);
                      },
                    );
                  },
                ),
              ],
            ),
            Container(
              height: 240.0,
              child: StreamBuilder<SequenceState>(
                stream: _player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  final sequence = state?.sequence ?? [];
                  return ListView(
                    /*  onReorder: (int oldIndex, int newIndex) {
                    if (oldIndex < newIndex) newIndex--;
                    _playlist.move(oldIndex, newIndex);
                  },*/

                    children: [
                      for (var i = 0; i < sequence.length; i++)
                      /*  Dismissible(
                        key: ValueKey(sequence[i]),
                        background: Container(
                          color: Colors.redAccent,
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                        onDismissed: (dismissDirection) {
                          _playlist.removeAt(i);
                        },
                        child:*/ Material(
                          color: i == state.currentIndex
                              ? Colors.black87
                              : null,
                          child:
                          ListTile(
                            leading: Image.network(
                              sequence[i].tag.artwork,
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              sequence[i].tag.title,
                              style: TextStyle(color: i == state.currentIndex?Colors.green:Colors.white),
                            ),
                            subtitle: Text(
                              sequence[i].tag.album,
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _player.seek(Duration.zero, index: i);
                              });

                            },
                          )
                      ),
                      //  ),
                    ],
                  );
                },
              ),
            ),
          ],
        )):Container(
          width: windowWidth,
          height: windowHeight,
          child: Center(
            child: ColorLoader2(
              color1: theme.colorPrimary,
              color2: theme.colorCompanion,
              color3: theme.colorPrimary,
            ),
          ),
        )

    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.volume_up,color: Colors.white),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        StreamBuilder<SequenceState>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_previous,color: Colors.white),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {

              return Container(
                margin: EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: CircularProgressIndicator(),
              );

            } else if (playing != true) {

              return IconButton(
                icon: Icon(Icons.play_arrow,color: Colors.white,),
                iconSize: 64.0,
                onPressed: player.play,
              );

            } else if (processingState != ProcessingState.completed) {

              return IconButton(
                icon: Icon(Icons.pause,color: Colors.white),
                iconSize: 64.0,
                onPressed: player.pause,
              );

            } else {

              return IconButton(
                icon: Icon(Icons.replay,color: Colors.white),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices.first),
              );

            }
          },
        ),

        StreamBuilder<SequenceState>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_next,color: Colors.white,),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

/*class PlayerControlWidget extends StatefulWidget {
  final String music;

  PlayerControlWidget(this.music);

  @override
  State<StatefulWidget> createState() {
    return PlayerControlWidgetState();
  }
}

//enum PlayerState { stopped, playing, paused }

class PlayerControlWidgetState extends State<PlayerControlWidget> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());

    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });

    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(
          "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ControlButtons(_player),
        StreamBuilder<PositionData>(
          stream: _positionDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data;
            return SeekBar(
              duration: positionData?.duration ?? Duration.zero,
              position: positionData?.position ?? Duration.zero,
              bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
              onChangeEnd: _player.seek,
            );
          },
        ),
      ],
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opens volume slider dialog
        IconButton(
          icon: Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),

        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.red,
                ),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(
                  Icons.pause,
                  color: Colors.red,
                ),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: Icon(
                  Icons.replay,
                  color: Colors.red,
                ),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        // Opens speed slider dialog
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}*/
