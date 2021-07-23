import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tomo_app/ui/merchandise/home.dart';
import 'package:tomo_app/widgets/widgets.dart';

import '../main.dart';
import 'ibutton11.dart';

// 11.10.2020 radius and shadow

class ICard81FileCaching extends StatefulWidget {
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
  final String discount;
  final Function(String) onAddToCartClick;
  final bool needAddToCart;

  ICard81FileCaching(
      {this.color = Colors.white,
      this.width = 100,
      this.height = 100,
      this.text = "",
      this.image = "",
      this.textStyle2,
      this.price = "",
      this.getFavoriteState,
      this.revertFavoriteState,
      this.id = "",
      this.textStyle,
      this.callback,
      this.colorProgressBar = Colors.black,
      this.enableFavorites = true,
      this.text3 = "",
      this.textStyle3,
      this.onAddToCartClick,
      this.radius,
      this.shadow,
      this.discountprice,
      this.discount,
      this.needAddToCart = true});

  @override
  _ICard81FileCachingState createState() => _ICard81FileCachingState();
}

class _ICard81FileCachingState extends State<ICard81FileCaching> {
  var _textStyle = TextStyle(fontSize: 16);
  var _textStyle2 = TextStyle(fontSize: 16);
  var _textStyle3 = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    var _id = UniqueKey().toString();
    if (widget.textStyle != null) _textStyle = widget.textStyle;
    if (widget.textStyle2 != null) _textStyle2 = widget.textStyle2;
    if (widget.textStyle3 != null) _textStyle3 = widget.textStyle3;

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
                    Icon(
                      (widget.getFavoriteState(widget.id))
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.colorProgressBar,
                      size: 20,
                    ),
                  ],
                )),
            Positioned.fill(
              child: Material(
                  color: Colors.transparent,
                  shape: CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.grey[400],
                    onTap: () {
                      print("CLICKKK");
                      widget.revertFavoriteState(widget.id);
                    }, // needed
                  )),
            )
          ],
        ),
      );

    Widget _sale = Container();
    if (widget.discountprice != null && widget.discountprice.isNotEmpty) {
      var t = widget.width;
      if (t == MediaQuery.of(context).size.width) t /= 2;
      _sale =
          saleSticker(t, widget.discount, widget.discountprice, widget.price);
    }

    return InkWell(
        onTap: () {
          if (widget.callback != null) widget.callback(widget.id, _id);
        }, // needed
        child: Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          width: widget.width,
          height: widget.height - 20,
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
              ]),
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  Expanded(
                      child: Stack(
                    children: [
                      Hero(
                          tag: _id,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(widget.radius),
                                topRight: Radius.circular(widget.radius)),
                            child: Container(
                              child: CachedNetworkImage(
                                placeholder: (context, url) => UnconstrainedBox(
                                    child: Container(
                                  alignment: Alignment.center,
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(),
                                )),
                                imageUrl: widget.image,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    new Icon(Icons.error),
                              ),
                            ),
                          )),
                    ],
                  )),
                  InkWell(
                      onTap: () {
                        if (widget.callback != null)
                          widget.callback(widget.id, _id);
                      },
                      child: Container(
                        width: widget.width,
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              widget.text,
                              style: _textStyle,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  if (widget.needAddToCart)
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: IButton11(
                          color: Colors.orangeAccent,
                          text: strings.get(2247) + "    " + homeScreen.mainWindowData.currency + widget.price, // Change
                          textStyle: theme.text14boldBlack,
                          pressButton: () {
                            Navigator.pushNamed(context, "/address");
                            setState(() {});
                          }),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              _favorites,
              /*_sale,*/
            ],
          ),
        ));
  }
}
