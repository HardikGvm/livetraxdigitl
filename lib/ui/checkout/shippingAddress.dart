import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:livetraxdigitl/ui/checkout/shippingAddressInput.dart';
import 'package:livetraxdigitl/ui/config/UserService.dart';
import 'package:livetraxdigitl/ui/server/addressDelete.dart';
import 'package:livetraxdigitl/ui/server/addressGet.dart';
import 'package:livetraxdigitl/ui/server/addressSave.dart';
import 'package:livetraxdigitl/widgets/internetConnection.dart';

import '../../main.dart';
import 'checkoutAppBar.dart';

class ShippingAddress extends StatefulWidget {
  @override
  _ShippingAddressState createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  final _formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  bool visibleInput = false;
  int selectedAddress;
  bool _wait = false;

  //CheckoutService _checkoutService = new CheckoutService();
  //UserService _userService = new UserService();
  HashMap addressValues = new HashMap();
  List<AddressData> shippingAddress = new List();
  UserService _userService = new UserService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  checkoutAddress() {
    if (selectedAddress == null) {
      String msg = 'Select any address';
      showInSnackBar(msg, Colors.red);
    } else {
      //Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
      AddressData _selected_address=new AddressData();
      print("Check data here > " + shippingAddress.length.toString() + " select " + selectedAddress.toString());
      //args['shippingAddress'] = shippingAddress[selectedAddress];
      _selected_address = shippingAddress[selectedAddress];
      Navigator.of(context)
          .pushNamed('/checkout/payment', arguments: _selected_address);

    }
  }

