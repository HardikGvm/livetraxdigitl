import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:livetraxdigitl/main.dart';
import 'package:livetraxdigitl/ui/Artist/data.dart';
import 'package:livetraxdigitl/ui/server/musicplaylist.dart';

Widget ProductList(BuildContext context, int index,List<MusicData> list) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(),
      color: Colors.white,
    ),
    width: double.infinity,
    height: 90,
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Center(
          child: Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.only(right: 5),
              child: Image(
                  image: AssetImage('assets/images/sample.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter)),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Flexible(child: Text(
                    list[index].title,
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),flex: 2,)
                  ,
                  SizedBox(
                    width: 5,
                  ),
                  Center(
                    child: IconButton(
                        icon: Icon(Icons.add_shopping_cart_sharp, color: Colors.red),
                        onPressed: () {
                          print('Live Event');
                        }),
                  ),
                ],
              )),
              SizedBox(
                height: 6,
              ),
              SafeArea(
                child: Row(
                  children: <Widget>[
                    Text(details[index]['mobile'],
                        style: theme.text14boldBlack),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
