import 'package:flutter/material.dart';
import 'package:livetraxdigitl/main.dart';
import 'package:livetraxdigitl/ui/server/forgot.dart';
import 'package:livetraxdigitl/widgets/background_image.dart';
import 'package:livetraxdigitl/widgets/colorloader2.dart';
import 'package:livetraxdigitl/widgets/easyDialog2.dart';
import 'package:livetraxdigitl/widgets/iappBar.dart';
import 'package:livetraxdigitl/widgets/ibutton3.dart';
import 'package:livetraxdigitl/widgets/iinputField2a.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen>
    with SingleTickerProviderStateMixin {
  _pressSendButton() {
    print("User pressed \"SEND\" button");
    print("E-mail: ${editControllerEmail.text}");
    if (editControllerEmail.text.isEmpty)
      return openDialog(strings.get(176)); // "Enter your E-mail"
    if (!_validateEmail(editControllerEmail.text))
      return openDialog(strings.get(178)); // "Your E-mail is incorrect"
    _waits(true);
    forgotPassword(editControllerEmail.text, _success, _error);
  }

  var windowWidth;
  var windowHeight;
  final editControllerEmail = TextEditingController();
  bool _wait = false;
  bool sendButton = true;

  _error(String error) {
    _waits(false);
    if (error == "5000")
      return openDialog(
          strings.get(156)); //  "User with this Email was not found!",
    if (error == "5001")
      return openDialog(strings
          .get(157)); //  "Failed to send Email. Please try again later.",
    if (error == "User not found!") return openDialog(strings.get(178));

    openDialog("${strings.get(178)} $error"); // "Something went wrong. ",
  }

  _waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
  }

  _success(String message) {
    _waits(false);
    sendButton = false;
    openDialog(
        message); // "A letter with a new password has been sent to the specified E-mail",
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    route.disposeLast();
    editControllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!sendButton) {
      Future.delayed(const Duration(seconds: 60), () {
        if (this.mounted) {
          setState(() {
            sendButton = true;
          });
        }
      });
    }
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: theme.colorBackground,
        body: Directionality(
          textDirection: strings.direction,
          child: Stack(
            children: <Widget>[
              /*IBackground4(
                  width: windowWidth, colorsGradient: theme.colorsGradient),*/
              background_image(),
              IAppBar(context: context, text: "", color: Colors.white),
              Center(
                  child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                width: windowWidth,
                child: _body(),
              )),
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
        ));
  }

  _body() {
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
          width: windowWidth * 0.3,
          height: windowWidth * 0.3,
          child: Image.asset("assets/logo.png", fit: BoxFit.contain),
        )),
        Container(
          width: windowWidth,
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            strings.get(17), // "Forgot password"
            style: theme.text20boldWhite, textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2a(
              hint: strings.get(18), // "E-mail address"
              icon: Icons.alternate_email,
              colorDefaultText: Colors.white,
              controller: editControllerEmail,
            )),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),
        SizedBox(
          height: 25,
        ),
        Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: sendButton
                ? IButton3(
                    color: Colors.blue,
                    text: strings.get(19),
                    textStyle: theme.text14boldWhite,
                    // SEND
                    pressButton: () {
                      _pressSendButton();
                    })
                : IButton3(
                    color: Colors.grey,
                    text: strings.get(19),
                    textStyle: theme.text14boldWhite,
                    // SEND
                    pressButton: () {
                      // _pressSendButton();
                    })),
        SizedBox(
          height: 25,
        ),
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

  bool _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value.toString().trim()))
      return false;
    else
      return true;
  }
}
