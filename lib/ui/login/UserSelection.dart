import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:livetraxdigitl/main.dart';
import 'package:livetraxdigitl/ui/social/google.dart';
import 'package:livetraxdigitl/widgets/background_image.dart';
import 'package:livetraxdigitl/widgets/colorloader2.dart';
import 'package:livetraxdigitl/widgets/easyDialog2.dart';
import 'package:livetraxdigitl/widgets/iappBar.dart';
import 'package:livetraxdigitl/widgets/ibutton3.dart';

class UserSelection extends StatefulWidget {
  @override
  _UserSelection createState() => _UserSelection();
}

class _UserSelection extends State<UserSelection> {
  GoogleLogin googleLogin = GoogleLogin();

  /*Facebook Auth*/
  var profileData;
  bool isLoggedIn = false;
  var facebookLogin = FacebookLogin();

  var _socialEnter = false;
  var _socialId = "";
  var _socialType = "";
  var _socialName = "";
  var _socialPhoto = "";

  _okUserEnter(String name, String password, String avatar, String email,
      String token, String _phone, int i, String id) {
    _waits(false);
    //  account.okUserEnter(name, password, avatar, email, token, _phone, i, id);
    Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
  }

  _pressForgotPasswordButton() {
    print("User press \"Forgot password\" button");
    Navigator.pushNamed(context, "/forgot");
  }

  ////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerName = TextEditingController();
  final editControllerPassword = TextEditingController();
  bool _wait = false;

  _waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
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
          IAppBar(context: context, text: "", color: Colors.white),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            alignment: Alignment.center,
            width: windowWidth,
            child: _body(),
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
        ],
      ),
    );
  }

  _body() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        new GestureDetector(
          onTap: () {
            print("Artist clicked");
            pressArtistLogin();
          },
          child: Container(
            width: windowWidth * 0.3,
            height: windowWidth * 0.3,
            child: Image.asset("assets/directorchair.png", fit: BoxFit.contain),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        new GestureDetector(
          onTap: () {
            print("Artist clicked");
            pressArtistLogin();
          },
          child: new Center(
            child: new Text("ARTIST",
                style: new TextStyle(fontSize: 25.0, color: Colors.white)),
          ),
        ),
        SizedBox(
          height: 60,
        ),
        new GestureDetector(
          onTap: () {
            print("FAN clicked");
            pressFANLogin();
          },
          child: Container(
            width: windowWidth * 0.3,
            height: windowWidth * 0.3,
            child: Image.asset("assets/audience.png", fit: BoxFit.contain),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        new GestureDetector(
          onTap: () {
            print("FAN clicked");
            pressFANLogin();
          },
          child: new Center(
            child: new Text("FAN",
                style: new TextStyle(fontSize: 25.0, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  pressArtistLogin(){
    Navigator.pushNamed(context, "/signup",arguments: {"usertype":"artist"});
  }

  pressFANLogin(){
    Navigator.pushNamed(context, "/signup",arguments: {"usertype":"fan"});
  }


}
