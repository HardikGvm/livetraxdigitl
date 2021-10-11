import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:livetraxdigitl/ui/call/call.dart';
import 'package:livetraxdigitl/ui/event/AddEventScreen.dart';
import 'package:livetraxdigitl/ui/model/pref.dart';
import 'package:livetraxdigitl/ui/server/DeleteEvent.dart';
import 'package:livetraxdigitl/ui/server/EventListAPI.dart';
import 'package:livetraxdigitl/ui/server/getagoratoken.dart';
import 'package:livetraxdigitl/widgets/colorloader2.dart';
import 'package:livetraxdigitl/widgets/ibutton3.dart';
import 'package:need_resume/need_resume.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({key, this.artist_id}) : super(key: key);
  final String artist_id;

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends ResumableState<EventListScreen> {
  bool _wait = false;
  var windowWidth;
  var windowHeight;
  bool isChanges = false;
  List<EventData> list = new List();
  bool isArtist = false;

  @override
  void onReady() {
    callAPI();
    super.onReady();
  }

  @override
  void onResume() {
    print("::: On Resume ::: ");
    isChanges = pref.getBool(Pref.isChanges);
    if (isChanges) {
      pref.setBool(Pref.isChanges, false);
      callAPI();
    }
    super.onResume();
  }

  @override
  void onPause() {
    super.onPause();
  }

  var _isVisible;
  ScrollController _hideButtonController;

  @override
  void initState() {
    _isVisible = true;
    _hideButtonController = new ScrollController();

    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          /* only set when the previous state is false
             * Less widget rebuilds
             */
          print("TAGGG ${_isVisible} up"); //Move IO away from setState
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            /* only set when the previous state is false
               * Less widget rebuilds
               */
            print("TAGGG ${_isVisible} down"); //Move IO away from setState
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    // isArtist = (account.role == "artist");

    if (widget.artist_id == account.userId) {
      isArtist = true;
    } else {
      isArtist = false;
    }
    print("Check List > " + isArtist.toString());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('EVENTS'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Stack(
        children: [
          new ListView.separated(
            controller: _hideButtonController,
            itemCount: list == null || list.isEmpty ? 0 : list.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 5,
                child: const DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.black),
                ),
              );
            },
            itemBuilder: (BuildContext ctxt, int index) {
              return Container(
                height: 180,
                color: Color.fromARGB(247, 247, 247, 255),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      new Flexible(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                              (list == null ||
                                      list.isEmpty ||
                                      list[index].image == null)
                                  ? 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'
                                  : list[index].image,
                              width: 120),
                        ),
                        flex: 1,
                      ),
                      new Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      list == null && list.isEmpty ||
                                              list[index].event_date == null
                                          ? ''
                                          : list[index].event_date +
                                              " " +
                                              list[index].event_time,
                                      style: theme.text14boldBlack,
                                    ),
                                  ),
                                  Visibility(
                                    child: IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      tooltip: 'Delete Event',
                                      onPressed: () {
                                        _showMyDialog(index);
                                      },
                                    ),
                                    visible: isArtist,
                                  )
                                ],
                              ),
                              Text(
                                list == null && list.isEmpty ||
                                        list[index].title == null
                                    ? ''
                                    : list[index].title,
                                style: theme.text14boldBlack,
                              ),
                              if (list[index].is_live == 1)
                                Visibility(
                                  child: SizedBox(
                                    child: IconButton(
                                      iconSize: 40,
                                      icon: Image.asset('assets/storie.png'),
                                    ),
                                  ),
                                  visible: true,
                                ),
                              if (list[index].is_live != 1)
                                Text(
                                  list == null && list.isEmpty ||
                                          list[index].desc == null
                                      ? ''
                                      : list[index].desc,
                                  style: theme.text14,
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      list == null && list.isEmpty ||
                                              list[index].price == null
                                          ? strings.get(2258)
                                          : (list[index].price != "0")
                                              ? ("\$" +
                                                  list[index].price.toString())
                                              : strings.get(2258),
                                      style: theme.text16boldPimary,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.navigate_next_outlined,
                                        color: Colors.red,
                                      ),
                                      tooltip: 'Increase volume by 10',
                                      onPressed: () {
                                        AgoraToken(
                                            list[index].title, list[index].id);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        flex: 2,
                      )
                    ],
                  ),
                ),
              );
            },
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
        ],
      ),
      floatingActionButton: new Visibility(
          visible: isArtist ? _isVisible : false,
          child: FloatingActionButton(
            onPressed: () {
              push(
                context,
                MaterialPageRoute(builder: (context) => AddEventScreen()),
                //MaterialPageRoute(builder: (context) => AddProductScreen()),
              );
            },
            child: const Icon(Icons.add),
            backgroundColor: Colors.blueGrey,
          )),
    );
  }

  _event(String artist, int page, int limit) {
    print("::::Data::::");
    // if (!isArtist) {
    //   artist = "";
    // }
    print("Artist====$artist");
    event_list_api(artist, page, limit, _onSuccessEventList, _error);
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

  double _show = 0;
  Widget _dialogBody = Container();

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

  _onSuccessEventList(List<EventData> list) {
    _waits(false);
    this.list = list;
    var i;
    for (i = 0; i < list.length; i++) {
      print(":::ID::: " + list[i].id.toString());
    }
    setState(() {});
  }

  _onSuccessDelete(String message, int index) {
    _waits(false);

    print("::: Data deleted :::" + index.toString());
    list.removeAt(index);
    setState(() {});
  }

  void callAPI() {
    _waits(true);
    if (list != null && list.length > 0) {
      print(":::Call API:::");
      list.clear();
    }

    _event(widget.artist_id, 1, 100);
  }

  bool isVisibility(int index) {
    bool isVisible = false;
    if (list != null && list.isNotEmpty) {
      if (list[index].artist == int.parse(account.userId)) {
        isVisible = true;
      } else {
        isVisible = false;
      }
    } else {
      isVisible = false;
    }
    return isVisible;
  }

  AgoraToken(String title, int Eventid) async {
    //if (_formKey.currentState.validate()) {

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
    GetAgoraToken(title, Eventid, _userName, token_success, token_error);
    //}
  }

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

  Future<void> _showMyDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure want to delete the event?'),
          content: SingleChildScrollView(
            child: Container(),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();

                _waits(true);
                deleteEventAPI(
                    list[index].id.toString(), index, _onSuccessDelete, _error);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
