import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tomo_app/ui/config/api.dart';
import 'package:tomo_app/ui/merchandise/homescreenModel.dart';
import 'package:tomo_app/ui/model/categories.dart';
import 'package:tomo_app/ui/model/foods.dart';

import '../main.dart';
import 'ICard21FileCaching.dart';

headerMenuWidget(
    var context, Function(String) callback, Color _color, String title) {
  return _headerWidget2(
      context, callback, _color, title, _buttonMenu(callback, _color));
}

headerWidget(
    var context, Function(String) callback, Color _color, String title) {
  return _headerWidget2(
      context, callback, _color, title, _buttonBack(callback, _color));
}

_headerWidget2(var context, Function(String) callback, Color _color,
    String title, Widget firstIcon) {
  var _userAuth = true;
  return Container(
    height: 40,
    margin: EdgeInsets.only(
        left: 10, right: 10, top: 5 + MediaQuery.of(context).padding.top),
    child: Row(
      children: [
        firstIcon,
        Expanded(
            child: Text(
          title,
          textDirection: strings.direction,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: theme.text16bold,
        )),
        //if (restaurantSearchValue != "0" || categoriesSearchValue != "0")
        UnconstrainedBox(
            child: Container(
                height: 30,
                width: 30,
                child: Image.asset("assets/filter2.png", fit: BoxFit.contain))),
        if (_userAuth) _chat(callback, _color),
        if (_userAuth) _notify(callback, _color),
        _shopping(callback, _color),
        if (_userAuth) _avatar(callback, _color),
      ],
    ),
  );
}

headerBackButtonWithBasket(
    var context, Function(String) callback, Color _color) {
  return Container(
      height: 40,
      color: Colors.black.withAlpha(50),
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            _buttonBack((String _) {
              Navigator.pop(context);
            }, _color),
            Expanded(child: Container()),
            _shopping(callback, _color),
          ],
        ),
      ));
}

headerBackButton(var context, Color _color) {
  return Container(
      height: 40,
      color: Colors.black.withAlpha(50),
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            _buttonBack((String _) {
              Navigator.pop(context);
            }, _color)
          ],
        ),
      ));
}

headerBackButtonWithBack(var context, Color _color, Function _onBack) {
  return Container(
    height: 40,
    color: Colors.black.withAlpha(50),
    margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            _buttonBack((String _) {
              _onBack();
            }, _color)
          ],
        )),
  );
}

_shopping(Function(String) callback, Color _color) {
  return Stack(
    children: <Widget>[
      UnconstrainedBox(child: _shopping2(_color)),
      Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: () {
                  callback("basket");
                }, // needed
              ))),
    ],
  );
}

_shopping2(Color _color) {
  return UnconstrainedBox(
      child: Container(
    margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
    height: 25,
    width: 30,
    child: Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: UnconstrainedBox(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  height: 25,
                  width: 30,
                  child: Image.asset(
                    "assets/shop.png",
                    fit: BoxFit.contain,
                    color: _color,
                  ))),
        ),
      ],
    ),
  ));
}

_notify(Function(String) callback, Color _color) {
  return Stack(
    children: <Widget>[
      UnconstrainedBox(child: _notify2(_color)),
      Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: () {
                  callback("notify");
                }, // needed
              ))),
    ],
  );
}

_notify2(Color _color) {
  return UnconstrainedBox(
      child: Container(
    margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
    height: 25,
    width: 30,
    child: Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: UnconstrainedBox(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  height: 25,
                  width: 30,
                  child: Image.asset(
                    "assets/notifyicon.png",
                    fit: BoxFit.contain,
                    color: _color,
                  ))),
        ),
        if (account.notifyCount != 0)
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: theme.colorPrimary,
                shape: BoxShape.circle,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(account.notifyCount.toString(),
                    style: theme.text10white),
              ),
            ),
          )
      ],
    ),
  ));
}

_chat(Function(String) callback, Color _color) {
  return Stack(
    children: <Widget>[
      UnconstrainedBox(child: _chat2(_color)),
      Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: () {
                  callback("chat");
                }, // needed
              ))),
    ],
  );
}

