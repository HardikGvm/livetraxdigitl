import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:livetraxdigitl/main.dart';
import 'package:livetraxdigitl/ui/VideoCall/ConfirmCallScreen.dart';
import 'package:livetraxdigitl/ui/VideoCall/call.dart';
import 'package:livetraxdigitl/ui/server/getagoratoken.dart';
import 'package:livetraxdigitl/widgets/colorloader2.dart';

class ExclusiveAccessScreen extends StatefulWidget {
  const ExclusiveAccessScreen({Key key}) : super(key: key);

  @override
  _ExclusiveAccessScreenState createState() => _ExclusiveAccessScreenState();
}

class _ExclusiveAccessScreenState extends State<ExclusiveAccessScreen> {
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
        appBar: AppBar(
          title: Text(""),
          backgroundColor: Colors.transparent,
        ),
        body: Stack(children: [
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/sample.png"),
                fit: BoxFit.cover)),
        child: Container(
          child: Center(
            child: Form(
              key: _formKey,
              autovalidate: _autovalidate,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 28, bottom: 18, left: 18, right: 18),
                    child: TextFormField(
                      key: Key("Enter Code"),
                      autocorrect: true,
                      autofocus: false,
                      textInputAction: TextInputAction.next,
                      focusNode: fnCode,
                      onFieldSubmitted: (term) {
                        fnCode.unfocus();
                      },
                      onSaved: (val) {
                        _code = val;
                      },
                      maxLength: 10,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      maxLines: 1,
                      cursorColor: Color.fromRGBO(244, 241, 241, 1),
                      expands: false,
                      cursorWidth: 2,
                      maxLengthEnforced: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter code";
                        }
                        return null;
                      },
                      style: TextStyle(
                          color: Color.fromRGBO(244, 241, 241, 1),
                          fontSize: 15),
                      decoration: InputDecoration(
                        focusColor: Color.fromRGBO(244, 241, 241, 1),
                        labelText: " Enter Code",
                        // hintText: " Email & Username ",
                        hintMaxLines: 1,
                        contentPadding: EdgeInsets.all(4),
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(244, 241, 241, 1))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(244, 241, 241, 1))),
                        labelStyle: TextStyle(
                            color: Color.fromRGBO(244, 241, 241, 1),
                            fontSize: 12,
                            fontFamily: 'Raleway'),
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(244, 241, 241, 1),
                            fontSize: 12,
                            fontFamily: 'Raleway'),
                        errorMaxLines: 1,
                        errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red[300])),
                        errorStyle: TextStyle(
                            color: Colors.red[300],
                            fontSize: 10,
                            fontFamily: 'Raleway'),
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => doClick(context),
                    child: Text(
                      "Enter",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        width: 1.5,
                        color: Colors.white,
                        style: BorderStyle.solid,
                      ),
                      backgroundColor: Colors.black,
                      //fixedSize: Size.fromWidth(120)
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text("After code for access",
                      textAlign: TextAlign.center,
                      style: theme.text16Red)
                ],
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        child: Center(
          child: Text("Exclusive Access",
              textAlign: TextAlign.center,
              style: theme.text32boldWhite),
        ),
        height: 200,
      ),
      if (_wait)
        (Container(
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
    ]));
  }

  doClick(BuildContext context) {
    if (_formKey.currentState.validate()) {
      print("come here 1");
      _formKey.currentState.save();
      AgoraToken("asd", 13);
    } else {
      print("come here 2");
      _autovalidate = true;
    }
  }

  AgoraToken(String title, int Eventid) async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    await _handleCameraAndMic(Permission.storage);

    title = title.toString().toLowerCase().replaceAll(" ", "");
    _waits(true);
    print("User Name > " +
        account.userName.trim().replaceAll(" ", "") +
        " Title > " +
        title);
    GetAgoraToken(title, Eventid, account.userName.trim().replaceAll(" ", ""),
        token_success, token_error);
  }

  Future<void> _handleMicPermission() {
    final status = Permission.microphone.request();

    print(status);
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  _waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
  }

  token_success(
      String channelname, int eventId, String username, String _response) {
    _waits(false);
    _Token = _response;
    print("CALL _success Done ---> " + _response.toString());

    if (account.role == "artist") {
      _role = ClientRole.Broadcaster;
    }

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ConfirmCallScreen(
              channelName: channelname,
              role: _role,
              Token: _response,
            )));
  }

  token_error(String error) {
    _waits(false);
    print("CALL ERROR _success >>> " + error.toString());
    if (error == "5000") {}
    if (error == "5001") {}
  }
}
