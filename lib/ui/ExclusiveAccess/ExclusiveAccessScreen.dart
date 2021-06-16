import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                    padding: EdgeInsets.only(top: 28, bottom: 18, left: 18, right: 18),
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
                            borderSide:
                                BorderSide(color: Color.fromRGBO( 244, 241, 241, 1))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Color.fromRGBO(244, 241, 241, 1))),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  doClick(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    } else {
      _autovalidate = true;
    }
  }
}
