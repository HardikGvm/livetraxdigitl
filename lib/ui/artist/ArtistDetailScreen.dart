import 'dart:ui';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:livetraxdigitl/ui/Music/MusicPlayList.dart';
import 'package:livetraxdigitl/ui/artist/CustomAppBar.dart';
import 'package:livetraxdigitl/ui/call/call.dart';
import 'package:livetraxdigitl/ui/config/constant.dart';
import 'package:livetraxdigitl/ui/event/EventListScreen.dart';
import 'package:livetraxdigitl/ui/server/EventListAPI.dart';
import 'package:livetraxdigitl/ui/server/getagoratoken.dart';
import 'package:livetraxdigitl/widgets/colorloader2.dart';
import 'package:livetraxdigitl/widgets/ibutton3.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';

class ArtistDetailScreen extends StatefulWidget {
  final String artist_name, artist_description, artist_image, artist_id;

  const ArtistDetailScreen(
      {Key key,
      @required this.artist_id,
      @required this.artist_name,
      @required this.artist_description,
      @required this.artist_image})
      : super(key: key);

  @override
  _ArtistDetailScreenState createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  bool _wait = false;
  List<EventData> list = new List();
  double _show = 0;
  Widget _dialogBody = Container();

  var windowWidth;
  var windowHeight;
  bool isOwn = false, isLive = false;
  EventData _Current;

