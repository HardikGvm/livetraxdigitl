import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:livetraxdigitl/main.dart';
import 'package:livetraxdigitl/ui/Artist/data.dart';
import 'package:livetraxdigitl/ui/server/getplaylistByArtist.dart';
import 'package:livetraxdigitl/ui/server/musicplaylist.dart';
import 'package:livetraxdigitl/widgets/ibutton10.dart';

class ProductList extends StatefulWidget {
  List<PalyList> list;

  ProductList(this.list);

  @override
  _ProductListState createState() => _ProductListState();
}

double TotalPay = 0;
String textHolder = strings.get(2293);

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
          child: new Flexible(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: ListView.builder(
                  itemCount: widget.list.length,
                  itemBuilder: (BuildContext context, int index) {
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
                                    image:
                                        AssetImage('assets/images/sample.png'),
                                    fit: BoxFit.fill,
                                    alignment: Alignment.topCenter)),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SafeArea(
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Flexible(
                                      child: Text(
                                        widget.list[index].title,
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      flex: 2,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    widget.list[index].isSelected
                                        ? Center(
                                            child: IconButton(
                                                icon: Icon(Icons.delete_rounded,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  PerformCard(index);
                                                }),
                                          )
                                        : Center(
                                            child: IconButton(
                                                icon: Icon(
                                                    Icons
                                                        .add_shopping_cart_sharp,
                                                    color: Colors.green),
                                                onPressed: () {
                                                  PerformCard(index);
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
                  }),
            ),
            flex: 1,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          child: Align(
            alignment: Alignment.topRight,
            child: IButton10(
                color: (TotalPay != 0) ? Colors.blue : Colors.blueGrey,
                text: '$textHolder', // Change
                textStyle: theme.text14boldWhite,
                pressButton: () {
                  setState(() {
                    //widget.callBack(CallScreen.sample.image);
                  });
                }),
          ),
        )
      ],
    );
  }

  PerformCard(int index) {
    print('Live Event --> ' + (widget.list[index].isSelected).toString());
    if (widget.list[index].isSelected) {
      widget.list[index].isSelected = false;
      TotalPay = TotalPay -
          double.parse(details[index]['mobile']
              .toString()
              .trim()
              .replaceFirst("\$", ""));
      /*widget.callBack(
          widget.list[widget.index], false, details[widget.index]['mobile']);*/
    } else {
      widget.list[index].isSelected = true;
      TotalPay = TotalPay +
          double.parse(details[index]['mobile']
              .toString()
              .trim()
              .replaceFirst("\$", ""));
      /*widget.callBack(
          widget.list[widget.index], true, details[widget.index]['mobile']);*/
    }

    if (TotalPay != 0) {
      textHolder = strings.get(2293) + "" + TotalPay.toString();
    } else {
      textHolder = strings.get(2293);
    }
    setState(() {});
  }
}

@override
void dispose() {
  //Widget.TotalPay = 0;
}

/*Widget ProductList(
    BuildContext context, int index, List<MusicData> list, Function callBack) {
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
              SafeArea(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Flexible(
                    child: Text(
                      list[index].title,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    flex: 2,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  list[index].isSelected
                      ? Center(
                          child: IconButton(
                              icon:
                                  Icon(Icons.delete_rounded, color: Colors.red),
                              onPressed: () {
                                print('Live Event');
                                callBack(list[index]);
                              }),
                        )
                      : Center(
                          child: IconButton(
                              icon: Icon(Icons.add_shopping_cart_sharp,
                                  color: Colors.green),
                              onPressed: () {
                                print('Live Event');
                                if (list[index].isSelected) {
                                  list[index].isSelected = false;
                                } else {
                                  list[index].isSelected = true;
                                }
                                callBack(list[index]);
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
}*/
