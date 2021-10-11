import 'package:flutter/material.dart';

void main() {
  runApp(background_image_temp());
}

class background_image_temp extends StatelessWidget {
  // This widget is the root of your application.

  final _channelMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
          /*appBar: new AppBar(
            title: new Text("widget"),
          ),*/
          body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage('assets/images/sample.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(width * 0.10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(
                            height: height * 0.10,
                          ),
                          Container(
                            decoration:
                                BoxDecoration(color: Colors.transparent),
                            child: Container(
                              margin: EdgeInsets.only(
                                  bottom: height * 0.02,
                                  left: 20.0,
                                  right: 20.0),
                              child: Image.asset('assets/images/logo.png'),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          Container(
                              decoration:
                                  BoxDecoration(color: Colors.transparent),
                              child: Container()),
                          GestureDetector(
                              child: new TextField(
                                  cursorColor: Colors.blue,
                                  textInputAction: TextInputAction.go,
                                  //onSubmitted: _toggleSendChannelMessage,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  controller: _channelMessageController,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Comment',
                                    hintStyle: TextStyle(color: Colors.white),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                  )),
                              onTap: () {
                                // call this method here to hide soft keyboard
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              })
                        ],
                      ),
                    ),
                  ),
                ],
              )) // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }
}