  void showInSnackBar(String msg, Color color) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: new Text(msg),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {
            _scaffoldKey.currentState.removeCurrentSnackBar();
          },
        ),
      ),
    );
  }

  validateInput() async {
    bool connectionStatus = await _userService.checkInternetConnectivity();

    if (connectionStatus) {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        //await _checkoutService.newShippingAddress(addressValues);
        /*String complete_address = addressValues["name"] +
            ",`," +
            addressValues["address"] +
            ",`," +
            addressValues["address"] +
            ",`," +
            addressValues["landMark"] +
            ",`," +
            addressValues["area"] +
            ",`," +
            addressValues["city"] +
            ",`," +
            addressValues["pinCode"] +
            ",`," +
            addressValues["state"] +
            ",`," +
            addressValues["mobileNumber"];*/

        var body = json.encoder.convert({
          'mobileNumber': addressValues["mobileNumber"],
          'area': addressValues["area"],
          'name': addressValues["name"],
          'state': addressValues["state"],
          'pinCode': addressValues["pinCode"],
          'landMark': addressValues["landMark"],
          'city': addressValues["city"],
          'state': addressValues["state"],
        });

        print("data insert > " +
            addressValues["mobileNumber"] +
            " BODY " +
            body.toString());

        saveAddress(body, "0", "0", "home", "true", account.token, _successSave,
            _errorAddress);
      } else {
        setState(() {
          autoValidate = true;
        });
      }
    } else {
      //internetConnectionDialog(context);
    }
  }

  listShippingAddress() async {
    bool connectionStatus = await _userService.checkInternetConnectivity();

    if (connectionStatus) {
      _waits(true);
      print("getAddress T? " + account.token);
      getAddress(account.token, _success, _error);
      //listVirtualGift(_success, _error);
      /*List data = await _checkoutService.listShippingAddress();
      setState(() {
        shippingAddress = data;
      });*/
    } else {
      internetConnectionDialog(context);
    }
  }

  _error(String error) {
    _waits(false);
    print("CALL ERROR _success >>> " + error.toString());
    if (error == "5000") {}
    if (error == "5001") {}
  }

  _success(List<AddressData> _response) {
    _waits(false);

    setState(() {
      shippingAddress = _response;
    });
    print("CALL _success Done ---> " + _response.length.toString());
    /*openDialog(strings.get(
        135)); // "A letter with a new password has been sent to the specified E-mail",*/
  }

  _successSave(List<AddressData> _response, AddressData _current) {
    _waits(false);

    String msg = 'Address is saved';
    showInSnackBar(msg, Colors.black);
    print("Click Save button >" + addressValues.toString());
    setState(() {
      visibleInput = !visibleInput;
      print("DATA COMMING>> " + _response.length.toString());
      shippingAddress.add(_current);
      print("DATA COMMING 1> " + shippingAddress.length.toString());
    });
  }

  _successDelete(List<AddressData> _response, AddressData _current) {
    _waits(false);

    String msg = 'Address deleted successfully.';
    showInSnackBar(msg, Colors.black);
    print("Click Save button >" + addressValues.toString());
    setState(() {
      shippingAddress.remove(_current);
      print("DATA COMMING 1> " + shippingAddress.length.toString());
    });
  }

  _errorAddress(String error) {
    _waits(false);
    print("CALL ERROR _success >>> " + error.toString());
    if (error == "5000") {}
    if (error == "5001") {}
  }

  _errorDeleteAddress(String error) {
    _waits(false);
    print("CALL ERROR _success >>> " + error.toString());
    if (error == "5000") {}
    if (error == "5001") {}
  }

  _waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
  }

  saveNewAddress() {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          children: <Widget>[
            Text(
              'No address saved',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 20.0),
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width / 3.2,
              child: OutlineButton(
                onPressed: () {
                  setState(() {
                    visibleInput = true;
                  });
                },
                child: Text(
                  'Add new',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                borderSide: BorderSide(color: Colors.black, width: 1.8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            )
          ],
        ),
      ),
    );
  }

  showSavedAddress() {
    return Container(
      child: Column(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: shippingAddress.length,
            itemBuilder: (BuildContext context, int index) {
              AddressData item = shippingAddress[index];
              //JsonCodec codec = new JsonCodec();
              //Map result = item.text.toString().cast<Map>();

              final jsonResponse = json.decode(item.text);
              Map responseJson = json.decode(item.text);

              print("DATA HCHC a> " +
                  item.defaultAddress.toString() +
                  " SIZE " +
                  shippingAddress.length.toString() +
                  " var " +
                  responseJson["name"]);
              return Card(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(Icons.home),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            responseJson["name"],
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5.0),
                          /*Text(
                            item.defaultAddress,
                            style: TextStyle(fontSize: 15.0),
                          ),*/
                          Text(
                            responseJson["area"] + "," + responseJson["landMark"],
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Text(
                            responseJson["state"] +
                                "," +
                                responseJson["city"] +
                                "-" +
                                responseJson["pinCode"],
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Text("Phone number : " + responseJson["mobileNumber"])
                        ],
                      ),
                      Radio(
                        value: index,
                        groupValue: selectedAddress,
                        onChanged: (value) {
                          setState(() {
                            selectedAddress = index;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          DeleteAddress(item);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 3,
                                offset:
                                    Offset(1, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Icon(Icons.delete,
                              color: Colors.white.withOpacity(0.8), size: 26),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 10.0),
          ButtonTheme(
            minWidth: MediaQuery.of(context).size.width / 3.2,
            child: OutlineButton(
              onPressed: () {
                setState(() {
                  visibleInput = true;
                });
              },
              child: Text(
                'Add new',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
              borderSide: BorderSide(color: Colors.black, width: 1.8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          )
        ],
      ),
    );
  }

  animateContainers() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 1000),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: !visibleInput
          ? (shippingAddress.length == 0)
              ? saveNewAddress()
              : showSavedAddress()
          : ShippingAddressInput(addressValues, this.validateInput,_scaffoldKey),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listShippingAddress();
  }

  DeleteAddress(AddressData item) {
    print("Click Working " + item.id);
    deleteAddress(
        item.id, account.token, _successDelete, _errorDeleteAddress, item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CheckoutAppBar('Back', 'Next', this.checkoutAddress,""),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /*Text(
                    'Shipping',
                    style: TextStyle(
                      fontFamily: 'NovaSquare',
                      fontSize: 35.0,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 25.0),
                  Center(
                    child: Icon(
                      Icons.local_shipping,
                      size: 220.0,
                    ),
                  ),*/
                  Text(
                    'Shipping Address',
                    style: TextStyle(
                        fontFamily: 'NovaSquare',
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  animateContainers()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  openDialog_(String _text) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: new Text(_text),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {
            _scaffoldKey.currentState.removeCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
