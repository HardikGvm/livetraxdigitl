import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livetraxdigitl/main.dart';
import 'package:livetraxdigitl/ui/checkout/validateService.dart';
import 'package:livetraxdigitl/widgets/colorloader2.dart';
import 'package:livetraxdigitl/widgets/easyDialog2.dart';
import 'package:livetraxdigitl/widgets/ibutton3.dart';
import 'package:livetraxdigitl/ui/checkout/shippingAddress.dart';

class ShippingAddressInput extends StatefulWidget {
  final HashMap addressValues;
  final void Function() validateInput;
  GlobalKey<ScaffoldState> _scaffoldKey;
  ShippingAddress _obj;
  ShippingAddressInput(this.addressValues, this.validateInput,this._scaffoldKey);

  @override
  _ShippingAddressInputState createState() => _ShippingAddressInputState();
}

class _ShippingAddressInputState extends State<ShippingAddressInput> {
  HashMap addressValues = new HashMap();

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
      prefixIcon: Icon(textIcon),
    );
  }

  var windowWidth;
  var windowHeight;

  final editFullName = TextEditingController();
  final editMobilenumber = TextEditingController();
  final editPincode = TextEditingController();
  final editHouse = TextEditingController();
  final editArea = TextEditingController();
  final editlandmart = TextEditingController();
  final editCity = TextEditingController();
  final editState = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ValidateService _validateService = new ValidateService();
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        SizedBox(
          height: 80.0,
          child: Theme(
            child: TextFormField(
                controller: editFullName,
                style: TextStyle(fontSize: 16.0),
                decoration: customBorder('Full Name', Icons.person),
                keyboardType: TextInputType.text,
                //validator: (value) => _validateService.isEmptyField(value),
                onSaved: (String val) => widget.addressValues['name'] = val),
            data: Theme.of(context).copyWith(primaryColor: Colors.black),
          ),
        ),
        SizedBox(height: 8.0),
        SizedBox(
          height: 80.0,
          child: Theme(
              child: TextFormField(
                  controller: editMobilenumber,
                  style: TextStyle(fontSize: 16.0),
                  decoration: customBorder('Mobile number', Icons.call),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"^[^._]+$")),
                    LengthLimitingTextInputFormatter(10)
                  ],
                  //validator: (value) => _validateService.isEmptyField(value),
                  onSaved: (String val) =>
                      widget.addressValues['mobileNumber'] = val),
              data: Theme.of(context).copyWith(primaryColor: Colors.black)),
        ),
        SizedBox(height: 8.0),
        SizedBox(
          height: 80.0,
          child: Theme(
            child: TextFormField(
                controller: editPincode,
                style: TextStyle(fontSize: 16.0),
                decoration: customBorder('PIN code', Icons.code),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"^[^._]+$")),
                  LengthLimitingTextInputFormatter(6)
                ],
                //validator: (value) => _validateService.isEmptyField(value),
                onSaved: (String val) => widget.addressValues['pinCode'] = val),
            data: Theme.of(context).copyWith(primaryColor: Colors.black),
          ),
        ),
        SizedBox(height: 8.0),
        SizedBox(
          height: 80.0,
          child: Theme(
            child: TextFormField(
                controller: editHouse,
                style: TextStyle(fontSize: 16.0),
                decoration:
                    customBorder('Flat, House no, Apartment', Icons.home),
                keyboardType: TextInputType.text,
                //validator: (value) => _validateService.isEmptyField(value),
                onSaved: (String val) => widget.addressValues['address'] = val),
            data: Theme.of(context).copyWith(primaryColor: Colors.black),
          ),
        ),
        SizedBox(height: 8.0),
        SizedBox(
          height: 80.0,
          child: Theme(
            child: TextFormField(
                controller: editArea,
                style: TextStyle(fontSize: 16.0),
                decoration: customBorder(
                    'Area, Colony, Street, Sector, Village',
                    Icons.location_city),
                keyboardType: TextInputType.text,
                //validator: (value) => _validateService.isEmptyField(value),
                onSaved: (String val) => widget.addressValues['area'] = val),
            data: Theme.of(context).copyWith(primaryColor: Colors.black),
          ),
        ),
        SizedBox(height: 8.0),
        SizedBox(
          height: 80.0,
          child: Theme(
            child: TextFormField(
                controller: editlandmart,
                decoration: customBorder('Landmark', Icons.location_city),
                style: TextStyle(fontSize: 16.0),
                keyboardType: TextInputType.text,
                //validator: (value) => _validateService.isEmptyField(value),
                onSaved: (String val) =>
                    widget.addressValues['landMark'] = val),
            data: Theme.of(context).copyWith(primaryColor: Colors.black),
          ),
        ),
        SizedBox(height: 8.0),
        SizedBox(
          height: 80.0,
          child: Theme(
            child: TextFormField(
                controller: editCity,
                decoration: customBorder('City', Icons.location_city),
                style: TextStyle(fontSize: 16.0),
                keyboardType: TextInputType.text,
                //validator: (value) => _validateService.isEmptyField(value),
                onSaved: (String val) => widget.addressValues['city'] = val),
            data: Theme.of(context).copyWith(primaryColor: Colors.black),
          ),
        ),
        SizedBox(height: 8.0),
        SizedBox(
          height: 80.0,
          child: Theme(
            child: TextFormField(
                controller: editState,
                decoration: customBorder('State', Icons.location_city),
                style: TextStyle(fontSize: 16.0),
                keyboardType: TextInputType.text,
                //validator: (value) => _validateService.isEmptyField(value),
                onSaved: (String val) => widget.addressValues['state'] = val),
            data: Theme.of(context).copyWith(primaryColor: Colors.black),
          ),
        ),
        ButtonTheme(
          minWidth: MediaQuery.of(context).size.width / 3.2,
          child: OutlineButton(
            onPressed: () {
              if (editFullName.text.trim().isEmpty) {
                return openDialog("Enter your full name"); // "Enter your Login"
              }
              if (editMobilenumber.text.trim().isEmpty) {
                return openDialog(
                    "Enter your mobile number"); // "Enter your Login"
              }
              if (editPincode.text.trim().isEmpty) {
                return openDialog("Enter your pincode"); // "Enter your Login"
              }
              if (editHouse.text.trim().isEmpty) {
                return openDialog(
                    "Enter your Flat,house or apartment"); // "Enter your Login"
              }
              if (editArea.text.trim().isEmpty) {
                return openDialog("Enter your area"); // "Enter your Login"
              }
              if (editlandmart.text.trim().isEmpty) {
                return openDialog("Enter your landmark"); // "Enter your Login"
              }
              if (editCity.text.trim().isEmpty) {
                return openDialog("Enter your city"); // "Enter your Login"
              }
              if (editState.text.trim().isEmpty) {
                return openDialog("Enter your state"); // "Enter your Login"
              }

              widget.validateInput();
            },
            child: Text(
              'Save',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            borderSide: BorderSide(color: Colors.black, width: 1.8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
        /*if (_wait)
          (Container(
            color: Color(0x80000000),
            width: windowWidth,
            height: windowHeight,
            child: Center(
              child: ColorLoader2(
                color1: theme.colorPrimary,
                color2: theme.colorCompanion,
                color3: theme.colorPrimary,
              ),
            ),
          ))
        else
          (Container()),

        IEasyDialog2(
          setPosition: (double value) {
            _show = value;
          },
          getPosition: () {
            return _show;
          },
          color: theme.colorGrey,
          body: _dialogBody,
          backgroundColor: Colors.white,
        ),*/
      ],
    );
  }

  @override
  void dispose() {
    editFullName.dispose();
    editMobilenumber.dispose();
    editPincode.dispose();
    editHouse.dispose();
    editArea.dispose();
    editlandmart.dispose();
    editCity.dispose();
    editState.dispose();

    super.dispose();
  }


  openDialog(String _text) {
    widget._scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: new Text(_text),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {
            widget._scaffoldKey.currentState.removeCurrentSnackBar();
          },
        ),
      ),
    );
  }




}
