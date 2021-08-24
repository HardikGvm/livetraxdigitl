import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:livetraxdigitl/main.dart';
import 'package:livetraxdigitl/ui/merchandise/homescreenModel.dart';
import 'package:livetraxdigitl/ui/model/utils.dart';
import 'package:livetraxdigitl/ui/server/register.dart';
import 'package:livetraxdigitl/ui/social/google.dart';
import 'package:livetraxdigitl/widgets/background_image.dart';
import 'package:livetraxdigitl/widgets/colorloader2.dart';
import 'package:livetraxdigitl/widgets/easyDialog2.dart';
import 'package:livetraxdigitl/widgets/iappBar.dart';
import 'package:livetraxdigitl/widgets/ibutton3.dart';
import 'package:livetraxdigitl/widgets/ibutton4.dart';
import 'package:livetraxdigitl/widgets/iinputField2PasswordA.dart';
import 'package:livetraxdigitl/widgets/iinputField2a.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen>
    with SingleTickerProviderStateMixin {
  // FaceBookLogin facebookLogin = FaceBookLogin();
  GoogleLogin googleLogin = GoogleLogin();

  /*Facebook Auth*/
  var profileData;
  bool isLoggedIn = false;
  var facebookLogin = FacebookLogin();

  bool value = false;

  //AppleLogin appleLogin = AppleLogin();

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  _pressCreateAccountButton() {
    print("User pressed \"CREATE ACCOUNT\" button");
    print(
        "Login: ${editControllerName.text}, E-mail: ${editControllerEmail.text}, "
        "password1: ${editControllerPassword1.text}, password2: ${editControllerPassword2.text}");
    if (editControllerName.text.isEmpty)
      return openDialog(strings.get(175)); // "Enter your Login"
    if (editControllerEmail.text.isEmpty)
      return openDialog(strings.get(176)); // "Enter your E-mail"
    if (!validateEmail(editControllerEmail.text))
      return openDialog(strings.get(178)); // "You E-mail is incorrect"
    if (editControllerPassword1.text.isEmpty ||
        editControllerPassword2.text.isEmpty)
      return openDialog(strings.get(177)); // "Enter your password"
    if (!validateStructure(editControllerPassword1.text)) {
      return openDialog(strings.get(2255));// "Enter Valid password"
    }
    if (editControllerPassword1.text != editControllerPassword2.text)
      return openDialog(strings.get(134)); // "Passwords are different.",
    if(value && editReferralCode.text.isEmpty){
      return openDialog(strings.get(2256));// "Enter Referral Code"
    }
    if (appSettings.otp == "true")
      return Navigator.push(
        context,
        MaterialPageRoute(
            /*builder: (context) => OTPScreen(
              name: editControllerName.text,
              email: editControllerEmail.text,
              type: "email",
              password: editControllerPassword1.text,
              photo: ""
          ),*/
            ),
      );

    _waits(true);
    register(editControllerEmail.text, editControllerPassword1.text,
        editControllerName.text, "email", "", _okUserEnter, _error, userRole, value ? editReferralCode.text : "");
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    print("Match Password herr > " + regExp.hasMatch(value).toString());
    return regExp.hasMatch(value);
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerName = TextEditingController();
  final editControllerEmail = TextEditingController();
  final editControllerPassword1 = TextEditingController();
  final editControllerPassword2 = TextEditingController();
  final editReferralCode = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String userRole = "";

  _initiOS() {
    if (Platform.isIOS) {
      /*AppleSignIn.onCredentialRevoked.listen((_) {
        dprint("Credentials revoked");
      });*/
    }
  }

  //final Future<bool> _isAvailableFuture = AppleSignIn.isAvailable();

  /*_buttoniOS(){
    if(Platform.isIOS) {
      return FutureBuilder<bool>(
          future: _isAvailableFuture,
          builder: (context, isAvailableSnapshot) {
            if (!isAvailableSnapshot.hasData) {
              return Container();
            }
            return isAvailableSnapshot.data
                ? Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: IButton7(
                    color: Color(0xff000000), text: strings.get(299), textStyle: theme.text14boldWhite,  // "Sign In with Apple",
                    icon: "assets/apple.png",
                    pressButton: (){
                      _waits(true);
                      //appleLogin.login(_login, _error);
                    }))
                : null; // 'Sign in With Apple not available. Must be run on iOS 13+
          });
    }else{
      return Container();
    }
  }*/

  _okUserEnter(String name, String password, String avatar, String email,
      String token, String typeReg, String uid, String referral_code) {
    _waits(false);
    print("CHeck Response Done ==> " + name + " uid " + uid + " TOK " + token);
    account.okUserEnter(
        name, password, avatar, email, token, "", 0, uid, typeReg, userRole,referral_code);
    Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
  }

  bool _wait = false;

  _waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
  }

  _error(String error) {
    print("CHeck Response Error ==> " + error);
    _waits(false);
    if (error == "login_canceled") return;
    if (error == "3") return openDialog(strings.get(272)); // This email is busy
    openDialog("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  @override
  void initState() {
    _initiOS();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    route.disposeLast();
    editControllerName.dispose();
    editControllerEmail.dispose();
    editControllerPassword1.dispose();
    editControllerPassword2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    });

    final arguments = ModalRoute.of(context).settings.arguments as Map;

    if (arguments != null) {
      userRole = arguments['usertype'];
      print("USER TYPE HERE :- " + arguments['usertype']);
    }

    return WillPopScope(
        onWillPop: () async {
          if (_show != 0) {
            setState(() {
              _show = 0;
            });
            return false;
          }
          return true;
        },
        child: Scaffold(
            backgroundColor: theme.colorBackground,
            body: Directionality(
              textDirection: strings.direction,
              child: Stack(
                children: <Widget>[
                  //IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),
                  background_image(),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    width: windowWidth,
                    child: (userRole == "artist") ? _bodyArtist() : _bodyFan(),
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
                    backgroundColor: Colors.white,
                  ),

                  IAppBar(context: context, text: "", color: Colors.white),
                ],
              ),
            )));
  }

  _bodyArtist() {
    return ListView(
      shrinkWrap: true,
      controller: _scrollController,
      children: <Widget>[
        Container(
          width: windowWidth * 0.3,
          height: windowWidth * 0.3,
          child: Image.asset("assets/logo.png", fit: BoxFit.contain),
        ),
        SizedBox(
          height: windowHeight * 0.05,
        ),
        Container(
          width: windowWidth,
          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Text(
            strings.get(301), // "Create an Account!"
            style: theme.text20boldWhite, textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2a(
              hint: strings.get(2242), // "Login"
              icon: Icons.account_circle,
              colorDefaultText: Colors.white,
              controller: editControllerName,
            )),
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
            child: IInputField2a(
              hint: strings.get(302),
              // "E-mail address",
              icon: Icons.alternate_email,
              type: TextInputType.emailAddress,
              colorDefaultText: Colors.white,
              controller: editControllerEmail,
            )),
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
            child: IInputField2PasswordA(
              hint: strings.get(15), // "Password"
              icon: Icons.vpn_key,
              colorDefaultText: Colors.white,
              controller: editControllerPassword1,
            )),
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
            child: IInputField2PasswordA(
              hint: strings.get(303), // "Confirm Password"
              icon: Icons.vpn_key,
              colorDefaultText: Colors.white,
              controller: editControllerPassword2,
            )),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),

        SizedBox(
          height: 5,
        ),
        Card(
          color: Colors.white30,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Checkbox(
                    value: this.value,
                    hoverColor: Colors.white,
                    activeColor: Colors.redAccent,
                    checkColor: Colors.white,
                    tristate: false,
                    onChanged: (bool value) {
                      setState(() {
                        this.value = value;
                      });
                    },
                  ),
                  SizedBox(
                    width: 5,
                  ), //SizedBox
                  Text(
                    'Do you have referral code?',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ], //<Widget>[]
              ), //Row
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),
        (value)
            ? Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2a(
              hint: strings.get(2243), // "Login"
              icon: Icons.code,
              colorDefaultText: Colors.white,
              controller: editReferralCode,
            ))
            : Container(),
        SizedBox(
          height: 5,
        ),



        SizedBox(
          height: 20,
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: pressGoogleAuthentication,
                  iconSize: 30,
                  icon: Image.asset('assets/twitter.png'),
                ),
                SizedBox(
                  height: 10,
                ),
                IButton4(
                    color: Colors.blue,
                    text: strings.get(304), // Change
                    textStyle: theme.text14boldWhite,
                    pressButton: () {
                      _pressCreateAccountButton();
                    }),
                SizedBox(
                  height: 30,
                ),
                IconButton(
                  onPressed: pressFacebookAuthentication,
                  iconSize: 30,
                  icon: Image.asset('assets/facebook.png'),
                ),
              ],
            ),
          ),
        ),

        /*if (appSettings.googleLogin == "true" || appSettings.facebookLogin == "true")
          _buttoniOS(),*/

        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  _bodyFan() {
    return ListView(
      shrinkWrap: true,
      controller: _scrollController,
      children: <Widget>[
        Container(
          width: windowWidth * 0.3,
          height: windowWidth * 0.3,
          child: Image.asset("assets/logo.png", fit: BoxFit.contain),
        ),
        SizedBox(
          height: windowHeight * 0.05,
        ),
        Container(
          width: windowWidth,
          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Text(
            strings.get(301), // "Create an Account!"
            style: theme.text20boldWhite, textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2a(
              hint: strings.get(32), // "Login"
              icon: Icons.account_circle,
              colorDefaultText: Colors.white,
              controller: editControllerName,
            )),
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
            child: IInputField2a(
              hint: strings.get(302),
              // "E-mail address",
              icon: Icons.alternate_email,
              type: TextInputType.emailAddress,
              colorDefaultText: Colors.white,
              controller: editControllerEmail,
            )),
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
            child: IInputField2PasswordA(
              hint: strings.get(15), // "Password"
              icon: Icons.vpn_key,
              colorDefaultText: Colors.white,
              controller: editControllerPassword1,
            )),
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
            child: IInputField2PasswordA(
              hint: strings.get(303), // "Confirm Password"
              icon: Icons.vpn_key,
              colorDefaultText: Colors.white,
              controller: editControllerPassword2,
            )),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),
        SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: pressGoogleAuthentication,
                  iconSize: 30,
                  icon: Image.asset('assets/twitter.png'),
                ),
                IButton4(
                    color: Colors.blue,
                    text: strings.get(304), // Change
                    textStyle: theme.text14boldWhite,
                    pressButton: () {
                      _pressCreateAccountButton();
                    }),
                IconButton(
                  onPressed: pressFacebookAuthentication,
                  iconSize: 30,
                  icon: Image.asset('assets/facebook.png'),
                ),
              ],
            ),
          ),
        ),

        /*if (appSettings.googleLogin == "true" || appSettings.facebookLogin == "true")
          _buttoniOS(),*/

        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  _login(String type, String id, String name, String photo, String email) {
    print("Reg: type=$type, id=$id, name=$name, photo=$photo");
    if (appSettings.otp == "true")
      return Navigator.push(
        context,
        MaterialPageRoute(
            /*builder: (context) => OTPScreen(
              name: name,
              email: "$id@$type.com",
              type: type,
              password: id,
              photo: photo
          ),*/
            ),
      );

    register(
        "$id@$type.com", id, name, type, photo, _okUserEnter, _error, userRole,"");

  }

  double _show = 0;
  Widget _dialogBody = Container();

  openDialog(String _text) {
    _waits(false);
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
            text: strings.get(155), // Cancel
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
        print("Facebook > " +
            profileData['id'] +
            " > " +
            profileData['email'] +
            " > " +
            profileData['email'] +
            " > " +
            profileData['name'] +
            " > " +
            profileData['picture']['data']['url']);
        //login(profileData['email'], profileData['id'], _okUserEnter, _error);
        _login("facebook", profileData['id'], profileData['name'],
            profileData['picture']['data']['url'], profileData['email']);
      }
    });
  }
}