_chat2(Color _color) {
  return UnconstrainedBox(
      child: Container(
    margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
    height: 25,
    width: 30,
    child: Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: UnconstrainedBox(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  height: 25,
                  width: 30,
                  child: Image.asset(
                    "assets/chat.png",
                    fit: BoxFit.contain,
                    color: _color,
                  ))),
        ),
        if (account.chatCount != 0)
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: theme.colorPrimary,
                shape: BoxShape.circle,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(account.chatCount.toString(),
                    style: theme.text10white),
              ),
            ),
          )
      ],
    ),
  ));
}

_buttonMenu(Function(String) callback, Color _color) {
  return Stack(
    children: <Widget>[
      UnconstrainedBox(
          child: Container(
              height: 25,
              width: 25,
              child: Image.asset(
                "assets/menu.png",
                fit: BoxFit.contain,
                color: _color,
              ))),
      Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: () {
                  callback("open_menu");
                }, // needed
              ))),
    ],
  );
}

_buttonBack(Function(String) callback, Color _color) {
  return Stack(
    children: <Widget>[
      UnconstrainedBox(
          child: Container(
              height: 25,
              width: 25,
              child: Image.asset(
                "assets/back.png",
                fit: BoxFit.contain,
                color: _color,
              ))),
      Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: () {
                  callback("");
                }, // needed
              ))),
    ],
  );
}

_avatar(Function(String) callback, Color _color) {
  return Stack(
    children: <Widget>[
      UnconstrainedBox(child: _avatar2()),
      Positioned.fill(
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: () {
                  callback("account");
                }, // needed
              ))),
    ],
  );
}

_avatar2() {
  if (account.userAvatar == null) return Container();
  if (account.userAvatar.isEmpty) return Container();
  return Container(
    margin: EdgeInsets.only(right: 5, left: 5),
    child: Container(
      width: 25,
      height: 25,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          child: CachedNetworkImage(
            placeholder: (context, url) => CircularProgressIndicator(),
            imageUrl: account.userAvatar,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          ),
        ),
      ),
    ),
  );
}

saleSticker(double width, String discount, String discountprice, String price) {
  if (discount.isEmpty) return Container();
  var size = width * 0.3;
  var margin = size * 0.05;
  var radius = 5.0;
  var _boxshadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      spreadRadius: 2,
      blurRadius: 2,
      offset: Offset(3, 3),
    ),
  ];
  return Container(
    margin: EdgeInsets.only(left: 10, top: 10, right: 10),
    // height: size,
    width: size,
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: margin, right: margin),
          height: size * 0.25,
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            boxShadow: _boxshadow,
          ),
          child: Center(
              child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: FittedBox(
                      child: Text(discount, style: theme.text12bold)))),
        ),
        Container(
          height: size * 0.5,
          width: size,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: _boxshadow,
          ),
          child: Center(
              child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: FittedBox(
                      child:
                          Text(discountprice, style: theme.text14boldWhite)))),
        ),
        Container(
          margin: EdgeInsets.only(left: margin, right: margin),
          height: size * 0.25,
          width: size,
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: new BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: _boxshadow,
          ),
          child: Center(
              child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child:
                      FittedBox(child: Text(price, style: theme.text12Ubold)))),
        )
      ],
    ),
  );
}

