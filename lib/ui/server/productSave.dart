
import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:livetraxdigitl/ui/config/api.dart';
import 'package:livetraxdigitl/ui/server/products.dart';

import 'category.dart';


foodSave(String name, String desc, String image,String audio, String lyricsid,String published,
    String price, String restaurant, String category, String ingredients, String extras, String nutritions,
    String edit, String editid,
    String uid,  String date,String time,String exptype,Function(List<ImageData>, List<FoodsData>, List<RestaurantData>, List<ExtrasGroupData>, List<NutritionGroupData>, String id) callback, Function(String) callbackError) async {

  var url = '${serverPath}foodSave';
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': "application/json",
    'Authorization' : "Bearer $uid",
  };
  var body = json.encoder.convert({
    "name": name,
    "imageid": image,
    "audioid": audio,
    "lyricsid": lyricsid,
    "price": price,
    "desc" : desc,
    "restaurant" : restaurant,
    "category" : category,
    "ingredients" : ingredients,
    "published": published,
    "extras": extras,
    "nutritions": nutritions,
    "edit": edit,
    "editId" : editid,
    "date" : "$date",
    "time" : "$time",
    "type" : "$exptype",
  });
  print('URL: $url');
  print('body: $body');
  try {
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] != "0")
        return callbackError(jsonResult["error"]);
      var ret = ResponseFoods.fromJson(jsonResult);
      callback(ret.images, ret.foods, ret.restaurants, ret.extrasGroupData, ret.nutritionGroupData, ret.id);
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

