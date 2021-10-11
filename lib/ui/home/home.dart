import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:livetraxdigitl/main.dart';
import 'package:livetraxdigitl/ui/Artist/ArtistList.dart';
import 'package:livetraxdigitl/ui/ExclusiveAccess/ExclusiveAccessScreen.dart';
import 'package:livetraxdigitl/ui/call/call.dart';
import 'package:livetraxdigitl/ui/event/EventListScreen.dart';
import 'package:livetraxdigitl/ui/home/data_user.dart';

import 'package:livetraxdigitl/ui/server/getagoratoken.dart';
import 'package:livetraxdigitl/widgets/background_image.dart';
import 'package:livetraxdigitl/widgets/colorloader2.dart';
import 'package:livetraxdigitl/widgets/easyDialog2.dart';
import 'package:livetraxdigitl/widgets/ibutton3.dart';

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
      /*if (theme.appType == "multivendor")
        return openDialog(strings.get(251));*/ // "Need user with role Vendor",
      return openDialog(
          strings.get(13)); // "Need user with role Administrator or Manager",
    }
    openDialog("${strings.get(158)} $error"); // "Something went wrong. ",
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    MacOSInitializationSettings _MacOSInitializationSettings;

    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message ${message}');
        // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
        displayNotification(message);
        // _showItemDialog(message);
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("TOKEN HERE >> " + token);
    });

    super.initState();
  }

  Future displayNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channelid', 'flutterfcm', 'your channel description',
        importance: Importance.max, priority: Priority.high);

    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    var _rows;
    if (message[''] != null) {
      _rows = message[''].cast<String>().toList();
      print("Check Message " + _rows.toString());
    }
    print("Check Message " + message.toString());
    /*await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: 'hello',
    );*/
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Fluttertoast.showToast(
        msg: "Notification Clicked",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
    /*Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    );*/
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Fluttertoast.showToast(
                  msg: "Notification Clicked",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ),
        ],
      ),
    );
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
          Image(
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.width * 0.45,
              image: AssetImage('assets/applogo.png')),
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            alignment: Alignment.bottomCenter,
            width: windowWidth,
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Container(
                    child: Stack(children: <Widget>[
                  GetBottomOption(),
                  _toolbar(),
                  _messageList()
                ]))),
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

  Widget GetBottomOption() {
    return Container(
      color: Colors.transparent,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        padding: EdgeInsets.all(3.0),
        children: <Widget>[
          makeDashboardItem("Artist", Icons.supervised_user_circle_sharp,
              "assets/artists.png"),
          makeDashboardItem("Live Event", Icons.music_note, "assets/play.png"),
          makeDashboardItem(
              "Exclusive\nAccess", Icons.verified_user, "assets/vip.png"),
        ],
      ),
    );
  }

  Widget _toolbar() {
    return Container(
      height: 500,
      alignment: Alignment.centerRight,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          alignment: Alignment.topRight,
          padding: const EdgeInsets.symmetric(vertical: 30),
          constraints: BoxConstraints(maxHeight: 400),
          child: Container(
            height: 200,
            color: Colors.transparent,
            alignment: Alignment.topRight,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                GestureDetector(
                    child: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(
                            top: 10, bottom: 0, left: 20, right: 20),
                        child: Icon(
                          Icons.person,
                          size: 40.0,
                          color: Colors.white,
                        )),
                    onTap: () {
                      print("Press Profile");
                      Navigator.pushNamed(context, "/account");
                      //Navigator.pushNamed(context, "/homescreen");
                    }),
                SizedBox(height: 5.0),
                GestureDetector(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: new Text("My Account",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontSize: 16.0, color: Colors.white)),
                    ),
                    onTap: () {
                      print("Press Profile");
                      Navigator.pushNamed(context, "/account");
                      //Navigator.pushNamed(context, "/homescreen");
                    }),
                SizedBox(height: 15.0),
                if (account.role == "artist")
                  GestureDetector(
                      child: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(
                              top: 10, bottom: 0, left: 20, right: 20),
                          child: Icon(
                            Icons.add_business_rounded,
                            size: 40.0,
                            color: Colors.white,
                          )),
                      onTap: () {
                        print("Press Profile");
                        Navigator.pushNamed(context, "/addproducts");
                      })
                else
                  Container(),
                if (account.role == "artist")
                  SizedBox(height: 5.0)
                else
                  Container(),
                if (account.role == "artist")
                  GestureDetector(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: new Text("Add Products",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 16.0, color: Colors.white)),
                      ),
                      onTap: () {
                        print("Press Profile..");
                        Navigator.pushNamed(context, "/addproducts");
                      })
                else
                  Container()
              ],
            ),
          ),
        ),
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
        makeDashboardItem("Ordbog", Icons.book, ""),
        makeDashboardItem("Alphabet", Icons.alarm, ""),
        makeDashboardItem("Sample", Icons.ac_unit_rounded, ""),
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

  Card makeDashboardItem(String title, IconData icon, String icons) {
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
                //AgoraToken();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventListScreen(artist_id: "",)),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 5.0),
                Center(
                  /*child: Icon(
                      icon,
                      size: 40.0,
                      color: Colors.white,
                    )*/
                  child: Container(
                    child: Image(
                        image: AssetImage(icons),
                        fit: BoxFit.fill,
                        height: 40,
                        alignment: Alignment.topCenter),
                  ),
                ),
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
    print("User Name > " + account.userName.trim().replaceAll(" ", ""));
    GetAgoraToken("asd", 0, account.userName.trim().replaceAll(" ", ""),
        token_success, token_error);
    //}
  }

  token_success(
      String channelname, int Eventid, String username, String _response) {
    _waits(false);
    _Token = _response;
    print("CALL _success Done ---> " + _response.toString());

    if (account.role == "artist") {
      _role = ClientRole.Broadcaster;
    }

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CallScreen(
              channelName: channelname,
              Eventid: 0,
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

  Widget _messageList() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        heightFactor: 0.6,
        widthFactor: 0.55,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ListView.builder(
            reverse: true,
            itemCount: details_user.length,
            itemBuilder: (BuildContext context, int index) {
              if (details_user.isEmpty) {
                return null;
              }
              return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 5, top: 5, left: 10, right: 10),
                    child:
                        Stack(alignment: Alignment.topRight, children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white54,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          border: Border.all(width: 1.0, color: Colors.white),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CachedNetworkImage(
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              imageUrl: details_user[index]["image"],
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
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
                                    details_user[index]["name"],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, top: 10, left: 0, right: 0),
                          child: Icon(
                            Icons.music_note_outlined,
                            color: Colors.green,
                          ),
                        ),
                        width: 30.0,
                        height: 30.0,
                      )
                    ]),
                  ));
            },
          ),
        ),
      ),
    );
  }
}
