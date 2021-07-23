import 'package:flutter/material.dart';
import 'package:tomo_app/ui/config/api.dart';
import 'package:tomo_app/ui/model/categories.dart';
import 'package:tomo_app/ui/server/listvirtualgift.dart';
import 'package:tomo_app/ui/server/listvirtualgift_model.dart';
import 'package:tomo_app/ui/server/mainwindowdata.dart';
import 'package:tomo_app/widgets/ICard21FileCaching.dart';
import 'package:tomo_app/widgets/ICard81FileCaching.dart';

import '../../main.dart';
import 'homescreenModel.dart';

class ProductDetails extends StatefulWidget {
  DishesData item;

  @override
  _ProductDetailState createState() => _ProductDetailState();

  ProductDetails(DishesData addToBasketItem) {
    this.item = addToBasketItem;
  }
}

class _ProductDetailState extends State<ProductDetails> {
  int _languageIndex = -1;
  data sample;
  bool _wait = false;
  var windowWidth;
  var windowHeight;

  List<data> _responseList = [];

  //List<int> selectedIndexList = new List<int>();

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    return Sample();
  }

  @override
  void initState() {
    // LoadVirtualgift();

    super.initState();
  }

  @override
  void dispose() {
    route.disposeLast();
    super.dispose();
  }

  LoadVirtualgift() {
    _waits(true);
    listVirtualGift(_success, _error);
  }

  _success(List<data> _response) {
    _waits(false);
    _responseList = _response;
    print("CALL _success Done ---> " + _response.length.toString());
    /*openDialog(strings.get(
        135)); // "A letter with a new password has been sent to the specified E-mail",*/
  }

  _error(String error) {
    _waits(false);
    print("CALL ERROR _success >>> " + error.toString());
    if (error == "5000") {}
    if (error == "5001") {}
  }

  _waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
  }

  Widget Sample() {
    var height = windowWidth*appSettings.dishesCardHeight/100;

    return ICard81FileCaching(
      radius: appSettings.radius,
      shadow: appSettings.shadow,
      colorProgressBar: theme.colorPrimary,
      getFavoriteState: account.getFavoritesState,
      revertFavoriteState: account.revertFavoriteState,
      color: theme.colorBackground,
      text: widget.item.name,
      text3: (theme.multiple)
          ? widget.item.restaurantName
          : getCategoryName(widget.item.category),
      enableFavorites: false,
      width: windowWidth * 0.5 - 10,
      height: height,
      image: "$serverImages${widget.item.image}",
      id: widget.item.id,
      price: widget.item.price.toString(),
      discountprice: (widget.item.discountprice != 0) ? "203" : "",
      discount: widget.item.discount,
      textStyle2: theme.text18boldPrimaryUI,
      textStyle: theme.text18boldPrimaryUI,
      textStyle3: theme.text16UI,
      callback: null,
      onAddToCartClick: null,
    );
  }
}
