import 'package:flutter/material.dart';
import 'package:tomo_app/ui/artist/data.dart';

Widget ProductList(BuildContext context, int index) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(),
      color: Colors.white,
    ),
    width: double.infinity,
    height: 100,
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                    details[index]['name'],
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.blue,
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
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 13,
                            letterSpacing: .3)),
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
