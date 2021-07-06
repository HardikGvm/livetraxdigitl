import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tomo_app/widgets/widgets.dart';

import '../main.dart';

// 25.10.2020

class ICard32FileCaching extends StatefulWidget {
  final Color color;
  final double width;
  final Color colorProgressBar;
  final double height;
  final String text;
  final String price;
  final String discountprice;
  final String text3;
  final String image;
  final String id;
  final TextStyle textStyle;
  final TextStyle textStyle2;
  final TextStyle textStyle3;
  final bool enableFavorites;
  final Function(String) getFavoriteState;
  final Function(String) revertFavoriteState;
  final Function(String id, String heroId) callback;
  final double radius;
  final int shadow;
  final String dicount;
  final Function(String) onAddToCartClick;

  ICard32FileCaching({this.color = Colors.white, this.width = 100, this.height = 100,
    this.text = "", this.image = "", this.textStyle2, this.price = "", this.getFavoriteState, this.revertFavoriteState,
    this.id = "", this.textStyle, this.callback, this.colorProgressBar = Colors.black, this.enableFavorites = true,
    this.text3 = "", this.textStyle3, this.onAddToCartClick,
    this.radius, this.shadow, this.discountprice, this.dicount
  });

  @override
  _ICard32FileCachingState createState() => _ICard32FileCachingState();
}

class _ICard32FileCachingState extends State<ICard32FileCaching>{

  var _textStyle = TextStyle(fontSize: 16);
  var _textStyle2 = TextStyle(fontSize: 16);
  var _textStyle3 = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    var _id = UniqueKey().toString();
    if (widget.textStyle != null)
      _textStyle = widget.textStyle;
    if (widget.textStyle2 != null)
      _textStyle2 = widget.textStyle2;
    if (widget.textStyle3 != null)
      _textStyle3 = widget.textStyle3;

    Widget _favorites = Container();
    if (widget.enableFavorites)
      _favorites = Container(
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 5, right: 5),
        child: Stack(
          children: <Widget>[
            Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Icon((widget.getFavoriteState(widget.id)) ? Icons.favorite : Icons.favorite_border, color: widget.colorProgressBar, size: 20,),
                  ],
                )
            ),
            Positioned.fill(
              child: Material(
                  color: Colors.transparent,
                  shape: CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.grey[400],
                    onTap: (){
                      widget.revertFavoriteState(widget.id);
                    }, // needed
                  )),
            )
          ],
        ),
      );

    return InkWell(
        onTap: () {
      if (widget.callback != null)
        widget.callback(widget.id, _id);
    }, // needed
    child: Container(
          width: widget.width,
          height: widget.height-20,
          decoration: BoxDecoration(
              color: widget.color,
              border: Border.all(color: Colors.black.withAlpha(100)),
              borderRadius: new BorderRadius.circular(widget.radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(widget.shadow),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(2, 2), // changes position of shadow
                ),
              ]
          ),
          child: Stack(
            children: [
              Hero(
                  tag: _id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                    child:Container(
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            UnconstrainedBox(child:
                            Container(
                              alignment: Alignment.center,
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator()
                            )),
                        imageUrl: widget.image,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        errorWidget: (context,url,error) => new Icon(Icons.error),
                      ),
                    ),
                  )
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {
                      widget.onAddToCartClick(widget.id);
                    },
                    child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: theme.colorPrimary.withAlpha(220),
                      border: Border.all(color: theme.colorPrimary),
                      borderRadius: new BorderRadius.only(topLeft: Radius.circular(30)),
                    ),
                    child: UnconstrainedBox(
                        child: Container(
                          margin: EdgeInsets.only(top: 10, left: 10),
                            height: 30,
                            width: 30,
                            child: Image.asset("assets/addtocart.png",
                                fit: BoxFit.contain, color: Colors.white,
                            )
                        )),
                  )),
                  InkWell(
                      onTap: () {
                        if (widget.callback != null)
                          widget.callback(widget.id, _id);
                      }, // needed
                      child: ClipRRect(
                          borderRadius: new BorderRadius.only(bottomLeft: Radius.circular(widget.radius-2), bottomRight: Radius.circular(widget.radius-2)),
                          child: Container(
                        width: widget.width+10,
                        color: Colors.black.withAlpha(100),
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(widget.text, style: _textStyle, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left,),
                            Row(
                              children: [
                                Expanded(child: Text(widget.text3, style: _textStyle3, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,)),
                                Text((widget.discountprice.isNotEmpty) ? widget.discountprice : widget.price, style: _textStyle2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,),
                              ],
                            ),
                            SizedBox(height: 5,)
                          ],
                        ),
                      ))),

                ],
              ),

              _favorites,

              if (widget.discountprice.isNotEmpty)
                saleSticker(widget.width, widget.dicount, widget.discountprice, widget.price)
            ],
          ),
    ));
  }
}