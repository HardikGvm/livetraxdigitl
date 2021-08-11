import 'dart:async';
import 'dart:math' as math;

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:agora_rtm/agora_rtm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tomo_app/ui/Artist/data.dart';
import 'package:tomo_app/ui/call/messaging.dart';
import 'package:tomo_app/ui/config/settings.dart';
import 'package:tomo_app/ui/model/message.dart';
import 'package:tomo_app/ui/server/LiveStatusEvent.dart';
import 'package:tomo_app/ui/server/listvirtualgift.dart';
import 'package:tomo_app/ui/server/listvirtualgift_model.dart';
import 'package:tomo_app/widgets/HearAnim.dart';
import 'package:tomo_app/widgets/background_image_another.dart';
import 'package:tomo_app/widgets/easyDialog2.dart';
import 'package:tomo_app/ui/call/giftView.dart';

import '../../main.dart';
import 'Productlist.dart';
import 'SampletList.dart';

class CallScreen extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;
  final String token;
  final String userName;
  final String userImage;
  final int Eventid;

  static data sample;

  /// non-modifiable client role of the page
  final ClientRole role;

  /// Creates a call page with given channel name.
  const CallScreen(
      {Key key,
      this.channelName,
      this.Eventid,
      this.userName,
      this.role,
      this.userImage,
      this.token})
      : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallScreen> {
  final _users = <int>[];
  final _infoStrings = <Message>[];
  bool muted = false;
  RtcEngine _engine;
  bool requested = false;

  bool _isLogin = false;
  bool _isInChannel = false;
  List<data> _responseList = [];
  final _channelMessageController = TextEditingController();

  /*Agora Messaging*/
  AgoraRtmClient _client;
  AgoraRtmChannel _channel;

  int _numConfetti = 10;
  bool personBool = false;
  bool waiting = false;
  var tryingToEnd = false;

  var userMap;
  int userNo = 0;
  int SelectedID = -1;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();

    SetStatusEvent(0);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
    userMap = {widget.userName: widget.userImage};
    _createClient();
    SetStatusEvent(1);

    LoadVirtualgift();
  }

  LoadVirtualgift() {
    _waits(true);
    listVirtualGift(_success, _error);
  }

  bool _wait = false;

  _success(List<data> _response) {
    _waits(false);
    _responseList = _response;
    print("CALL _success Done ---> " + _response.length.toString());
    /*openDialog(strings.get(
        135)); // "A letter with a new password has been sent to the specified E-mail",*/
  }

  _error(String error) {
    _waits(false);
    print("CALL ERROR _success >>> " + error.toString());
    if (error == "5000") {}
    if (error == "5001") {}
  }

  _waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
  }

  SetStatusEvent(int status) {
    if (account.role == "artist") {
      LiveStatusEvent(widget.Eventid, status, _onSuccessDelete, error);
    }
  }

  _onSuccessDelete(String message, int index) {
    print("::: Data deleted :::" + index.toString());
    setState(() {});
  }

  error(String error) {
    print("Get message here HERE " + error);
  }

  void _createClient() async {
    _client =
        await AgoraRtmClient.createInstance('b42ce8d86225475c9558e478f1ed4e8e');
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      _logPeer(message.text);
    };
    _client.onConnectionStateChanged = (int state, int reason) {
      print('TAGGGGG -------- > Connection state changed: ' +
          state.toString() +
          ', reason: ' +
          reason.toString());
      if (state == 5) {
        _client.logout();
        print('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };

    _toggleLogin();
    _toggleJoinChannel();
  }

  void _logPeer(String info) {
    info = '%' + info;
    print("TAGGGGG -------- >" + info);
    setState(() {
      //_infoStrings.insert(0, info);
    });
  }

  void _toggleLogin() async {
    if (!_isLogin) {
      try {
        await _client.login(null, widget.userName);
        print('Login success: ' + widget.userName);
        setState(() {
          _isLogin = true;
        });
      } catch (errorCode) {
        print('Login error: ' + errorCode.toString() + " > " + widget.userName);
      }
    }
  }

  void _toggleJoinChannel() async {
    try {
      _channel = await _createChannel(widget.channelName);
      await _channel.join();
      print('Join channel success.');

      setState(() {
        _isInChannel = true;
      });
    } catch (errorCode) {
      print('Join channel error: ' + errorCode.toString());
    }
  }

  Future<AgoraRtmChannel> _createChannel(String name) async {
    AgoraRtmChannel channel = await _client.createChannel(name);
    channel.onMemberJoined = (AgoraRtmMember member) {
      print("TAGGGG ------------->>> Member joined: " +
          member.userId +
          ', channel: ' +
          member.channelId);

      var len;
      _channel.getMembers().then((value) {
        len = value.length;
        setState(() {
          userNo = len - 1;
          print("TAGGGG ------------->>> Member joined: " +
              member.userId +
              ', channel: ' +
              member.channelId +
              " userNo < " +
              userNo.toString());
        });
      });
    };
    channel.onMemberLeft = (AgoraRtmMember member) {
      print("TAGGGG ------------->>> Member left: " +
          member.userId +
          ', channel: ' +
          member.channelId);

      var len;
      _channel.getMembers().then((value) {
        len = value.length;
        setState(() {
          userNo = len - 1;
          print("TAGGGG ------------->>> Member LEFT: " +
              member.userId +
              ', channel: ' +
              member.channelId +
              " userNo < " +
              userNo.toString());
        });
      });
    };
    channel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      _logPeer(message.text);
      var img = "https://image.flaticon.com/icons/png/128/3135/3135715.png";
      userMap.putIfAbsent(member.userId, () => img);
      _logInsert(user: member.userId, info: message.text, type: 'message');
    };
    return channel;
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        print("TAGGGG ------------->>><>>> " +
            "APP_ID missing, please provide your APP_ID in settings.dart");
        print("TAGGGG ------------->>><>>> " + "Agora Engine is not starting");
        /*_infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );

        _infoStrings.add('Agora Engine is not starting');*/
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    /*Agora Video Configuration*/
    //VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    //configuration.dimensions = VideoDimensions(1920, 1080);
    //await _engine.setVideoEncoderConfiguration(configuration);
    //await _engine.joinChannel(Token, widget.channelName, null, 0);
    print("CALL _success Done TOKEN   ---> " + widget.token);
    await _engine.joinChannel(widget.token, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        //_infoStrings.add(info);
        print("TAGGGG ------------->>><>>> " + info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        //_infoStrings.add(info);
        print("TAGGGG ------------->>><>>> " +
            'onJoinChannel: $channel, uid: $uid');
      });
    }, leaveChannel: (stats) {
      setState(() {
        //_infoStrings.add('onLeaveChannel');
        print("TAGGGG ------------->>><>>> " + "onLeaveChannel");
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        print("TAGGGG ------------->>><>>> " + info);
        //_infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        //_infoStrings.add(info);
        print("TAGGGG ------------->>><>>> " + info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        //_infoStrings.add(info);
        print("TAGGGG ------------->>><>>> " + info);
      });
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    if (widget.role == ClientRole.Audience) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          alignment: Alignment.topRight,
          padding: const EdgeInsets.symmetric(vertical: 80),
          constraints: BoxConstraints(maxHeight: 400),
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.topRight,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: RawMaterialButton(
                    onPressed: _onVirtualGift,
                    child: Icon(
                      Icons.card_giftcard,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.redAccent,
                    padding: const EdgeInsets.all(12.0),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: RawMaterialButton(
                    onPressed: _onMerchandise,
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.orangeAccent,
                    padding: const EdgeInsets.all(12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ); // Audience
    } else {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          alignment: Alignment.topRight,
          padding: const EdgeInsets.symmetric(vertical: 80),
          constraints: BoxConstraints(maxHeight: 400),
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.topRight,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: RawMaterialButton(
                    onPressed: _onToggleMute,
                    child: Icon(
                      muted ? Icons.mic_off : Icons.mic,
                      color: muted ? Colors.white : Colors.blueAccent,
                      size: 20.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: muted ? Colors.blueAccent : Colors.white,
                    padding: const EdgeInsets.all(12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ); // Broadcast
    }
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index].message,
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onVirtualGift() {
    setState(() {});
    return openVirtualDialog("Virtual Gift", (s) {
      setState(() {
        print("Updated VALUE IS HERE --->> " + s.toString());
      });
    });
  }

  void _onMerchandise() {
    setState(() {});
    return openDialog("Merchandise");
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _onRealTimeMessaging() {
    bool isBroadcaster = true;
    print("TAGGGG Check Role > " +
        (widget.role == ClientRole.Audience).toString() +
        " >> " +
        widget.role.toString());
    if (widget.role == ClientRole.Audience) {
      isBroadcaster = false;
    }

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => RealTimeMessaging(
        channelName: widget.channelName,
        userName: widget.userName,
        isBroadcaster: isBroadcaster,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Container(
              child: Center(
                child: Stack(
                  children: <Widget>[
                    _viewRows(),
                    background_image_another(),
                    _liveText(),
                    //_panel(),
                    _toolbar(),
                    _messageList(),
                    if (heart == true && completed == false) heartPop(),
                    if (widget.role == ClientRole.Broadcaster) _endCall(),
                    _buildSendChannelMessage(),
                    if (tryingToEnd == true) endLive(),
                    IEasyDialog2(
                      setPosition: (double value) {
                        _show = value;
                      },
                      getPosition: () {
                        return _show;
                      },
                      color: theme.colorGrey,
                      body: _dialogBody,
                      backgroundColor: theme.colorBackground,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: _willPopCallback);
    /* return Scaffold(
      appBar: AppBar(
        title: Text('Agora Flutter QuickStart'),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            _endCall(),
            _liveText(),
            _panel(),
            _toolbar(),
            _messageList(),
            if (heart == true && completed == false) heartPop(),
            _buildSendChannelMessage(),
          ],
        ),
      ),
        onWillPop: _willPopCallback
    );*/
  }

  Future<bool> _willPopCallback() async {
    if (personBool == true) {
      setState(() {
        personBool = false;
      });
    } else {
      setState(() {
        print("Check Value here >>" + (_show != 1).toString() + " >> " + _show.toString());
        if (_show != 0) {
          _show = 0;
        } else {
          tryingToEnd = !tryingToEnd;
        }
      });
    }
    return false; // return true if the route to be popped
  }

  Widget _liveText() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[Colors.indigo, Colors.blue],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                child: Text(
                  'LIVE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 10),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.6),
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  height: 28,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.eye,
                          color: Colors.white,
                          size: 13,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '$userNo',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _endCall() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: GestureDetector(
              onTap: () {
                if (personBool == true) {
                  setState(() {
                    personBool = false;
                  });
                }
                setState(() {
                  if (waiting == true) {
                    waiting = false;
                  }
                  tryingToEnd = true;
                });
              },
              child: Text(
                'END',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendChannelMessage() {
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 5, right: 8, bottom: 5),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            new Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
              child: new TextField(
                  cursorColor: Colors.blue,
                  textInputAction: TextInputAction.go,
                  //onSubmitted: _toggleSendChannelMessage,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: _channelMessageController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Comment',
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(color: Colors.white)),
                  )),
            )),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              child: MaterialButton(
                minWidth: 0,
                onPressed: _toggleSendChannelMessage,
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                color: Colors.blue[400],
                padding: const EdgeInsets.all(12.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: MaterialButton(
                minWidth: 0,
                onPressed: () async {
                  popUp();
                  await _channel.sendMessage(
                      AgoraRtmMessage.fromText('m1x2y3z4p5t6l7k8'));
                },
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 30.0,
                ),
                padding: const EdgeInsets.all(12.0),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _messageList() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: (_infoStrings[index].type == 'join')
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: _infoStrings[index].image,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                '${_infoStrings[index].user} joined',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : (_infoStrings[index].type == 'message')
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: _infoStrings[index].image,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 32.0,
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        _infoStrings[index].user,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Container(
                                        width: 180,
                                        child: Text(
                                          _infoStrings[index].message,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : null,
              );
            },
          ),
        ),
      ),
    );
  }

  bool heart = false;
  bool completed = false;
  Timer _timer;
  double height = 0.0;
  final _random = math.Random();

  void popUp() async {
    setState(() {
      heart = true;
    });
    Timer(
        Duration(seconds: 4),
        () => {
              _timer.cancel(),
              setState(() {
                heart = false;
              })
            });
    _timer = Timer.periodic(Duration(milliseconds: 125), (Timer t) {
      setState(() {
        height += _random.nextInt(20);
      });
    });
  }

  void _toggleSendChannelMessage() async {
    String text = _channelMessageController.text.trim();
    print('TAGGGG ------------->>><>>> Send channel SENDING : ' +
        text.isEmpty.toString());
    if (text.isEmpty) {
      print('Please input text to send.');
      return;
    }
    try {
      await _channel.sendMessage(AgoraRtmMessage.fromText(text));
      //_log(text);
      _logInsert(user: widget.userName, info: text, type: 'message');
      _channelMessageController.clear();
      print('TAGGGG ------------->>><>>> Send channel SENDING : ' + text);
    } catch (errorCode) {
      print('TAGGGG ------------->>><>>> Send channel message error: ' +
          errorCode.toString());
    }
  }

  void _log(String info) {
    print(info);
    setState(() {
      print("TAGGGG ------------->>><>>> " + info);
      //_infoStrings.insert(0, info);
    });
  }

  void _logInsert({String info, String type, String user}) {
    if (type == 'message' && info.contains('m1x2y3z4p5t6l7k8')) {
      popUp();
    } else if (type == 'message' && info.contains('E1m2I3l4i5E6')) {
      // stopFunction();
    } else {
      Message m;
      var image = userMap[user];
      if (info.contains('d1a2v3i4s5h6')) {
        var mess = info.split(' ');
        if (mess[1] == widget.userName) {
          /*m = new Message(
              message: 'working', type: type, user: user, image: image);*/
          setState(() {
            //_infoStrings.insert(0, m);
            requested = true;
          });
        }
      } else {
        m = new Message(message: info, type: type, user: user, image: image);
        setState(() {
          _infoStrings.insert(0, m);
        });
      }
    }
  }

  Widget heartPop() {
    final size = MediaQuery.of(context).size;
    final confetti = <Widget>[];
    for (var i = 0; i < _numConfetti; i++) {
      final height = _random.nextInt(size.height.floor());
      final width = 20;
      confetti.add(HeartAnim(height % 200.0, width.toDouble(), 1));
    }

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            height: 400,
            width: 200,
            child: Stack(
              children: confetti,
            ),
          ),
        ),
      ),
    );
  }

  Widget endLive() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'Are you sure you want to end your live video?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 4.0, top: 8.0, bottom: 8.0),
                    child: RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'End Video',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      elevation: 2.0,
                      color: Colors.blue,
                      onPressed: () async {
                        //await Wakelock.disable();
                        // _logout();
                        _leaveChannel();
                        _engine.leaveChannel();
                        _engine.destroy();
                        //FireStoreClass.deleteUser(username: channelName);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 4.0, right: 8.0, top: 8.0, bottom: 8.0),
                    child: RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      elevation: 2.0,
                      color: Colors.grey,
                      onPressed: () {
                        setState(() {
                          tryingToEnd = false;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _leaveChannel() async {
    try {
      await _channel.leave();
      //_log(info: 'Leave channel success.',type: 'leave');
      print("TAGGG Check LEAVE -->>> " + _channel.channelId + "");
      _client.releaseChannel(_channel.channelId);
      _channelMessageController.text = null;
    } catch (errorCode) {
      // _log(info: 'Leave channel error: ' + errorCode.toString(),type: 'error');
    }
  }

  void stopFunction() async {
    /*await AgoraRtcEngine.enableLocalVideo(!muted);
    await AgoraRtcEngine.enableLocalAudio(!muted);
    setState(() {
      accepted= false;
    });*/
  }

  int _languageIndex = -1;

  Widget _dialogBody = Container();
  double _show = 0;

  openDialog(String _text) {
    _dialogBody = SingleChildScrollView();
    setState(() {
      _show = 1;
    });
  }

  openVirtualDialog(String _text, Function callBack) {
    _dialogBody = SingleGiftView(callBack);
    setState(() {
      _show = 1;
    });
  }

  Widget SingleChildScrollView() {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: ListView.builder(
                itemCount: details.length,
                itemBuilder: (BuildContext context, int index) {
                  return ProductList(context, index);
                }),
          ),
        ],
      ),
    );
  }

  Widget SingleGiftView(Function callBack) {
    print("check auto refresh here -->");
    return Container(
      color: Colors.white,
      height: 300,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              strings.get(2241),
              style: TextStyle(
                color: Color(0xff00315C),
                fontSize: 16.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            height: 250,
            width: double.infinity,
            child: SizedBox(
              height: 250,
              child: SampleList(context, 0, _responseList, callBack),
            ),
          )
        ],
      ),
    );
  }
}
