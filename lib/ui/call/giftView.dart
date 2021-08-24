import 'package:flutter/material.dart';
import 'package:livetraxdigitl/ui/call/call.dart';
import 'package:livetraxdigitl/ui/server/listvirtualgift_model.dart';
import 'package:livetraxdigitl/widgets/ibutton10.dart';

import '../../main.dart';

class giftView extends StatefulWidget {


  @override
  _SamplePageState createState() => _SamplePageState();
}

class _SamplePageState extends State<giftView> {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
          /*new Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

              ],
            ),
            flex: 2,
          ),*/
        Container(
            width: 60,
            height: 50,
            child: Image.network(
              CallScreen.sample.image,
              fit: BoxFit.contain,
            )),
        Padding(
          padding: const EdgeInsets.all(0),
          child: Text(
            CallScreen.sample.price,
            style: TextStyle(
              color: Color(0xff00315C),
              fontSize: 16.0,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
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
    );
  }
}
