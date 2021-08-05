import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tomo_app/ui/config/api.dart';
import 'package:tomo_app/ui/model/utils.dart';

login(
    String email,
    String password,
    Function(
            String name,
            String password,
            String avatar,
            String email,
            String token,
            String phone,
            int unreadNotify,
            String,
            String role,
            String uid,String referral_code)
        callback,
    Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
    };

    var body = json.encoder.convert({
      'email': '$email',
      'password': '$password',
    });

    var url = "${serverPath}login";

    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print("login: $url, $body");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      Response ret = Response.fromJson(jsonResult);
      //if (ret.error == "0") {
      if (ret.data != null) {
        var path = "";
        if (ret.data.avatar != null && ret.data.avatar.toLowerCase() != "null")
          path = "$serverImages${ret.data.avatar}";
        callback(
            ret.data.name,
            password,
            path,
            email,
            ret.data.access_token,
            ret.data.phone,
            ret.notify,
            ret.data.typeReg,
            ret.data.role,
            ret.data.uid,ret.data.referral_code);
        /*}else
          callbackError("error:ret.data=null");*/
      } else {
        callbackError(ret.message);
      }
    } else {
      print("CHeck Response DATT ==> 36 > " + response.body);
      callbackError("statusCode=${response.body}");
    }
  } catch (ex) {
    print("CHeck Response DATT ==> ex > " + ex.toString());
    callbackError(ex.toString());
  }
}

class Response {
  String error;
  UserData data;
  String message;

  //String accessToken;
  int notify;

  Response({this.data, this.notify, this.message});

  factory Response.fromJson(Map<String, dynamic> json) {
    var a;
    if (json['data'] != null) a = UserData.fromJson(json['data']);
    return Response(
      //error: json['error'].toString(),
      notify: toInt(json['notify'].toString()),
      data: a,
      message: json['message'].toString(),
    );
  }
}

class UserData {
  String name;
  String phone;
  String avatar;
  String typeReg;
  String role;
  String uid;
  String access_token;
  String referral_code;

  UserData(
      {this.name,
      this.avatar,
      this.phone,
      this.typeReg,
      this.role,
      this.uid,
      this.access_token, this.referral_code});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'].toString(),
      avatar: json['avatar'].toString(),
      phone: json['phone'].toString(),
      typeReg: json['typeReg'].toString(),
      role: json['role'].toString(),
      uid: json['id'].toString(),
      access_token: json['access_token'].toString(),
      referral_code: json.containsKey('referral_code') ? json['referral_code'].toString() : "",
    );
  }
}
