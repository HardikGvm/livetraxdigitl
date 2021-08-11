import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofilters/filters/preset_filters.dart';
import 'package:photofilters/widgets/photo_filter.dart';
import 'package:tomo_app/ui/Fliter/filtermain.dart';
import 'package:tomo_app/ui/checkout/checkoutAppBar.dart';
import 'package:tomo_app/ui/config/api.dart';
import 'package:tomo_app/ui/products/productAppBar.dart';
import 'package:tomo_app/ui/server/category.dart';
import 'package:tomo_app/ui/server/foodDelete.dart';
import 'package:tomo_app/ui/server/productSave.dart';
import 'package:tomo_app/ui/server/products.dart';
import 'package:tomo_app/ui/server/uploadImage.dart';
import 'package:tomo_app/widgets/colorloader2.dart';
import 'package:tomo_app/widgets/easyDialog2.dart';
import 'package:tomo_app/widgets/ibutton3.dart';
import 'package:tomo_app/widgets/widgets.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path/path.dart' as path;

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
  var editControllerquantity = TextEditingController();
  var editControllerSize = TextEditingController();
  var editControllerBrand = TextEditingController();
  var editControllerColor = TextEditingController();
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
  bool isListMode = true;

  @override
  void initState() {
    _loadCategoryList();
    _loadFoodsList();
    super.initState();
  }

  String _vendor;

  _loadCategoryList() {
    categoryLoad(account.token,
        (List<ImageData> image, List<CategoriesData> cat, String vendor) {
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

    return WillPopScope(
      child: Scaffold(
        appBar: productAppBar(
            'Cancel',
            'Next',
            this.addNewCard,
            isListMode ? strings.get(2276) : strings.get(2272),
            _willPopCallback),
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
        ),
        floatingActionButton: new Visibility(
            visible: isListMode,
            child: FloatingActionButton(
              onPressed: () {
                isListMode = false;
                setState(() {});
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.blueGrey,
            )),
      ),
      onWillPop: _willPopCallback,
    );

    //return _addFood();
  }

  Future<bool> _willPopCallback() async {
    setState(() {
      print("Check Value here >>" +
          (_show != 1).toString() +
          " >> " +
          _show.toString());
      if (_show != 0) {
        _show = 0;
      } else if (!isListMode) {
        isListMode = true;
      } else {
        Navigator.pop(context);
      }
    });
    return false; // return true if the route to be popped
  }

  void addNewCard() async {
    if (_imagePath != "") {
      /*final imagePath = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FilterMain(_imagePath),
        ),
      );*/
      openCamera(_imagePath);
    } else {
      _openDialogError("Please select image.");
    }
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
    editControllerName.dispose();
    editControllerBrand.dispose();
    editControllerColor.dispose();
    editControllerDesc.dispose();
    editControllerPrice.dispose();
    editControllerquantity.dispose();
    editControllerSize.dispose();
    editControllerIngredients.dispose();
    super.dispose();
  }

  _loadFoodsList() {
    _wait = true;
    productsLoad(account.token, (List<ImageData> image,
        List<FoodsData> foods,
        List<RestaurantData> restaurants,
        List<ExtrasGroupData> extrasGroup,
        List<NutritionGroupData> nutritionGroup,
        int numberOfDigits) {
      _image = image;
      _foods = foods;
      _restaurants = restaurants;
      _extrasGroup = extrasGroup;
      _nutritionGroup = nutritionGroup;
      _numberOfDigits = numberOfDigits;
      _wait = false;
      setState(() {});
    }, _openDialogError);
  }

  _addProduct() {
    var list = List<Widget>();

    list.add(SizedBox(
      height: 20,
    ));
    var count = 0;
    if (isListMode) {
      if (_foods != null) {
        print("check size here > " + _foods.length.toString());
        for (var item in _foods) {
          //if (item.name.toUpperCase().contains(_searchValue)){
          /*if (_ensureVisibleId == item.id.toString()) {
          if (count > 0)
            _needShow = 60.0+(290)*count-290;//-290;
          else
            _needShow = 60.0+(290)*count;
          dprint("${item.id} $count");
        }*/
          count++;
          list.add(Container(
            height: 120 + 90.0,
            child: oneItem(
                "${strings.get(2281)}${item.id}",
                item.name,
                "${strings.get(2282)}${item.updatedAt}",
                _getImage(item.imageid),
                windowWidth,
                item.visible),
          )); // "Last update: ",
          list.add(SizedBox(
            height: 10,
          ));
          list.add(Container(
              height: 50,
              child: buttonsEditOrDelete(
                  item.id.toString(), _editFood, _deleteDialog, windowWidth)));
          list.add(SizedBox(
            height: 20,
          ));
          // }
        }
      }
    } else {
      list.add(Container(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text(
            "DETAILS",
            style: theme.text16bold,
            textAlign: TextAlign.start,
          ),
        ),
        decoration:
            new BoxDecoration(color: Color.fromARGB(255, 248, 246, 243)),
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(10.0),
      ));
      list.add(
        SizedBox(
          child: Theme(
            child: TextFormField(
              controller: editControllerName,
              style: TextStyle(fontSize: 14.0),
              decoration: customBorder(strings.get(2259), Icons.person),
              keyboardType: TextInputType.text,
            ),
            data: Theme.of(context).copyWith(primaryColor: Colors.black),
          ),
        ),
      ); // Name
      list.add(SizedBox(
        height: 5,
      ));
      list.add(
        SizedBox(
          child: Theme(
            child: TextFormField(
              controller: editControllerDesc,
              style: TextStyle(fontSize: 14.0),
              decoration: customBorder(strings.get(2260), Icons.person),
              keyboardType: TextInputType.text,
            ),
            data: Theme.of(context).copyWith(primaryColor: Colors.black),
          ),
        ),
      );

      list.add(SizedBox(
        height: 5,
      ));

      list.add(Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 0),
                  child: Table(
                    columnWidths: {
                      0: FixedColumnWidth(90),
                      1: FlexColumnWidth()
                    },
                    border: TableBorder.symmetric(
                        inside: BorderSide(width: 0.5, color: Colors.blueGrey)),
                    children: [
                      TableRow(children: [
                        GetTitle(strings.get(2261)),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            height: 40,
                            child: _categoryComboBoxInForm(),
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        GetTitle(strings.get(2263)),
                        GetDigitEdit(editControllerquantity, strings.get(2267)),
                      ]),
                      TableRow(children: [
                        GetTitle(strings.get(2264)),
                        GetDigitEdit(editControllerSize, strings.get(2262)),
                      ]),
                      TableRow(children: [
                        GetTitle(strings.get(2265)),
                        GetTextEdit(editControllerBrand, strings.get(170)),
                      ]),
                      TableRow(children: [
                        GetTitle(strings.get(2266)),
                        GetTextEdit(editControllerColor, strings.get(170)),
                      ]),
                      TableRow(children: [
                        GetTitle(strings.get(2269)),
                        GetDigitEdit(editControllerPrice, strings.get(2262)),
                      ]),
                    ],
                  ),
                ),
              ])));

      list.add(SizedBox(
        height: 20,
      ));
      list.add(Text(
        strings.get(2270),
        style: theme.text12bold,
      )); // "Select Nutritions"
      list.add(SizedBox(
        height: 20,
      ));
      list.add(selectImage(windowWidth, _makeImageDialog)); // select image
      list.add(SizedBox(
        height: 20,
      ));
      /* list.add(Text(
      strings.get(173),
      style: theme.text14,
      textAlign: TextAlign.start,
    )); */ // "Current Image",
      list.add(SizedBox(
        height: 20,
      ));
      list.add(Container(
          child: drawImage(_imagePath, _serverImagePath, windowWidth)));
      list.add(SizedBox(
        height: 20,
      ));
      /*list.add(checkBox(strings.get(171), _published, (bool value) {
      setState(() {
        _published = value;
      });
    })); */ // "Published item",
      list.add(SizedBox(
        height: 20,
      ));
      list.add(IButton3(
          color: theme.colorPrimary,
          text: strings.get(65), // Save
          textStyle: theme.text14boldWhite,
          pressButton: _addNewFood));

      list.add(SizedBox(
        height: 150,
      ));
    }

    return list;
  }

  _titlePath(String text) {
    return Container(
      child: Text(text, style: theme.text14),
    );
  }

  _categoryComboBoxInForm() {
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(
      DropdownMenuItem(
        child: Text(
          strings.get(189),
          style: theme.text12grey,
        ), // No
        value: 0,
      ),
    );
    if (_cat != null) {
      for (var item in _cat) {
        menuItems.add(
          DropdownMenuItem(
            child: Text(
              item.name,
              style: theme.text12bold,
            ),
            value: item.id,
          ),
        );
      }
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
                  setState(() {});
                })));
  }

  _restaurantsComboBoxInForm() {
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(
      DropdownMenuItem(
        child: Text(
          strings.get(189),
          style: theme.text14,
        ), // No
        value: 0,
      ),
    );
    for (var item in _restaurants) {
      menuItems.add(
        DropdownMenuItem(
          child: Text(
            item.name,
            style: theme.text14,
          ),
          value: item.id,
        ),
      );
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
                  setState(() {});
                })));
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

  _nutritionComboBoxInForm() {
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(
      DropdownMenuItem(
        child: Text(
          strings.get(189),
          style: theme.text14,
        ), // No
        value: 0,
      ),
    );
    for (var item in _nutritionGroup) {
      menuItems.add(
        DropdownMenuItem(
          child: Text(
            item.name,
            style: theme.text14,
          ),
          value: item.id,
        ),
      );
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
                  setState(() {});
                })));
  }

  _extrasComboBoxInForm() {
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(
      DropdownMenuItem(
        child: Text(
          strings.get(189),
          style: theme.text14,
        ), // No
        value: 0,
      ),
    );
    for (var item in _extrasGroup) {
      menuItems.add(
        DropdownMenuItem(
          child: Text(
            item.name,
            style: theme.text14,
          ),
          value: item.id,
        ),
      );
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
                  setState(() {});
                })));
  }

  _extrasGroupComboBoxInForm() {
    var menuItems = List<DropdownMenuItem>();
    menuItems.add(
      DropdownMenuItem(
        child: Text(
          strings.get(189),
          style: theme.text14,
        ), // No
        value: 0,
      ),
    );
    for (var item in _extrasGroup) {
      menuItems.add(
        DropdownMenuItem(
          child: Text(
            item.name,
            style: theme.text14,
          ),
          value: item.id,
        ),
      );
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
                  setState(() {});
                })));
  }

  double _show = 0;
  Widget _dialogBody = Container();

  _makeImageDialog() {
    _dialogBody = Container(
        width: windowWidth,
        child: Column(
          children: [
            Text(
              strings.get(126),
              textAlign: TextAlign.center,
              style: theme.text18boldPrimary,
            ), // "Select image from",
            SizedBox(
              height: 50,
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: windowWidth / 2 - 25,
                    child: IButton3(
                        color: theme.colorPrimary,
                        text: strings.get(127), // "Camera",
                        textStyle: theme.text14boldWhite,
                        pressButton: () {
                          setState(() {
                            _show = 0;
                          });
                          getImage2(ImageSource.camera);
                        })),
                SizedBox(
                  width: 10,
                ),
                Container(
                    width: windowWidth / 2 - 25,
                    child: IButton3(
                        color: theme.colorPrimary,
                        text: strings.get(2271), // Gallery
                        textStyle: theme.text14boldWhite,
                        pressButton: () {
                          setState(() {
                            _show = 0;
                          });
                          getImage2(ImageSource.gallery);
                        })),
              ],
            )),
          ],
        ));
    setState(() {
      _show = 1;
    });
  }

  Future getImage2(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null && pickedFile.path != null) {
      print("Photo file: ${pickedFile.path}");
      _imagePath = pickedFile.path;
      setState(() {});
    }
  }

  selectImage(double windowWidth, Function callback) {
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
                child: Text(
                  strings.get(125),
                  style: theme.text12bold,
                ) // Click here for select Image
                ),
          ), // "Enter description",
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 10),
          child: UnconstrainedBox(
              child: Container(
                  height: 60,
                  width: 40,
                  child: Image.asset("assets/selectimage.png",
                      fit: BoxFit.contain))),
        ),
        Positioned.fill(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.grey[400],
                  onTap: () {
                    callback();
                  }, // needed
                )),
          ),
        )
      ],
    );
  }

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

  _addNewFood() {
    if (editControllerName.text.isEmpty)
      return _openDialogError(
          strings.get(2273)); // "The Name field is request",
    if (editControllerDesc.text.isEmpty)
      return _openDialogError(
          strings.get(2274)); // "The Name field is request",
    if (editControllerSize.text.isEmpty)
      return _openDialogError(
          strings.get(2275)); // "The Price field is request",
    if (editControllerPrice.text.isEmpty)
      return _openDialogError(
          strings.get(194)); // "The Price field is request",

    if (_categoryValueOnForm == 0)
      return _openDialogError(
          strings.get(193)); // "The Category field is request",
    _waits(true);

    if (_imagePath.isNotEmpty) {
      /* uploadImage(_imagePath, account.token, (String path, String id) {
        _foodSave(id);
      }, _openDialogError);*/

      uploadImage(_imagePath, account.token, (String avatar, int id) async {
        // account.setUserAvatar(avatar);
        print(":::Date::: --> " + avatar);
        _waits(false);
        _foodSave(id.toString());
        setState(() {});
      }, (String error) {
        _waits(false);
        _openDialogError(
            "${strings.get(128)} $error"); // "Something went wrong. ",
      });
    } else
      _foodSave(_imageId);
  }

  var _state = "root";

  _foodSave(String imageid) {
    foodSave(
        editControllerName.text,
        editControllerDesc.text,
        imageid,
        (_published) ? "1" : "0",
        editControllerPrice.text,
        _restaurantValueOnForm.toString(),
        _categoryValueOnForm.toString(),
        editControllerIngredients.text,
        _extrasGroupValueOnForm.toString(),
        _nutritionGroupValueOnForm.toString(),
        (_editItem) ? "1" : "0",
        _editItemId,
        account.token, (List<ImageData> image,
            List<FoodsData> foods,
            List<RestaurantData> restaurants,
            List<ExtrasGroupData> extrasGroup,
            List<NutritionGroupData> nutritionGroup,
            String id) {
      _image = image;
      _foods = foods;
      _restaurants = restaurants;
      _extrasGroup = extrasGroup;
      _nutritionGroup = nutritionGroup;
      _state = "viewFoodsList";
      isListMode=true;
      _ensureVisibleId = id;
      _waits(false);
      setState(() {});
    }, _openDialogError);
  }

  InputDecoration customBorder(String hintText, IconData textIcon) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      errorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      focusedErrorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      hintText: hintText,
    );
  }

  GetDigitEdit(TextEditingController controller, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
      child: formEditPrice(text, controller, "", _numberOfDigits),
    );
  }

  GetTextEdit(TextEditingController controller, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
      child: formEditSample(strings.get(2267), controller, text, 250),
    );
  }

  GetTitle(String text) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: theme.text12greybold,
      ),
    );
  }

  String fileName;

  openCamera(String image_Path) async {
    var imageFile = File(image_Path);
    fileName = path.basename(imageFile.path);
    var image = imageLib.decodeImage(imageFile.readAsBytesSync());
    image = imageLib.copyResize(image, width: 600);
    Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
          title: Text(
            "Edit",
            style: TextStyle(color: Colors.white),
          ),
          image: image,
          filters: presetFiltersList,
          filename: fileName,
          loader: Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
          appBarColor: Colors.blueGrey,
        ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        imageFile = imagefile['image_filtered'];
        _imagePath = imageFile.path;
      });
    }
  }

  _editFood(String id) {
    for (var item in _foods)
      if (item.id.toString() == id) {
        editControllerName.text = item.name;
        editControllerDesc.text = item.desc;
        editControllerPrice.text = item.price;
        for (var ex in _restaurants)
          if (ex.id == item.restaurant)
            _restaurantValueOnForm = item.restaurant;
        for (var ex in _cat)
          if (ex.id == item.category) _categoryValueOnForm = item.category;
        if (_extrasGroup != null)
          for (var ex in _extrasGroup)
            if (ex.id == item.extras) _extrasGroupValueOnForm = item.extras;
        if (_nutritionGroup != null)
          for (var ex in _nutritionGroup)
            if (ex.id == item.nutrition)
              _nutritionGroupValueOnForm = item.nutrition;

        editControllerIngredients.text = item.ingredients;
        if (item.visible == '1')
          _published = true;
        else
          _published = false;
        _imagePath = "";
        _serverImagePath = "";
        for (var image in _image)
          if (image.id == item.imageid) {
            _serverImagePath = "$serverImages${image.filename}";
            _imageId = image.id.toString();
          }
        _state = "editFood";
        print("*** Click Edit ***");
        _editItem = true;
        _editItemId = id;
        isListMode=false;
        setState(() {});
      }
  }

  _deleteDialog(String id) {
    _state = "viewFoodsList";
    _dialogBody = Container(
        width: windowWidth,
        child: Column(
          children: [
            Text(
              strings.get(111),
              textAlign: TextAlign.center,
              style: theme.text18boldPrimary,
            ),
            // "Are you sure?",
            SizedBox(
              height: 20,
            ),
            Text(
              strings.get(112),
              textAlign: TextAlign.center,
              style: theme.text16,
            ),
            // "You will not be able to recover this item!"
            SizedBox(
              height: 50,
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: windowWidth / 2 - 25,
                    child: IButton3(
                        color: Colors.red,
                        text: strings.get(109), // Yes, delete it!
                        textStyle: theme.text14boldWhite,
                        pressButton: () {
                          setState(() {
                            _show = 0;
                          });
                          _ensureVisibleId = "";
                          print("Check status >> " + _state);
                          _deleteFood(id);

                        })),
                SizedBox(
                  width: 10,
                ),
                Container(
                    width: windowWidth / 2 - 25,
                    child: IButton3(
                        color: theme.colorPrimary,
                        text: strings.get(110), // No, cancel plx!
                        textStyle: theme.text14boldWhite,
                        pressButton: () {
                          setState(() {
                            _show = 0;
                          });
                        })),
              ],
            )),
          ],
        ));
    setState(() {
      _show = 1;
    });
  }

  _getImage(int imageid) {
    if (_image != null)
      for (var item in _image)
        if (item.id == imageid) return "$serverImages${item.filename}";
    return serverImgNoImage;
  }

  _deleteFood(String id){
    _wait=true;
    foodDelete(id,
            (List<ImageData> image, List<FoodsData> foods, List<RestaurantData> restaurants,
            List<ExtrasGroupData> extrasGroup, List<NutritionGroupData> nutritionGroup) {
          _image = image;
          _foods = foods;
          _restaurants = restaurants;
          _extrasGroup = extrasGroup;
          _nutritionGroup = nutritionGroup;
          _waits(false);
        }, _openDialogError);
  }
}
