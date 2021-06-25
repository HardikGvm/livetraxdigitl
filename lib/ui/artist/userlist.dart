import 'package:flutter/material.dart';
import 'package:tomo_app/ui/Artist/data.dart';

Widget userList(BuildContext context, int index) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(),
      color: Colors.white  ,
    ),
    width: double.infinity,
    alignment: Alignment.center,
    height: 120,
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    child: SafeArea(
      child: Offstage(
        offstage: details[index]["isselected"],
        child: Container(
          child: GestureDetector(
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(right: 5),
                      child: Image.network(
                          "https://image.similarpng.com/very-thumbnail/2020/09/Cartoon-happy-boy-Playing-on-transparent-background-PNG.png")),
                ),
                SizedBox(
                  height: 10,
                ),
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Flexible(
                                child: Text(
                                  details[index]['mobile'],
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.purpleAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                                flex: 2,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              resetClient();
              details[index]["isselected"]=true;
              print("onTap Deleted Here.. " + details[index]['mobile'] + " VAL " + details[index]["isselected"].toString());
              PrintData();
            },
          ),
        ),
      ),
    ),
  );


}

void resetClient()  {
  for (int i = 0; i < details.length; i++) {
    details[i]["isselected"]=false;
  }
}

void PrintData()  {
  for (int i = 0; i < details.length; i++) {
    print("PRINT Deleted Here.. " + details[i]['mobile'] + " VAL " + details[i]["isselected"].toString());
  }
}
