

import 'package:livetraxdigitl/ui/server/mainwindowdata.dart';

List<Restaurants> nearYourRestaurants = [];
List<Restaurants> topRestaurants = [];

Restaurants getRestaurant(String id){
  for (var item in nearYourRestaurants){
    if (item.id == id)
      return item;
  }
  return null;
}