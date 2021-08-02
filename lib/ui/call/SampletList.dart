
import 'package:flutter/material.dart';
import 'package:tomo_app/ui/call/call.dart';
import 'package:tomo_app/ui/server/listvirtualgift_model.dart';

import '../../main.dart';

class SampleList extends StatefulWidget {

  List<data> _responseList= [];
  BuildContext context;
  int index;


  SampleList(BuildContext context,int index,List<data> _responseList){
    this.context=context;
    this.index=index;
    this._responseList=_responseList;
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


  Widget Sample()  {

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // What do i do here?
              for(int i=0;i<widget._responseList.length;i++){
                widget._responseList[widget.index].isSelected=false;
              }

              widget._responseList[widget.index].isSelected=true;
              CallScreen.sample = widget._responseList[widget.index];
              print("Check Selection here >> VALSS " + CallScreen.sample.price);
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
                color: widget._responseList[widget.index].isSelected
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
                          widget._responseList[widget.index].image,
                          fit: BoxFit.contain,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text(
                      "\$ "+widget._responseList[widget.index].price,
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
  }
}
