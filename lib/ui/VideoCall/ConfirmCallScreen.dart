import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:livetraxdigitl/main.dart';
import 'package:livetraxdigitl/ui/VideoCall/call.dart';
import 'package:livetraxdigitl/ui/home/home.dart';
import 'package:livetraxdigitl/ui/model/account.dart';
import 'package:livetraxdigitl/ui/server/getagoratoken.dart';
import 'package:livetraxdigitl/widgets/background_image.dart';
import 'package:livetraxdigitl/widgets/background_image_another.dart';
import 'package:livetraxdigitl/widgets/colorloader2.dart';
import 'package:livetraxdigitl/widgets/ibutton11.dart';
import 'package:livetraxdigitl/widgets/ibutton2.dart';
import 'package:livetraxdigitl/widgets/ibutton3.dart';
import 'package:livetraxdigitl/widgets/ibutton4.dart';
import 'package:livetraxdigitl/widgets/iinputField2.dart';

class ConfirmCallScreen extends StatefulWidget {

  final String channelName;

  final String Token;

  /// non-modifiable client role of the page
  final ClientRole role;



  const ConfirmCallScreen({Key key, this.channelName, this.role, this.Token})
      : super(key: key);

  @override
  _ConfirmCallScreenState createState() => _ConfirmCallScreenState();
}

class _ConfirmCallScreenState extends State<ConfirmCallScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode fnCode = FocusNode();
  bool _autovalidate = false;

  String _code;

  bool _wait = false;



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
      appBar: AppBar(
        title: Text(strings.get(2291)),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: <Widget>[
          //IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),
          background_image_another(),
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
          child: new Text(strings.get(2290),
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
              IconButton(
                  color: Colors.orangeAccent,
                  iconSize: 80,
                  icon: new Image.asset("assets/videochat.png",),
                  onPressed: () {
                    setState(() {

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CallPage(
                            channelName: widget.channelName,
                            role: widget.role,
                            Token: widget.Token,
                          )));
                    });
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
