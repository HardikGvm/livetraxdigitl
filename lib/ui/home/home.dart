import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tomo_app/main.dart';
import 'package:tomo_app/ui/Artist/ArtistList.dart';
import 'package:tomo_app/ui/ExclusiveAccess/ExclusiveAccessScreen.dart';
import 'package:tomo_app/ui/call/call.dart';
import 'package:tomo_app/ui/server/getagoratoken.dart';
import 'package:tomo_app/widgets/background_image.dart';
import 'package:tomo_app/widgets/colorloader2.dart';
import 'package:tomo_app/widgets/easyDialog2.dart';
import 'package:tomo_app/widgets/ibutton3.dart';

class Home extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  _pressLoginButton() {
    print("User pressed \"LOGIN\" button");
    print(
        "Login: ${editControllerName.text}, password: ${editControllerPassword.text}");
    if (editControllerName.text.isEmpty)
      return openDialog(strings.get(10)); // "Enter Login",
    if (!validateEmail(editControllerName.text))
      return openDialog(strings.get(11)); // "Login or Password in incorrect"
    if (editControllerPassword.text.isEmpty)
      return openDialog(strings.get(12)); // "Enter Password",
    _waits(true);
  }

  _okUserEnter(String name, String password, String avatar, String email,
      String token, String _phone, int i, String id) {
    _waits(false);
    Navigator.pushNamedAndRemoveUntil(context, "/main", (r) => false);
  }

  _pressForgotPasswordButton() {
    print("User press \"Forgot password\" button");
    Navigator.pushNamed(context, "/forgot");
  }

  var windowWidth;
  var windowHeight;
  final editControllerName = TextEditingController();
  final editControllerPassword = TextEditingController();
  bool _wait = false;
  String _Token;
  ClientRole _role = ClientRole.Audience;
  final _formKey = GlobalKey<FormState>();

  _waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
  }

  _error(String error) {
    _waits(false);
    if (error == "1")
      return openDialog(strings.get(11)); // "Login or Password in incorrect"
    if (error == "2") {
      if (theme.appType == "multivendor")
        return openDialog(strings.get(251)); // "Need user with role Vendor",
      return openDialog(
          strings.get(13)); // "Need user with role Administrator or Manager",
    }
    openDialog("${strings.get(158)} $error"); // "Something went wrong. ",
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    editControllerName.dispose();
    editControllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: theme.colorBackground,
      body: Stack(
        children: <Widget>[
          //IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),
          background_image(),
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            alignment: Alignment.bottomCenter,
            width: windowWidth,
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Container(
                  color: Colors.transparent,
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    padding: EdgeInsets.all(3.0),
                    children: <Widget>[
                      makeDashboardItem(
                          "Artist", Icons.supervised_user_circle_sharp),
                      makeDashboardItem("Live Event", Icons.music_note),
                      makeDashboardItem(
                          "Exclusive\nAccess", Icons.verified_user),
                    ],
                  ),
                )),
          ),
          if (_wait)
            (Container(
              color: Color(0x80000000),
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
    );
  }

  _body() {
    /*return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: GridView.count(
              crossAxisCount: 3,
              padding: EdgeInsets.all(3.0),
                children: <Widget>[
                  makeDashboardItem("Ordbog", Icons.book),
                  makeDashboardItem("Alphabet", Icons.alarm),
                ],
            )),
        SizedBox(
          height: windowHeight * 0.1,
        ),
      ],
    );*/

    return GridView.count(
      crossAxisCount: 3,
      padding: EdgeInsets.all(3.0),
      children: <Widget>[
        makeDashboardItem("Ordbog", Icons.book),
        makeDashboardItem("Alphabet", Icons.alarm),
        makeDashboardItem("Sample", Icons.ac_unit_rounded),
      ],
    );
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

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  void RedirectToArtist() {
    log("TAGGGG " + "Print Artist");
  }

  void RedirectToLiveEvent() {
    log("TAGGGG " + "Print LiveEvent");
  }

  void RedirectToExclusive() {
    log("TAGGGG " + "Print Exclusive");
  }

  Card makeDashboardItem(String title, IconData icon) {
    return Card(
        elevation: 1.0,
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        margin: new EdgeInsets.all(1.0),
        child: Container(
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(color: Colors.transparent),
          child: new InkWell(
            onTap: () {
              if (title == 'Artist') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ArtistList()),
                );
              } else if (title == 'Exclusive\nAccess') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExclusiveAccessScreen()),
                );
              } else if (title == 'Live Event') {
                AgoraToken();
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AgoraToken()),
                );*/
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 5.0),
                Center(
                    child: Icon(
                  icon,
                  size: 40.0,
                  color: Colors.white,
                )),
                SizedBox(height: 15.0),
                new Center(
                  child: new Text(title,
                      style:
                          new TextStyle(fontSize: 16.0, color: Colors.white)),
                )
              ],
            ),
          ),
        ));
  }

  AgoraToken() async {
    //if (_formKey.currentState.validate()) {
    await _handleMicPermission();

    _waits(true);
    GetAgoraToken("asd", "Azims", token_success, token_error);
    //}
  }

  token_success(String channelname, String username, String _response) {
    _waits(false);
    _Token = _response;
    print("CALL _success Done ---> " + _response.toString());

    if (account.role == "artist") {
      _role = ClientRole.Broadcaster;
    }

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CallScreen(
              channelName: channelname,
              userName: username,
              role: _role,
              userImage:
                  "https://image.flaticon.com/icons/png/128/3135/3135715.png",
              token: _response,
            )));
  }

  token_error(String error) {
    _waits(false);
    print("CALL ERROR _success >>> " + error.toString());
    if (error == "5000") {}
    if (error == "5001") {}
  }

  Future<void> _handleMicPermission() {
    final status = Permission.microphone.request();
    print(status);
  }
}
