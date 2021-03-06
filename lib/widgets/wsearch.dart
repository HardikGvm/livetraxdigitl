import 'package:flutter/material.dart';
import 'package:livetraxdigitl/ui/model/categories.dart';
import 'package:livetraxdigitl/ui/model/topRestourants.dart';
import 'package:livetraxdigitl/ui/server/category.dart';

import '../main.dart';

String restaurantSearchValue = "0";
// var categoriesSearchValue =0;
var _categoriesSearchValue = 0;
restaurantsComboBox(double windowWidth, Function redraw) {
  var menuItems = List<DropdownMenuItem>();
  /*menuItems.add(DropdownMenuItem(
    child: Text(strings.get(133), style: theme.text14,), // All
    value: "0",
  ),);*/
  for (var item in nearYourRestaurants) {
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
      margin: EdgeInsets.only(left: 15, right: 15),
      width: windowWidth,
      child: Row(
        children: [
          /*Text(strings.get(267), style: theme.text14bold,), // Market
          SizedBox(width: 10,),
          Expanded(child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                  isExpanded: true,
                  value: restaurantSearchValue,
                  items: menuItems,
                  onChanged: (value) {
                    restaurantSearchValue = value;
                    redraw();
                  })
          ))*/
        ],
      ));
}

cateroriesComboBox(double windowWidth, Function redraw) {
  List<DropdownMenuItem> menuItems = [];
  print("Categories Filter====$categories===" + categories.first.id);
  menuItems.add(
    DropdownMenuItem(
      child: Text(
        strings.get(189),
        style: theme.text12grey,
      ), // No
      value: 0,
    ),
  );
  if (categories.isNotEmpty) {
    for (var item in categories) {
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
      margin: EdgeInsets.only(left: 15, right: 15),
      width: windowWidth,
      child: Row(
        children: [
          Text(
            strings.get(268),
            style: theme.text14bold,
          ), // Categories
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                      isExpanded: true,
                      value: _categoriesSearchValue,
                      items: menuItems,
                      onChanged: (value) {
                        String vv=value;
                        _categoriesSearchValue = value;
                        print(int.parse(vv));
                        print("categoriesSearchValue======"+_categoriesSearchValue.toString());
                        redraw();

                      }

                      )))
        ],
      ));
}