copyrightBlock(Function(String) callback) {
  var list = List<Widget>();
  list.add(Text(strings.get(69).toUpperCase(),
      style: theme.text16bold)); // INFORMATION
  list.add(SizedBox(
    height: 5,
  ));

  if (appSettings.about == "true" &&
      appSettings.aboutTextName != null &&
      appSettings.aboutTextName.isNotEmpty)
    list.add(copyrightItem(appSettings.aboutTextName, 20, callback));
  if (appSettings.delivery == "true" &&
      appSettings.deliveryTextName != null &&
      appSettings.deliveryTextName.isNotEmpty)
    list.add(copyrightItem(appSettings.deliveryTextName, 21, callback));
  if (appSettings.privacy == "true" &&
      appSettings.privacyTextName != null &&
      appSettings.privacyTextName.isNotEmpty)
    list.add(copyrightItem(appSettings.privacyTextName, 22, callback));
  if (appSettings.terms == "true" &&
      appSettings.termsTextName != null &&
      appSettings.termsTextName.isNotEmpty)
    list.add(copyrightItem(appSettings.termsTextName, 23, callback));
  if (appSettings.refund == "true" &&
      appSettings.refundTextName != null &&
      appSettings.refundTextName.isNotEmpty)
    list.add(copyrightItem(appSettings.refundTextName, 24, callback));

  list.add(SizedBox(
    height: 10,
  ));
  if (appSettings.copyright == "true" &&
      appSettings.copyrightText != null &&
      appSettings.copyrightText.isNotEmpty)
    list.add(Text(
      appSettings.copyrightText,
      style: theme.text14,
      textAlign: TextAlign.center,
    ));

  return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 30),
      child: Column(children: list));
}

copyrightItem(String text, int id, Function(String) callback) {
  return InkWell(
      onTap: () {
        switch (id) {
          case 20: // about
            callback("about");
            break;
          case 21: // delivery
            callback("delivery");
            break;
          case 22: // privacy
            callback("privacy");
            break;
          case 23: // terms
            callback("terms");
            break;
          case 24: // refund
            callback("refund");
            break;
        }
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Text(text,
              style: theme.text14link, textAlign: TextAlign.center)));
}

categoryDetails(List<Widget> list, double windowWidth,
    Function(String id, String heroId) callback, Function _onAddToCartClick) {
  for (var item in categories) {
    if (item.parent != "0" && item.parent != "-1") continue;
    if (theme.vendor && item.vendor != '0') continue;
    var t = categoryDetailsHorizontal(
        item.id, windowWidth, callback, _onAddToCartClick);
    if (t == null) {
      for (var item2 in categories) {
        if (item2.parent == item.id) {
          t = categoryDetailsHorizontal(
              item2.id, windowWidth, callback, _onAddToCartClick);
          if (t != null) break;
        }
      }
      if (t == null) continue;
    }

    list.add(Container(
        margin: EdgeInsets.all(10),
        width: windowWidth,
        height: 40,
        child: Row(
          children: [
            Container(
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => UnconstrainedBox(
                          child: Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(),
                      )),
                      imageUrl: item.image,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                  ),
                )),
            SizedBox(
              width: 10,
            ),
            Text(item.name, style: theme.text14)
          ],
        )));

    list.add(t);
    //
  }
  list.add(SizedBox(
    height: 20,
  ));
}

categoryDetailsHorizontal(String categoryId, double windowWidth,
    Function(String id, String heroId) callback, Function _onAddToCartClick) {
  var list = List<Widget>();
  list.add(SizedBox(
    width: 10,
  ));
  var height = windowWidth * 50 / 100;
  for (var item in foodsAll) {
    if (item.category != categoryId) continue;

    list.add(ICard21FileCaching(
      radius: appSettings.radius,
      shadow: appSettings.shadow,
      colorProgressBar: theme.colorPrimary,
      color: theme.colorBackground,
      getFavoriteState: account.getFavoritesState,
      revertFavoriteState: account.revertFavoriteState,
      text: item.name,
      enableFavorites: false,
      width: windowWidth * 0.6,
      height: height,
      image: "$serverImages${item.image}",
      id: item.id,
      text3: (theme.multiple)
          ? item.restaurantName
          : getCategoryName(item.category),
      discount: item.discount,
      discountprice: "10",
      price: "100",
      textStyle2: theme.text18boldPrimaryUI,
      textStyle: theme.text18boldPrimaryUI,
      textStyle3: theme.text16UI,
      callback: callback,
      onAddToCartClick: _onAddToCartClick,
    ));
    list.add(SizedBox(
      width: 10,
    ));
  }
  if (list.length == 1) return null;
  return Container(
    color: appSettings.restaurantBackgroundColor,
    height: height + 10,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: list,
    ),
  );
}
