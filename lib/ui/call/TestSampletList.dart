import 'package:flutter/material.dart';
import 'package:livetraxdigitl/ui/server/listvirtualgift.dart';
import 'package:livetraxdigitl/ui/server/listvirtualgift_model.dart';
import 'package:livetraxdigitl/widgets/colorloader2.dart';
import 'package:livetraxdigitl/widgets/ibutton10.dart';

import '../../main.dart';

class SampleList extends StatefulWidget {
  @override
  _SamplePageState createState() => _SamplePageState();
}

class _SamplePageState extends State<SampleList> {
  int _languageIndex = -1;
  data sample;
  bool _wait = false;
  var windowWidth;
  var windowHeight;
  List<data> _responseList= [];
  //List<int> selectedIndexList = new List<int>();

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;



    return Sample();
  }

  @override
  void initState() {
    LoadVirtualgift();

    super.initState();
  }

  @override
  void dispose() {
    route.disposeLast();
    super.dispose();
  }

  LoadVirtualgift() {
    _waits(true);
    listVirtualGift(_success, _error);
  }

  _success(List<data> _response) {
    _waits(false);
    _responseList=_response;
    print("CALL _success Done ---> " + _response.length.toString());
    /*openDialog(strings.get(
        135)); // "A letter with a new password has been sent to the specified E-mail",*/
  }

  _error(String error) {
    _waits(false);
    print("CALL ERROR _success >>> " + error.toString());
    if (error == "5000") {}
    if (error == "5001") {
    }
  }

  _waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
  }

  Widget Sample() {
    return Expanded(
        child: SizedBox(
      height: 300,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              strings.get(2241),
              style: TextStyle(
                color: Color(0xff00315C),
                fontSize: 16.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                scrollDirection: Axis.vertical,
                itemCount: _responseList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            // What do i do here?
                            setState(() {
                              _languageIndex = index;
                              sample = _responseList[index];
                            });
                          },
                          child: Container(
                            height: 80,
                            width: 80,
                            alignment: Alignment.center,
                            transformAlignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: _languageIndex == index
                                  ? Color.fromRGBO(143, 17, 250, 0.5)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(1.0, 10.0),
                                  blurRadius: 10.0,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: Container(
                                      width: 60,
                                      height: 50,
                                      child: Image.network(
                                        _responseList[index].image,
                                        fit: BoxFit.contain,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Text(
                                    _responseList[index].price,
                                    style: TextStyle(
                                      color: Color(0xff00315C),
                                      fontSize: 12.0,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SafeArea(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (_languageIndex != -1)
                      new Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SafeArea(
                              child: Container(
                                  width: 60,
                                  height: 50,
                                  child: Image.network(
                                    sample.image,
                                    fit: BoxFit.contain,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: Text(
                                sample.price,
                                style: TextStyle(
                                  color: Color(0xff00315C),
                                  fontSize: 16.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        flex: 2,
                      ),
                    SizedBox(
                      width: 5,
                    ),
                    Center(
                      child: IButton10(
                          color: Colors.blue,
                          text: strings.get(19), // Change
                          textStyle: theme.text14boldWhite,
                          pressButton: () {
                            setState(() {});
                          }),
                    ),
                  ],
                ))
              ],
            ),
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
        ],
      ),
    ));
  }
}
