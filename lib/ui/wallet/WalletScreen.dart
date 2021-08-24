import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:need_resume/need_resume.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:livetraxdigitl/ui/artist/data.dart';
import 'package:livetraxdigitl/ui/call/call.dart';
import 'package:livetraxdigitl/ui/event/AddEventScreen.dart';
import 'package:livetraxdigitl/ui/model/pref.dart';
import 'package:livetraxdigitl/ui/products/AddProductScreen.dart';
import 'package:livetraxdigitl/ui/server/DeleteEvent.dart';
import 'package:livetraxdigitl/ui/server/EventListAPI.dart';
import 'package:livetraxdigitl/ui/server/getagoratoken.dart';
import 'package:livetraxdigitl/widgets/colorloader2.dart';
import 'package:livetraxdigitl/widgets/ibutton3.dart';

import '../../main.dart';

class WalletListScreen extends StatefulWidget {
  const WalletListScreen({key}) : super(key: key);

  @override
  _WalletListScreenState createState() => _WalletListScreenState();
}

class _WalletListScreenState extends ResumableState<WalletListScreen> {
  bool _wait = false;
  var windowWidth;
  var windowHeight;
  bool isChanges = false;

  bool isArtist = true;

  @override
  void onReady() {
    //callAPI();
    super.onReady();
  }

  @override
  void onResume() {
    print("::: On Resume ::: ");
    isChanges = pref.getBool(Pref.isChanges);
    if (isChanges) {
      pref.setBool(Pref.isChanges, false);
      callAPI();
    }
    super.onResume();
  }

  @override
  void onPause() {
    super.onPause();
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    //isArtist = (account.role == "artist");
    print("Check List > " + isArtist.toString());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('WALLET'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Stack(
        children: [
          new ListView.separated(
            itemCount: details == null || details.isEmpty ? 0 : details.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 5,
                child: const DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.black),
                ),
              );
            },
            itemBuilder: (BuildContext ctxt, int index) {
              return Container(
                //height: 180,
                color: Color.fromARGB(247, 247, 247, 255),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      new Flexible(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            child: Icon(
                              (details[index]['mobile'].toString().contains("-")) ?
                              Icons.arrow_circle_down : Icons.arrow_circle_up,
                              color: (details[index]['mobile'].toString().contains("-")) ? Colors.redAccent : Colors.green,
                            ),
                            width: 60.0,
                            height: 60.0,
                          ),
                        ),
                        flex: 1,
                      ),
                      new Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(details[index]['name'],
                                      style: theme.text16boldPimary,
                                    ),
                                  ),
                                  Visibility(
                                    child: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Text(
                                        details[index]['mobile'],
                                        style: (details[index]['mobile'].toString().contains("-")) ? theme.text16boldRed : theme.text16boldGreen,
                                      ),
                                    ),
                                    visible: isArtist,
                                  )
                                ],
                              ),
                              Text(
                                details[index]['date'],
                                style: theme.text12grey,
                              ),
                            ],
                          ),
                        ),
                        flex: 2,
                      )
                    ],
                  ),
                ),
              );
            },
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
        ],
      ),
    );
  }

  _event(String artist, int page, int limit) {
    print("::::Data::::");
    if (!isArtist) {
      artist = "";
    }
    event_list_api(artist, page, limit, _onSuccessEventList, _error);
  }

  _waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
  }

  _error(String error) {
    _waits(false);
    print("Get message here " + error);
    openDialog("${strings.get(158)} $error"); // "Something went wrong. ",
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

  _onSuccessEventList(List<EventData> list) {
    _waits(false);

    setState(() {});
  }

  _onSuccessDelete(String message, int index) {
    _waits(false);

    print("::: Data deleted :::" + index.toString());

    setState(() {});
  }

  void callAPI() {
    _waits(true);

    _event(account.userId, 1, 0);
  }

  bool isVisibility(int index) {
    bool isVisible = false;

    return isVisible;
  }


}
