import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:livetraxdigitl/main.dart';
import 'package:livetraxdigitl/ui/ExclusiveAccess/ExclusiveAccessScreen.dart';
import 'package:livetraxdigitl/ui/config/settings.dart';
import 'package:livetraxdigitl/ui/server/verifyVideoCallCode.dart';
import 'package:livetraxdigitl/widgets/dialog_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class democallpage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;

  final String Token;
  final String artistId;

  /// non-modifiable client role of the page
  final ClientRole role;
  final int valid;
  final int code;

  /// Creates a call page with given channel name.
  const democallpage(
      {Key key, this.channelName, this.role, this.Token, this.valid, this.code,this.artistId})
      : super(key: key);

  @override
  _democallpageState createState() => _democallpageState();
}

class _democallpageState extends State<democallpage> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  RtcEngine _engine;
  AgoraRtmClient _client;
  AgoraRtmChannel _channel;
  bool _isInChannel = false;
  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  int _remoteUid;

  // RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
    _createClient();
    // print("=====CALL=====");
    // print(widget.channelName);
    // print(widget.Token);
    // print(widget.valid);
    // _toggleSendPeerMessage();
    _toggleSendLocalInvitation();

  }

  void _createClient() async {
    _client =
        await AgoraRtmClient.createInstance("824e3eb5f9b440ee9f103333a9069837");
    _client?.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      print("Peer msg: " + peerId + ", msg: " + (message.text));
    };
    _client?.onConnectionStateChanged = (int state, int reason) {
      print('Connection state changed: ' +
          state.toString() +
          ', reason: ' +
          reason.toString());
      if (state == 5) {
        _client?.logout();
        print('Logout.');
        setState(() {
          // _isLogin = false;
        });
      }
    };
    _client?.onLocalInvitationReceivedByPeer =
        (AgoraRtmLocalInvitation invite) {
      print(
          'Local invitation received by peer: ${invite.calleeId}, content: ${invite.content}');
    };
    _client?.onRemoteInvitationReceivedByPeer =
        (AgoraRtmRemoteInvitation invite) {
      print(
          'Remote invitation received by peer: ${invite.callerId}, content: ${invite.content}');
    };
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    /*configuration.dimensions = VideoDimensions(1920, 1080);
    await _engine.setVideoEncoderConfiguration(configuration);*/

    await _engine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await _engine.joinChannel(widget.Token, widget.channelName, null, 0);
  }

  void _toggleSendPeerMessage() async {
    String peerUid = widget.artistId;
    if (peerUid.isEmpty) {
      print('Please input peer user id to send message.');
      return;
    }

    String text = widget.artistId;
    if (text.isEmpty) {
      print('Please input text to send.');
      return;
    }

    try {
      AgoraRtmMessage message = AgoraRtmMessage.fromText(text);
      print(message.text);
      await _client?.sendMessageToPeer(peerUid, message, false);
      print('Send peer message success.');
    } catch (errorCode) {
      print('Send peer message error: ' + errorCode.toString());
    }
  }
  void _toggleSendLocalInvitation() async {
    String peerUid = "_peerUserIdController.text";
    if (peerUid.isEmpty) {
      print('Please input peer user id to send invitation.');
      return;
    }

    String text = "_invitationController.text";
    if (text.isEmpty) {
      print('Please input content to send.');
      return;
    }

    try {
      AgoraRtmLocalInvitation invitation =
      AgoraRtmLocalInvitation(widget.artistId,peerUid, text,widget.channelName,1);


      print(invitation.content ?? '');
      await _client?.sendLocalInvitation(invitation.toJson());
      _toggleJoinChannel();
      _toggleGetMembers();
      print('Send local invitation success.');
    } catch (errorCode) {
      print('Send local invitation error: ' + errorCode.toString());
    }
  }
  void _toggleGetMembers() async {
    try {
      List<AgoraRtmMember> members = await _channel.getMembers();
      print('Members: ' + members.toString());
    } catch (errorCode) {
      print('GetMembers failed: ' + errorCode.toString());
    }
  }
  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    //await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    //await _engine.setClientRole(widget.role);
  }
  void _toggleJoinChannel() async {
    if (_isInChannel) {
      try {
        await _channel.leave();
        print('Leave channel success.');
        if (_channel != null) {
          _client?.releaseChannel(_channel.channelId);
        }
        // _channelMessageController.clear();

        setState(() {
          _isInChannel = false;
        });
      } catch (errorCode) {
        print('Leave channel error: ' + errorCode.toString());
      }
    } else {
      String channelId = "10";
      if (channelId.isEmpty) {
        print('Please input channel id to join.');
        return;
      }

      try {
        _channel = await _createChannel(channelId);
        await _channel.join();
        print('Join channel success.');

        setState(() {
          _isInChannel = true;
        });
      } catch (errorCode) {
        print('Join channel error: ' + errorCode.toString());
      }
    }
  }
  callAPI() {
    if (widget.valid == 1)
      verifyVideoCallCode(account.token, widget.code.toString(), true,
          _onSuccessVideoCall, _error);
  }

  _onSuccessVideoCall(Data data) {}

  _error(String error) {
    print("Get message here " + error);
    // showDialog(
    //     context: context,
    //     barrierColor: Colors.black.withOpacity(0.8),
    //     builder: (_) => DialogWidget(
    //       title: "" + error,
    //       button1: 'Ok',
    //       onButton1Clicked: () {
    //         Navigator.of(context, rootNavigator: true).pop();
    //       },
    //     ));
  }
  Future<AgoraRtmChannel> _createChannel(String name) async {
    AgoraRtmChannel channel = await _client?.createChannel(name);
    if (channel != null) {
      channel.onMemberJoined = (AgoraRtmMember member) {
        print("Member joined: " +
            member.userId +
            ', channel: ' +
            member.channelId);
      };
      channel.onMemberLeft = (AgoraRtmMember member) {
        print(
            "Member left: " + member.userId + ', channel: ' + member.channelId);
      };
      channel.onMessageReceived =
          (AgoraRtmMessage message, AgoraRtmMember member) {
            print("Channel msg: " + member.userId + ", msg: " + message.text);
      };
    }
    return channel;
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    print("Video Call");
    // callAPI();
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        print("====CALL ERROR====$code");
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
        print("====joinChannel====" + uid.toString());
        // callAPI();
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        print("====Leave Channel====" + stats.toString());
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        print("====User Join Channel====" + uid.toString());
        _infoStrings.add(info);
        _users.add(uid);
        // callAPI();
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        print("====User Offline Channel====" + uid.toString());
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    //if (widget.role == ClientRole.Broadcaster) {
    list.add(RtcLocalView.SurfaceView());
    //}
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

  Widget _expandedSmallVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    //getFlutterView().setZOrderOnTop(true);
    //getFlutterView().getHolder().setFormat(PixelFormat.TRANSPARENT);
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: 120,
        height: 150,
        child: Row(
          children: wrappedViews,
        ),
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
            _expandedVideoRow([views[1]]),
            //_expandedSmallVideoRow([views[0]]),
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
    //if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
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
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
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
                          _infoStrings[index],
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
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ExclusiveAccessScreen()),
        ModalRoute.withName("/homescreen"));
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            //_panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
