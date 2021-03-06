import 'dart:async';
import 'package:flutter/material.dart';
import 'package:livetraxdigitl/main.dart';
import 'package:livetraxdigitl/ui/artist/ArtistDetailScreen.dart';
import 'package:livetraxdigitl/widgets/background_image.dart';
import 'package:livetraxdigitl/widgets/ibackground4.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ////////////////////////////////////////////////////////////////
  //
  //
  //
  _startNextScreen() {
    //Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);

    account.isAuth((bool auth) {
      print("CHeck Response Auth ==> " + auth.toString());
      if (!auth)
        Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
      else {
        if (account.role == "artist") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArtistDetailScreen(
                    artist_id: account.userId,
                    artist_name: account.userName,
                    artist_description: account.description,
                    artist_image: account.userAvatar)),
          );

        }else{
          Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
        }

      }
    });
  }

  //
  //
  ////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;

  @override
  void initState() {
    pref.init();
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return Timer(duration, _startNextScreen);
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: initScreen(context),
    );
  }

  initScreen(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          color: theme.colorBackground,
        ),

        //IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient), // Background image
        background_image(),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: "SplashLogo",
                child: Container(
                  width: windowWidth * 0.3,
                  child: Image.asset("assets/logo.png", fit: BoxFit.cover),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              CircularProgressIndicator(
                backgroundColor: theme.colorCompanion,
                strokeWidth: 1,
              )
            ],
          ),
        ),
      ],
    ));
  }
}