  @override
  void initState() {
    print("CHECK ID>> " + widget.artist_id + " << " + account.userId);
    if (widget.artist_id.trim() == account.userId.trim()) {
      isOwn = true;
    }

    if (isOwn) {
      _waits(true);
      event_list_api(account.userId, 1, 10, _onSuccessEventList, _error);
    }
    print("IDDDDDD===");
    print(widget.artist_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar('Cancel', '', this.addNewCard, widget.artist_name),
      body: Stack(children: [
        Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  (widget.artist_image != null) ? widget.artist_image : "",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            )),
        Container(
          width: MediaQuery.of(context).size.width,
          // For background Image
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: new NetworkImage(
                      (widget.artist_image != null) ? widget.artist_image : ""),
                  fit: BoxFit.contain,
                  alignment: Alignment.center)),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: new Text(
                        (widget.artist_name != null &&
                                widget.artist_name.isNotEmpty)
                            ? widget.artist_name
                            : "Kiwi time",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: new Text(
                          (widget.artist_description != null &&
                                  widget.artist_description.isNotEmpty)
                              ? widget.artist_description
                              : 'Kiwi time is San Francisco band of four childhood friends.',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.left),
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Visibility(
                  visible: isOwn ? isLive : true,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: MaterialButton(
                      child: Text((isOwn) ? 'GO LIVE' : "Active",
                          style: TextStyle(fontSize: 18)),
                      onPressed: () =>
                          {AgoraToken(_Current.title, _Current.id)},
                      color: Colors.green,
                      textColor: Colors.white,
                      padding: EdgeInsets.only(
                          left: 32, right: 32, top: 12, bottom: 12),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        if (_wait)
          (Container(
            width: windowWidth,
            height: windowHeight,
            child: Center(
              child: ColorLoader2(
                color1: theme.colorPrimary,
                color2: theme.colorCompanion,
                color3: theme.colorPrimary,
              ),
            ),
          ))
        else
          (Container()),
      ]),
      floatingActionButton: (account.role == "artist")
          ? FabCircularMenu(
              key: fabKey,
              fabOpenIcon: Icon(Icons.menu, color: Colors.red),
              fabCloseIcon: Icon(Icons.close, color: Colors.red),
              fabColor: Colors.white,
              ringDiameter: 340.0,
              ringWidth: 90.0,
              ringColor: Colors.white70,
              children: [
                IconButton(
                    icon: Icon(Icons.person, color: Colors.red),
                    iconSize: 28,
                    onPressed: () {
                      fabKey.currentState.close();
                      Navigator.pushNamed(context, "/account");
                      print('Profile');
                    }),
                IconButton(
                    icon: Icon(Icons.event, color: Colors.red),
                    iconSize: 28,
                    onPressed: () {
                      fabKey.currentState.close();
                      // if (account.role == "artist") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventListScreen(
                                  artist_id: widget.artist_id,
                                )),
                      );
                      // }
                      print('Live Event');
                    }),
                IconButton(
                    icon: Icon(Icons.music_note, color: Colors.red),
                    onPressed: () {
                      print("Artist Name====");
                      print(widget.artist_name);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MusicPlayList(
                                  title: widget.artist_name,
                                  artistId: widget.artist_id,
                                )),
                      );
                    }),
                IconButton(
                    icon: Icon(Icons.add_shopping_cart, color: Colors.red),
                    iconSize: 28,
                    onPressed: () {
                      fabKey.currentState.close();

                      String Value = widget.artist_id.toString();
                      print('Buy Merchandise ID HERE >> ' +
                          widget.artist_id.toString() +
                          " VAL " +
                          Value);
                      setState(() {
                        Artistid = Value;
                      });

                      if (account.role == "artist") {
                        Navigator.pushNamed(context, "/addproducts");
                      } else {
                        Navigator.pushNamed(context, "/homescreen",
                            arguments: {"artist_id": Value});
                      }
                    }),
                IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.red),
                    iconSize: 28,
                    onPressed: () {
                      fabKey.currentState.close();

                      String Value = widget.artist_id.toString();
                      print('Buy Merchandise ID HERE >> ' +
                          widget.artist_id.toString() +
                          " VAL " +
                          Value);
                      setState(() {
                        Artistid = Value;
                      });

                      Navigator.pushNamed(context, "/homescreen",
                          arguments: {"artist_id": Value});
                    })
              ],
            )
          : FabCircularMenu(
              key: fabKey,
              fabOpenIcon: Icon(Icons.menu, color: Colors.red),
              fabCloseIcon: Icon(Icons.close, color: Colors.red),
              fabColor: Colors.white,
              ringDiameter: 340.0,
              ringWidth: 90.0,
              ringColor: Colors.white70,
              children: [
                IconButton(
                    icon: Icon(Icons.event, color: Colors.red),
                    iconSize: 28,
                    onPressed: () {
                      fabKey.currentState.close();
                      print("List Event Click 111");
                      print(widget.artist_id);
                      // if (account.role == "artist") {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EventListScreen(artist_id: widget.artist_id)),
                      );
                      // }
                      print('Live Event');
                    }),
                IconButton(
                    icon: Icon(Icons.music_note, color: Colors.red),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) =>
                      //           MusicPlayList(title: widget.artist_name)),
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MusicPlayList(
                                  title: widget.artist_name,
                                  artistId: widget.artist_id,
                                )),
                      );
                    }),
                IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.red),
                    iconSize: 28,
                    onPressed: () {
                      fabKey.currentState.close();

                      String Value = widget.artist_id.toString();
                      print('Buy Merchandise ID HERE >> ' +
                          widget.artist_id.toString() +
                          " VAL " +
                          Value);
                      setState(() {
                        Artistid = Value;
                      });

                      if (account.role == "artist") {
                        Navigator.pushNamed(context, "/addproducts");
                      } else {
                        Navigator.pushNamed(context, "/homescreen",
                            arguments: {"artist_id": Value});
                      }
                    })
              ],
            ),
    );
  }

  Nothing() {}

  AgoraToken(String title, int Eventid) async {
    if (isLive && (_Current != null)) {
      await _handleMicPermission();
      await _handleCameraPermission();
      await _handleStoragePermission();

      title = title.toString().toLowerCase().replaceAll(" ", "");
      _waits(true);
      print("User Name > " +
          account.userName.trim().replaceAll(" ", "") +
          " Title > " +
          title);
      String _userName = account.userName.replaceAll(new RegExp('\\W+'), '');
      GetAgoraToken(title, Eventid, _userName.trim().replaceAll(" ", ""),
          token_success, token_error);
    }
  }

  addNewCard() {}

  Future<void> _handleMicPermission() {
    final status = Permission.microphone.request();
    print(status);
  }

  Future<void> _handleCameraPermission() {
    final status = Permission.camera.request();
    print(status);
  }

  Future<void> _handleStoragePermission() {
    final status = Permission.storage.request();
    print(status);
  }

  String _Token;
  ClientRole _role = ClientRole.Audience;

  token_success(
      String channelname, int eventId, String username, String _response) {
    _waits(false);
    _Token = _response;
    print("CALL _success Done ---> " + _response.toString());

    if (account.role == "artist") {
      _role = ClientRole.Broadcaster;
    }

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CallScreen(
              channelName: channelname,
              Eventid: eventId,
              userName: username,
              role: _role,
              userImage: account.userAvatar,
              token: _response,
            )));
  }

  token_error(String error) {
    _waits(false);
    print("CALL ERROR _success >>> " + error.toString());
    if (error == "5000") {}
    if (error == "5001") {}
  }

  _onSuccessEventList(List<EventData> list) {
    _waits(false);
    this.list = list;
    var i;

    //var NowDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
    var NowDate = DateTime.now();
    print("::: CURRENT ::: " + NowDate.toString()); //30-06-2021
    //var EndDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now().add(const Duration(hours: 1)));
    var EndDate = DateTime.now().add(const Duration(hours: 1));
    print("::: CURRENT ::: " +
        NowDate.toString() +
        " <<>> " +
        EndDate.toString()); //30-06-2021

    for (i = 0; i < list.length; i++) {
      var CurrentDate =
          DateTime.parse(list[i].event_date + " " + list[i].event_time);
      print(":::ID::: " +
          list[i].title +
          " > " +
          list[i].event_date +
          " " +
          list[i].event_time +
          " <> " +
          CurrentDate.toString());
      print(":::TEST::: " +
          NowDate.isBefore(CurrentDate).toString() +
          " >>> " +
          EndDate.isAfter(CurrentDate).toString());
      if (NowDate.isBefore(CurrentDate) && EndDate.isAfter(CurrentDate)) {
        _Current = list[i];
        isLive = true;
        break;
      }
    }

    setState(() {});
  }

  _waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
  }

  _error(String error) {
    _waits(false);
    print("Get message here " + error);
    openDialog("${strings.get(158)} $error"); // "Something went wrong. ",
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
}
