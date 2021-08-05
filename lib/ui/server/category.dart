import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:tomo_app/ui/config/api.dart';
import 'package:tomo_app/ui/model/utils.dart';

categoryLoad(String uid, Function(List<ImageData>, List<CategoriesData>, String) callback, Function(String) callbackError) async {

  var url = '${serverPath}categoryList';
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': "application/json",
    'Authorization' : "Bearer $uid",
  };
  var body = json.encoder.convert({
  });
  try {
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      ResponseCategory ret = ResponseCategory.fromJson(jsonResult);
      callback(ret.images, ret.cat, ret.vendor);
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

class ResponseCategory {
  String error;
  String id;
  String vendor;
  List<ImageData> images;
  List<CategoriesData> cat;
  ResponseCategory({this.error, this.images, this.cat, this.id, this.vendor});
  factory ResponseCategory.fromJson(Map<String, dynamic> json){

    var t = json['category'].map((f) => CategoriesData.fromJson(f)).toList();
    var _cat = t.cast<CategoriesData>().toList();

    t = json['images'].map((f) => ImageData.fromJson(f)).toList();
    var _images = t.cast<ImageData>().toList();

    return ResponseCategory(
      error: json['error'].toString(),
      id: json['id'].toString(),
      images: _images,
      cat: _cat,
      vendor: json['vendor'].toString(),
    );
  }
}

class CategoriesData {
  int id;
  String updatedAt;
  String name;
  String desc;
  int imageid;
  String visible;
  String vendor;
  int parent;
  CategoriesData({this.id, this.name, this.visible, this.imageid, this.updatedAt, this.desc, this.parent, this.vendor});
  factory CategoriesData.fromJson(Map<String, dynamic> json) {
    return CategoriesData(
      id : toInt(json['id'].toString()),
      desc : json['desc'].toString(),
      name: json['name'].toString(),
      visible: json['visible'].toString(),
      imageid: toInt(json['imageid'].toString()),
      updatedAt: json['updated_at'].toString(),
      parent : toInt(json['parent'].toString()),
      vendor : json['vendor'].toString(),
    );
  }
}

class ImageData {
  int id;
  String filename;
  ImageData({this.id, this.filename});
  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      id : toInt(json['id'].toString()),
      filename: json['filename'].toString(),
    );
  }
}
