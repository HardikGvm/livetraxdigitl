import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livetraxdigitl/main.dart';
import 'package:livetraxdigitl/ui/home/home.dart';
import 'package:livetraxdigitl/widgets/background_image.dart';
import 'package:livetraxdigitl/widgets/ibutton11.dart';

class ConfirmMusicPurchaseScreen extends StatefulWidget {
  const ConfirmMusicPurchaseScreen({Key key}) : super(key: key);

  @override
  _ConfirmMusicPurchaseScreenState createState() =>
      _ConfirmMusicPurchaseScreenState();
}

class _ConfirmMusicPurchaseScreenState
    extends State<ConfirmMusicPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode fnCode = FocusNode();
  bool _autovalidate = false;
  String _code;

  bool _wait = false;

  String _Token;
  ClientRole _role = ClientRole.Audience;

  var windowWidth;
  var windowHeight;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
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
        ],
      ),
    );
  }

  _body() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          width: windowWidth * 0.50,
          height: windowWidth * 0.50,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: new NetworkImage(account.userAvatar),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white, width: 1.0, style: BorderStyle.solid)),
          ),
        ),
        SizedBox(
          height: 60,
        ),
        new Center(
          child: new Text(strings.get(2289),
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                  fontStyle: FontStyle.italic,
                  fontSize: 30,
                  color: Colors.white)),
        ),
        SizedBox(
          height: windowHeight * 0.15,
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IButton11(
                  color: Colors.orangeAccent,
                  text: strings.get(2288), // Change
                  textStyle: theme.text16boldWhite,
                  pressButton: () {
                    setState(() {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                          ModalRoute.withName("/home"));
                    });
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
