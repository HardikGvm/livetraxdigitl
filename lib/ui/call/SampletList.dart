import 'package:flutter/material.dart';
import 'package:tomo_app/ui/call/call.dart';
import 'package:tomo_app/ui/server/listvirtualgift_model.dart';
import 'package:tomo_app/widgets/ibutton10.dart';

import '../../main.dart';

class SampleList extends StatefulWidget {
  List<data> _responseList = [];
  BuildContext context;
  int index;
  Function callBack;
  int SelectedID = -1;

  SampleList(BuildContext context, int index, List<data> _responseList,
      Function callBack) {
    this.context = context;
    this.callBack = callBack;
    this.index = index;
    this._responseList = _responseList;
  }

  @override
  _SamplePageState createState() => _SamplePageState();
}

class _SamplePageState extends State<SampleList> {
  bool _wait = false;
  var windowWidth;
  var windowHeight;

  //List<int> selectedIndexList = new List<int>();

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    print("Refresh SCRENN HERE>> ");

    return Sample();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    route.disposeLast();
    super.dispose();
  }

  Widget Sample() {
    return Container(
        child: Scaffold(
            backgroundColor: theme.colorBackground,
            body: Column(
              children: <Widget>[
                Expanded(
                    child: GridView.builder(
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 2),
                        ),
                        scrollDirection: Axis.vertical,
                        itemCount: widget._responseList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    // What do i do here?
                                    /*for(int i=0;i<widget._responseList.length;i++){
                      widget._responseList[widget.index].isSelected=false;
                    }*/

                                    //widget._responseList[widget.index].isSelected=true;
                                    widget.SelectedID = index;
                                    CallScreen.sample =
                                        widget._responseList[index];
                                    print("Check Selection here >> VALSS " +
                                        CallScreen.sample.price);
                                    setState(() {

                                    });
                                  },
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    alignment: Alignment.center,
                                    transformAlignment: Alignment.center,
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: (widget.SelectedID == index)
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: Container(
                                              width: 60,
                                              height: 50,
                                              child: Image.network(
                                                widget
                                                    ._responseList[index].image,
                                                fit: BoxFit.contain,
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0),
                                          child: Text(
                                            "\$ " +
                                                widget
                                                    ._responseList[index].price,
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
                        })),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: 60,
                              height: 50,
                              child: (CallScreen.sample != null)
                                  ? Image.network(
                                      CallScreen.sample.image,
                                      fit: BoxFit.contain,
                                    )
                                  : Container()),
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              (CallScreen.sample != null) ? CallScreen.sample.price : "",
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
                            setState(() {
                              widget.callBack(CallScreen.sample.image);
                            });
                          }),
                    ),
                  ],
                )
              ],
            )));
  }
}
