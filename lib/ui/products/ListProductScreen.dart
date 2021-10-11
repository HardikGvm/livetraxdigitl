import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofilters/filters/preset_filters.dart';
import 'package:photofilters/widgets/photo_filter.dart';
import 'package:livetraxdigitl/ui/Fliter/filtermain.dart';
import 'package:livetraxdigitl/ui/checkout/checkoutAppBar.dart';
import 'package:livetraxdigitl/ui/server/category.dart';
import 'package:livetraxdigitl/ui/server/productSave.dart';
import 'package:livetraxdigitl/ui/server/products.dart';
import 'package:livetraxdigitl/ui/server/uploadImage.dart';
import 'package:livetraxdigitl/widgets/colorloader2.dart';
import 'package:livetraxdigitl/widgets/easyDialog2.dart';
import 'package:livetraxdigitl/widgets/ibutton3.dart';
import 'package:livetraxdigitl/widgets/widgets.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path/path.dart' as path;

import '../../main.dart';

class ListProductScreen extends StatefulWidget {
  final Function(String) onDialogOpen;

  const ListProductScreen({key, this.onDialogOpen}) : super(key: key);

  @override
  _ListProductScreenState createState() => _ListProductScreenState();
}

class _ListProductScreenState extends State<ListProductScreen> {
  var windowWidth;
  var windowHeight;

  bool _wait = false;

  List<ImageData> _image;
  List<CategoriesData> _cat;
  List<FoodsData> _foods;
  List<RestaurantData> _restaurants;
  List<ExtrasGroupData> _extrasGroup;
  List<NutritionGroupData> _nutritionGroup;

  int _numberOfDigits;

  @override
  void initState() {
    _loadFoodsList();
    print("Check List here LOADING >> ");
    super.initState();
  }

  _loadFoodsList() {
    productsLoad(account.token, (List<ImageData> image,
        List<FoodsData> foods,
        List<RestaurantData> restaurants,
        List<ExtrasGroupData> extrasGroup,
        List<NutritionGroupData> nutritionGroup,
        int numberOfDigits) {
        _image = image;
        _foods = foods;
        print("Check List here Well >> " + foods.length.toString());
        _restaurants = restaurants;
        _extrasGroup = extrasGroup;
        _nutritionGroup = nutritionGroup;
        _numberOfDigits = numberOfDigits;
        setState(() {});
    }, _openDialogError);
  }

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: CheckoutAppBar(
            'Cancel', 'Next', this.addNewCard, strings.get(2276)),
        backgroundColor: theme.colorBackground,
        body: Stack(
          children: <Widget>[
            Container(child: _body()),
            if (_wait)
              Container(
                color: Color(0x80000000),
                width: windowWidth,
                height: windowHeight,
                child: Container(
                  alignment: Alignment.center,
                  child: ColorLoader2(
                    color1: theme.colorPrimary,
                    color2: theme.colorCompanion,
                    color3: theme.colorPrimary,
                  ),
                ),
              ),
            IEasyDialog2(
              setPosition: (double value) {
                _show = value;
              },
              getPosition: () {
                return _show;
              },
              color: theme.colorGrey,
              body: _dialogBody,
              backgroundColor: theme.colorBackground,
            ),
          ],
        ));

    //return _addFood();
  }

  _body() {
    return Container(
        margin: EdgeInsets.only(top: 0, left: 15, right: 15),
        child: ListView(
            padding: EdgeInsets.only(top: 0),
            shrinkWrap: true,
            children: _addProduct()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  final editFullName = TextEditingController();
  final editDescriptionName = TextEditingController();

  _addProduct() {
    var list = List<Widget>();

    print("Check List here Well SIZE> " + _foods.length.toString());
    for (var item in _foods){
    print("Check List here Well > " + item.id + " > " + item.name);
     // if (item.name.toUpperCase().contains(_searchValue)){
        /*if (_ensureVisibleId == item.id.toString()) {
          if (count > 0)
            _needShow = 60.0+(290)*count-290;//-290;
          else
            _needShow = 60.0+(290)*count;
          dprint("${item.id} $count");
        }*/
       // count++;
        /*list.add(Container(
          height: 120+90.0,
          child: oneItem("${strings.get(163)}${item.id}", item.name, "${strings.get(164)}${item.updatedAt}", _getImage(item.imageid),
              windowWidth, item.visible),)
        );*/ // "Last update: ",
        list.add(SizedBox(height: 10,));
       /* list.add(Container(
            height: 50,
            child: buttonsEditOrDelete(item.id.toString(), _editFood, _deleteDialog, windowWidth)));*/
        list.add(SizedBox(height: 20,));
     // }
    }

    return list;
  }

  _openDialogError(String _text) {
    _waits(false);
    if (_text == '5') // You have no permissions
      _text = strings.get(250);
    if (_text ==
        '6') // This is demo application. Your can not modify this section.
      _text = strings.get(248);
    _dialogBody = Column(
      children: [
        Text(
          _text,
          style: theme.text14,
        ),
        SizedBox(
          height: 40,
        ),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(66), // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: () {
              setState(() {
                _show = 0;
              });
            }),
      ],
    );
    setState(() {
      _show = 1;
    });
  }

  _waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
  }

  double _show = 0;
  Widget _dialogBody = Container();

  Widget drawImage(String image, String serverImage, double windowWidth) {
    if (image.isNotEmpty)
      return Container(
          height: windowWidth * 0.3,
          child: Image.file(
            File(image),
            fit: BoxFit.contain,
          ));
    else {
      if (serverImage.isNotEmpty)
        return Container(
          width: windowWidth,
          height: 100,
          child: Container(
            width: windowWidth,
            child: CachedNetworkImage(
              placeholder: (context, url) => UnconstrainedBox(
                  child: Container(
                    alignment: Alignment.center,
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      backgroundColor: theme.colorPrimary,
                    ),
                  )),
              imageUrl: serverImage,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ),
        );
    }
    return Container();
  }

  void addNewCard() async {

  }


  _editFood(String id){
    /*for (var item in _foods)
      if (item.id.toString() == id) {
        editControllerName.text = item.name;
        editControllerDesc.text = item.desc;
        editControllerPrice.text = item.price;
        for (var ex in _restaurants)
          if (ex.id == item.restaurant)
            _restaurantValueOnForm = item.restaurant;
        for (var ex in _cat)
          if (ex.id == item.category)
            _categoryValueOnForm = item.category;
        if (_extrasGroup != null)
          for (var ex in _extrasGroup)
            if (ex.id == item.extras)
              _extrasGroupValueOnForm = item.extras;
        if (_nutritionGroup != null)
          for (var ex in _nutritionGroup)
            if (ex.id == item.nutrition)
              _nutritionGroupValueOnForm = item.nutrition;

        editControllerIngredients.text = item.ingredients;
        if (item.visible == '1') _published = true; else _published = false;
        _imagePath = "";
        _serverImagePath = "";
        for (var image in _image)
          if (image.id == item.imageid) {
            _serverImagePath = "$serverImages${image.filename}";
            _imageId = image.id.toString();
          }
        _state = "editFood";
        _editItem = true;
        _editItemId = id;
        setState(() {});
      }*/
  }

}
