import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tomo_app/ui/checkout/checkoutAppBar.dart';
import 'package:tomo_app/ui/server/category.dart';
import 'package:tomo_app/ui/server/productSave.dart';
import 'package:tomo_app/ui/server/products.dart';
import 'package:tomo_app/ui/server/uploadImage.dart';
import 'package:tomo_app/widgets/colorloader2.dart';
import 'package:tomo_app/widgets/easyDialog2.dart';
import 'package:tomo_app/widgets/ibutton3.dart';
import 'package:tomo_app/widgets/widgets.dart';

import '../../main.dart';

class AddProductScreen extends StatefulWidget {
  final Function(String) onDialogOpen;

  const AddProductScreen({key, this.onDialogOpen}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  var windowWidth;
  var windowHeight;

  var _editItem = false;
  var _editItemId = "";
  var _ensureVisibleId = "";
  var scrollController = ScrollController();
  final picker = ImagePicker();

  int _numberOfDigits;

  var editControllerName = TextEditingController();
  var editControllerPrice = TextEditingController();
  var editControllerDesc = TextEditingController();
  var editControllerIngredients = TextEditingController();

  var _categoryValueOnForm = 0;
  var _restaurantValueOnForm = 0;
  var _extrasGroupValueOnForm = 0;
  var _nutritionGroupValueOnForm = 0;


  List<ImageData> _image;
  List<CategoriesData> _cat;
  List<FoodsData> _foods;
  List<RestaurantData> _restaurants;
  List<ExtrasGroupData> _extrasGroup;
  List<NutritionGroupData> _nutritionGroup;
  //List<ExtrasData> _extras;

  var _published = true;
  String _imagePath = "";
  String _serverImagePath = "";
  String _imageId = "";

  bool _wait = false;

  @override
  void initState() {
    _loadCategoryList();
    _loadFoodsList();
    super.initState();
  }
  String _vendor;

  _loadCategoryList(){
    categoryLoad(account.token, (List<ImageData> image, List<CategoriesData> cat, String vendor){
      _image = image;
      _cat = cat;
      _vendor = vendor;
      setState(() {});
    }, _openDialogError);
  }

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: CheckoutAppBar('Cancel', 'Next', this.addNewCard),
        backgroundColor: theme.colorBackground,
        body: Stack(
          children: <Widget>[
            Container(
                child: _body()),

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

            IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
              body: _dialogBody, backgroundColor: theme.colorBackground,),

          ],
        ));

    //return _addFood();
  }

  void addNewCard() async {

  }

  _body(){
    return Container(
        margin: EdgeInsets.only(top: 0, left: 15, right: 15),
        child: ListView(
            padding: EdgeInsets.only(top: 0),
            shrinkWrap: true,
            children: _addFood()));
  }

  @override
  void dispose() {
    editControllerName.dispose();
    editControllerDesc.dispose();
    editControllerPrice.dispose();
    editControllerIngredients.dispose();
    super.dispose();
  }

  _loadFoodsList(){
    productsLoad(account.token,
            (List<ImageData> image, List<FoodsData> foods, List<RestaurantData> restaurants,
            List<ExtrasGroupData> extrasGroup, List<NutritionGroupData> nutritionGroup, int numberOfDigits){
          _image = image;
          _foods = foods;
          _restaurants = restaurants;
          _extrasGroup = extrasGroup;
          _nutritionGroup = nutritionGroup;
          _numberOfDigits = numberOfDigits;
          setState(() {});
        }, _openDialogError);
  }


  _addFood(){
    var list = List<Widget>();
    list.add(SizedBox(height: 20,));
    list.add(Text((_editItem) ? strings.get(202) : strings.get(181), style: theme.text16bold, textAlign: TextAlign.center,));  // "Add New Food",
    list.add(SizedBox(height: 20,));
    list.add(formEdit(strings.get(113), editControllerName, "", 100)); // Name
    list.add(Row(children: [
      Text(strings.get(182), style: theme.text12bold,),  // "Enter Food name"
      SizedBox(width: 4,),
      Text("*", style: theme.text28Red)
    ],));
    list.add(SizedBox(height: 20,));
    list.add(formEditPrice(strings.get(183), editControllerPrice, "", _numberOfDigits)); // Price -
    list.add(Row(children: [
      Text(strings.get(184), style: theme.text12bold,),  //  "Enter Price",
      SizedBox(width: 4,),
      Text("*", style: theme.text28Red)
    ],));
    list.add(SizedBox(height: 20,));
   // list.add(_categoryComboBoxInForm());
    list.add(Row(children: [
      Text(strings.get(185), style: theme.text12bold,),  //  "Select Category"
      SizedBox(width: 4,),
      Text("*", style: theme.text28Red)
    ],));
    list.add(SizedBox(height: 20,));

    if (theme.multiple){
     // list.add(_restaurantsComboBoxInForm());
      list.add(Row(children: [
        Text(strings.get(186), style: theme.text12bold,),  //  "Select Restaurant"
        SizedBox(width: 4,),
        Text("*", style: theme.text28Red)
      ],));
      list.add(SizedBox(height: 20,));
    }else
      _restaurantValueOnForm = 1;

    list.add(formEdit(strings.get(169), editControllerDesc, strings.get(170), 250)); // Description - "Enter description",
    list.add(SizedBox(height: 20,));
    list.add(formEdit(strings.get(187), editControllerIngredients, strings.get(188), 250)); // Ingredients - "Enter Ingredients",
    list.add(SizedBox(height: 20,));
    if (theme.extras){
      //list.add(_extrasComboBoxInForm());
      list.add(Text(strings.get(191), style: theme.text12bold,));           // "Select Extras"
      list.add(SizedBox(height: 20,));
      //list.add(_nutritionComboBoxInForm());
      list.add(Text(strings.get(190), style: theme.text12bold,));           // "Select Nutritions"
      list.add(SizedBox(height: 20,));
    }
    list.add(selectImage(windowWidth, _makeImageDialog));                                        // select image
    list.add(SizedBox(height: 20,));
    list.add(Text(strings.get(173), style: theme.text14, textAlign: TextAlign.start,));  // "Current Image",
    list.add(SizedBox(height: 20,));
    list.add(Container(child: drawImage(_imagePath, _serverImagePath, windowWidth)));
    list.add(SizedBox(height: 20,));
    list.add(checkBox(strings.get(171), _published, (bool value){setState(() {_published = value;});}));                      // "Published item",
    list.add(SizedBox(height: 20,));
    list.add(IButton3(color: theme.colorPrimary,
        text: strings.get(65),              // Save
        textStyle: theme.text14boldWhite,
        pressButton: _addNewFood
    ));

    list.add(SizedBox(height: 150,));
    return list;
  }

  _titlePath(String text){
    return Container(
      child: Text(text, style: theme.text14),
    );
  }

  _categoryComboBoxInForm(){
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(DropdownMenuItem(
      child: Text(strings.get(189), style: theme.text14,), // No
      value: 0,
    ),);
    for (var item in _cat) {
      menuItems.add(DropdownMenuItem(
        child: Text(item.name, style: theme.text14,),
        value: item.id,
      ),);
    }
    return Container(
        width: windowWidth,
        child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
                isExpanded: true,
                value: _categoryValueOnForm,
                items: menuItems,
                onChanged: (value) {
                  _categoryValueOnForm = value;
                  setState(() {
                  });
                })
        )
    );
  }

  _restaurantsComboBoxInForm(){
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(DropdownMenuItem(
      child: Text(strings.get(189), style: theme.text14,), // No
      value: 0,
    ),);
    for (var item in _restaurants) {
      menuItems.add(DropdownMenuItem(
        child: Text(item.name, style: theme.text14,),
        value: item.id,
      ),);
    }
    return Container(
        width: windowWidth,
        child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
                isExpanded: true,
                value: _restaurantValueOnForm,
                items: menuItems,
                onChanged: (value) {
                  _restaurantValueOnForm = value;
                  setState(() {
                  });
                })
        ));
  }

  _openDialogError(String _text) {
    _waits(false);
    if (_text == '5') // You have no permissions
      _text = strings.get(250);
    if (_text == '6') // This is demo application. Your can not modify this section.
      _text = strings.get(248);
    _dialogBody = Column(
      children: [
        Text(_text, style: theme.text14,),
        SizedBox(height: 40,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(66),              // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: (){
              setState(() {
                _show = 0;
              });
            }
        ),
      ],
    );
    setState(() {
      _show = 1;
    });
  }

  _waits(bool value) {
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  _nutritionComboBoxInForm(){
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(DropdownMenuItem(
      child: Text(strings.get(189), style: theme.text14,), // No
      value: 0,
    ),);
    for (var item in _nutritionGroup) {
      menuItems.add(DropdownMenuItem(
        child: Text(item.name, style: theme.text14,),
        value: item.id,
      ),);
    }
    return Container(
        width: windowWidth,
        child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
                isExpanded: true,
                value: _nutritionGroupValueOnForm,
                items: menuItems,
                onChanged: (value) {
                  _nutritionGroupValueOnForm = value;
                  setState(() {
                  });
                })
        ));
  }

  _extrasComboBoxInForm(){
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(DropdownMenuItem(
      child: Text(strings.get(189), style: theme.text14,), // No
      value: 0,
    ),);
    for (var item in _extrasGroup) {
      menuItems.add(DropdownMenuItem(
        child: Text(item.name, style: theme.text14,),
        value: item.id,
      ),);
    }
    return Container(
        width: windowWidth,
        child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
                isExpanded: true,
                value: _extrasGroupValueOnForm,
                items: menuItems,
                onChanged: (value) {
                  _extrasGroupValueOnForm = value;
                  setState(() {
                  });
                })
        ));
  }

  _extrasGroupComboBoxInForm(){
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(DropdownMenuItem(
      child: Text(strings.get(189), style: theme.text14,), // No
      value: 0,
    ),);
    for (var item in _extrasGroup) {
      menuItems.add(DropdownMenuItem(
        child: Text(item.name, style: theme.text14,),
        value: item.id,
      ),);
    }
    return Container(
        width: windowWidth,
        child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
                isExpanded: true,
                value: _extrasGroupValueOnForm,
                items: menuItems,
                onChanged: (value) {
                  _extrasGroupValueOnForm = value;
                  setState(() {
                  });
                })
        ));
  }

  double _show = 0;
  Widget _dialogBody = Container();

  _makeImageDialog(){
    _dialogBody = Container(
        width: windowWidth,
        child: Column(
          children: [
            Text(strings.get(126), textAlign: TextAlign.center, style: theme.text18boldPrimary,), // "Select image from",
            SizedBox(height: 50,),
            Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: windowWidth/2-25,
                        child: IButton3(
                            color: theme.colorPrimary,
                            text: strings.get(127), // "Camera",
                            textStyle: theme.text14boldWhite,
                            pressButton: (){
                              setState(() {
                                _show = 0;
                              });
                              getImage2(ImageSource.camera);
                            }
                        )),
                    SizedBox(width: 10,),
                    Container(
                        width: windowWidth/2-25,
                        child: IButton3(
                            color: theme.colorPrimary,
                            text: strings.get(128), // Gallery
                            textStyle: theme.text14boldWhite,
                            pressButton: (){
                              setState(() {
                                _show = 0;
                              });
                              getImage2(ImageSource.gallery);
                            }
                        )),
                  ],
                )),
          ],
        )
    );
    setState(() {
      _show = 1;
    });
  }

  Future getImage2(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null && pickedFile.path != null) {
      print("Photo file: ${pickedFile.path}");
      _imagePath = pickedFile.path;
      setState(() {
      });
    }
  }

  selectImage(double windowWidth, Function callback){
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          height: 100,
          width: windowWidth,
          decoration: BoxDecoration(
            color: theme.colorGrey,
            borderRadius: new BorderRadius.circular(10),
          ),
          child: Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 10),
            child: Opacity(
                opacity: 0.6,
                child: Text(strings.get(125), style: theme.text12bold, ) // Click here for select Image
            ),
          ),                // "Enter description",
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 10),
          child: UnconstrainedBox(
              child: Container(
                  height: 60,
                  width: 40,
                  child: Image.asset("assets/selectimage.png",
                      fit: BoxFit.contain
                  )
              )),
        ),

        Positioned.fill(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.grey[400],
                  onTap: (){
                    callback();
                  }, // needed
                )),
          ),
        )

      ],
    );
  }


  Widget drawImage(String image, String serverImage, double windowWidth){
    if (image.isNotEmpty)
      return Container(
          height: windowWidth*0.3,
          child: Image.file(File(image), fit: BoxFit.contain,
          ));
    else {
      if (serverImage.isNotEmpty)
        return Container(
          width: windowWidth,
          height: 100,
          child: Container(
            width: windowWidth,
            child: CachedNetworkImage(
              placeholder: (context, url) =>
                  UnconstrainedBox(child:
                  Container(
                    alignment: Alignment.center,
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      backgroundColor: theme.colorPrimary,
                    ),
                  )),
              imageUrl: serverImage,
              imageBuilder: (context, imageProvider) =>
                  Container(
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

  _addNewFood(){
    if (editControllerName.text.isEmpty)
      return _openDialogError(strings.get(172));  // "The Name field is request",
    if (editControllerPrice.text.isEmpty)
      return _openDialogError(strings.get(194));  // "The Price field is request",
    if (_restaurantValueOnForm == 0)
      return _openDialogError(strings.get(192));  // "The Restaurant field is request",
    if (_categoryValueOnForm == 0)
      return _openDialogError(strings.get(193));  // "The Category field is request",
    _waits(true);

    if (_imagePath.isNotEmpty) {
      /*uploadImage(_imagePath, account.token, (String path, String id) {
        _foodSave(id);
      }, _openDialogError);*/

      uploadImage(_imagePath, account.token, (String avatar,int id) async {
        // account.setUserAvatar(avatar);
        print(":::Date::: --> " + avatar);
        _waits(false);
        setState(() {
        });
      }, (String error) {
        _waits(false);
        _openDialogError(
            "${strings.get(128)} $error"); // "Something went wrong. ",
      });

    }else
      _foodSave(_imageId);
  }

  var _state = "root";

  _foodSave(String imageid){
    foodSave(editControllerName.text, editControllerDesc.text, imageid, (_published) ? "1" : "0",
        editControllerPrice.text, _restaurantValueOnForm.toString(), _categoryValueOnForm.toString(),
        editControllerIngredients.text, _extrasGroupValueOnForm.toString(), _nutritionGroupValueOnForm.toString(),
        (_editItem) ? "1" : "0", _editItemId,
        account.token, (List<ImageData> image, List<FoodsData> foods, List<RestaurantData> restaurants,
            List<ExtrasGroupData> extrasGroup, List<NutritionGroupData> nutritionGroup, String id) {
          _image = image;
          _foods = foods;
          _restaurants = restaurants;
          _extrasGroup = extrasGroup;
          _nutritionGroup = nutritionGroup;
          _state = "viewFoodsList";
          _ensureVisibleId = id;
          _waits(false);
          setState(() {});
        }, _openDialogError);
  }
}
