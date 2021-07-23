import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tomo_app/ui/config/api.dart';
import 'package:tomo_app/ui/model/utils.dart';

artist_list_api(
    String type,
    int page,
    int limit,
    Function(List<UserData> list) callback,
    Function(String) callbackError) async {

  try {

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
    };

    var body = json.encoder.convert({
      'type': '$type',
      'page': '$page',
      'limit': '$limit',
    });

    var url = "${serverPath}getUserByType";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      Response ret = Response.fromJson(jsonResult);
      if (ret.data != null) {
        callback(ret.data);
      } else
        callbackError("error:ret.data=null");
    } else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }

}

class Response {
  int status, pages;
  String message;
  List<UserData> data;

  Response({this.status, this.pages, this.message, this.data});

  factory Response.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    print(list.runtimeType);
    List<UserData> imagesList = list.map((i) => UserData.fromJson(i)).toList();

    return Response(
      pages: toInt(json['pages'].toString()),
      status: toInt(json['status'].toString()),
      message: json['message'],
      data: imagesList,
    );
  }
}

class UserData {
  int id;
  String name;
  String artist_name;
  String referral_code;
  String email;
  String email_verified_at;
  String password;
  String remember_token;
  int role;
  int imageid;
  String description;
  String online_status;
  String address;
  String phone;
  String token;
  String fcbToken;
  int active;
  int vendor;
  String typeReg;
  int ref_artist;
  String image;

  UserData(
      {this.id,
      this.name,
      this.artist_name,
      this.referral_code,
      this.email,
      this.email_verified_at,
      this.password,
      this.remember_token,
      this.role,
      this.imageid,
      this.description,
      this.online_status,
      this.address,
      this.phone,
      this.token,
      this.fcbToken,
      this.vendor,
      this.typeReg,
      this.image});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      artist_name: json['artist_name'],
      referral_code: json['referral_code'],
      email: json['email'],
      email_verified_at: json['email_verified_at'],
      password: json['password'],
      remember_token: json['remember_token'],
      role: json['role'],
      imageid: json['imageid'],
      description: json['description'],
      online_status: json['online_status'],
      address: json['address'],
      phone: json['phone'],
      token: json['_token'],
      fcbToken: json['fcbToken'],
      vendor: json['vendor'],
      typeReg: json['typeReg'],
      image: json['image'],
    );
  }
}
