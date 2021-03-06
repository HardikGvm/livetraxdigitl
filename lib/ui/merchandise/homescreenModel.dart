import 'package:livetraxdigitl/ui/config/constant.dart';
import 'package:livetraxdigitl/ui/model/categories.dart';
import 'package:livetraxdigitl/ui/model/foods.dart';
import 'package:livetraxdigitl/ui/model/geolocator.dart';
import 'package:livetraxdigitl/ui/model/pref.dart';
import 'package:livetraxdigitl/ui/server/mainwindowdata.dart';
import 'package:livetraxdigitl/ui/server/secondstep.dart';

import '../../main.dart';

AppSettings appSettings = AppSettings();

class HomeScreenModel {
  MainWindowDataAPI _mainWindowDataServerApi = MainWindowDataAPI();
  MainWindowData mainWindowData;
  SecondStepData secondStepData;

  Function(String) _callbackError;
  Function() _callback;
  var location = MyLocation();

  _error(String error) {
    print(error);
    _callbackError(error);
  }

  bool _init = false;

  _dataLoad(MainWindowData _data) async {
    if (!_data.success) return _error("_data = null");
    if (_init) return _callback();
    appSettings = _data.settings;
    theme.setAppSettings();


    //basket.defCurrency = _data.currency;
    //basket.taxes = _data.defaultTax;
    // top restaurants
    /*if (_data.toprestaurants != null)
      topRestaurants = _data.toprestaurants;*/

    // restaurants near your
    /*if (_data.restaurants != null)
      nearYourRestaurants = _data.restaurants;*/

    categories = _data.categories;

    // favorites
    mostPopular = _data.favorites;

    // top foods
    topFoods = _data.topFoods;

    // reviews
    if (_data.restaurantsreviews != null) {
      /*for (var review in _data.restaurantsreviews){
        if (review.name != "null")
          reviews.add(Reviews(image: "${review.image}", name: review.name,
              text: review.desc,
              date: review.updatedAt,
              id : review.id, star: review.rate),
          );
      }*/
    }

    mainWindowData = _data;
    _init = true;
    _callback();
    account.redraw();
    pref.set(Pref.bottomBarType, appSettings.bottomBarType);
  }

  load(Function() callback, Function(String) callbackError) {
    _callbackError = callbackError;
    _callback = callback;
    //if (mainWindowData != null) return _dataLoad(mainWindowData); // Load Old data
    _mainWindowDataServerApi.get(_dataLoad, _error);
    print("PASS ID HERE <<>> " + Artistid);
    loadSecondStep(account.token, Artistid, _secondDataLoad, _error);
  }

  _secondDataLoad(SecondStepData _secondStepData) {
    if (_secondStepData.error == "0") {

      secondStepData = _secondStepData;
      addFoods(secondStepData.foods);
      print("======DATA Display======");
      print(secondStepData.foods.first.name);
      print(secondStepData.foods.first.category);
      print(secondStepData.foods.first.desc);
      print(secondStepData.foods.first.imageid);
      print(secondStepData.foods.first.audio);
      print("======DATA Display END======");
      account.redraw();
    }
  }

  distance() async {
    /*  for (var item in nearYourRestaurants)
      item.distance = await location.distance(item.lat, item.lng);
    nearYourRestaurants.sort((a, b) => a.compareTo(b));*/
  }
}
