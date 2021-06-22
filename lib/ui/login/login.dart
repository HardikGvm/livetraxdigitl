import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:tomo_app/main.dart';
import 'package:tomo_app/ui/server/login.dart';
import 'package:tomo_app/ui/social/google.dart';
import 'package:tomo_app/widgets/background_image.dart';
import 'package:tomo_app/widgets/colorloader2.dart';
import 'package:tomo_app/widgets/easyDialog2.dart';
import 'package:tomo_app/widgets/ibutton3.dart';
import 'package:tomo_app/widgets/ibutton4.dart';
import 'package:tomo_app/widgets/iinputField2.dart';
import 'package:tomo_app/widgets/iinputField2Password.dart';

class Login extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
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

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
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
     login(editControllerName.text, editControllerPassword.text, _okUserEnter, _error);
  }

  _okUserEnter(String name, String password, String avatar, String email,
      String token, String _phone, int i, String typeReg, String role) {
    _waits(false);
    if(role == "2"){
      role="artist";
    }else{
      role="fan";
    }
    print("Check Login Here >> " + name + " > " + email + " > " + typeReg + " > " + role);
    //  account.okUserEnter(name, password, avatar, email, token, _phone, i, id);
    account.okUserEnter(name, password, avatar, email, token, "", 0, "",typeReg,role);
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
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          width: windowWidth * 0.12,
          height: windowWidth * 0.12,
          child: Image.asset("assets/nounmusic.png", fit: BoxFit.contain),
        ),
        SizedBox(
          height: 10,
        ),
        new Center(
          child: new Text("LOVEMUSIC",
              style: new TextStyle(fontSize: 25.0, color: Colors.white)),
        ),
        SizedBox(
          height: windowHeight * 0.15,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2(
                hint: strings.get(14),
                // "Login"
                icon: Icons.alternate_email,
                colorDefaultText: Colors.white,
                controller: editControllerName,
                type: TextInputType.emailAddress)),
        SizedBox(
          height: 5,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),
        SizedBox(
          height: 5,
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2Password(
              hint: strings.get(15), // "Password"
              icon: Icons.vpn_key,
              colorDefaultText: Colors.white,
              controller: editControllerPassword,
            )),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              IconButton(
                onPressed: pressGoogleAuthentication,
                iconSize: 30,
                icon: Image.asset('assets/twitter.png'),
              ),
              IButton4(
                  color: Colors.blue,
                  text: strings.get(16), // Change
                  textStyle: theme.text14boldWhite,
                  pressButton: () {
                    setState(() {
                      _show = 0;
                      _pressLoginButton();
                    });
                  }),
              IconButton(
                onPressed: pressFacebookAuthentication,
                iconSize: 30,
                icon: Image.asset('assets/facebook.png'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        new Center(
          child: new Text("- OR -",
              style: new TextStyle(fontSize: 15.0, color: Colors.white)),
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
            onTap: () {
              _pressSignupScreen();
            }, // needed
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 0),
              child: Text(strings.get(2238), // "Forgot password",
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: theme.text16boldWhite),
            )),
        SizedBox(
          height: windowHeight * 0.05,
        ),
        InkWell(
            onTap: () {
              _pressForgotPasswordButton();
            }, // needed
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 0),
              child: Text(strings.get(17), // "Forgot password",
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: theme.text16boldWhite),
            ))
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

  _pressSignupScreen() {
    print("User press \"Signup\" button");
    //Navigator.pushNamed(context, "/signup");
    Navigator.pushNamed(context, "/userselection");
  }

  void pressGoogleAuthentication() {
    _waits(true);
    googleLogin.login(_login, _error);
  }

  void pressFacebookAuthentication() {
    _waits(true);
    initiateFacebookLogin();
  }

  void initiateFacebookLogin() async {
    setState(() {});
    var facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        onLoginStatusChanged(false);
        _waits(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        onLoginStatusChanged(false);
        _waits(false);
        break;
      case FacebookLoginStatus.loggedIn:
        var graphResponse = await http.get(Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}'));

        var profile = json.decode(graphResponse.body);
        print("Facebook Login " + profile.toString());
        _waits(false);
        onLoginStatusChanged(true, profileData: profile);
        break;
    }
  }

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;

      if (isLoggedIn) {
       // _login("facebook", id, name, photo, email);
        print("Facebook > " + profileData['id'] + " > " + profileData['email'] + " > " + profileData['email'] + " > " + profileData['name']+ " > " + profileData['picture']['data']['url'] );
        login(profileData['email'], profileData['id'], _okUserEnter, _error);
      }
    });
  }

  _login(String type, String id, String name, String photo, String email) {
    _socialEnter = true;
    _socialId = id;
    _socialType = type;
    _socialName = name;
    _socialPhoto = photo;
    //login("$id@$type.com", id, _okUserEnter, _error);
    login(email, id, _okUserEnter, _error);
  }
}
