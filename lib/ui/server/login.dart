import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tomo_app/ui/config/api.dart';
import 'package:tomo_app/ui/model/utils.dart';

login(
    String email,
    String password,
    Function(String name, String password, String avatar, String email,
            String token, String phone, int unreadNotify, String, String role)
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
        callback(ret.data.name, password, path, email, ret.accessToken,
            ret.data.phone, ret.notify, ret.data.typeReg, ret.data.role);
        /*}else
          callbackError("error:ret.data=null");*/
      } else
        callbackError(ret.error);
    } else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

class Response {
  String error;
  UserData data;
  String accessToken;
  int notify;

  Response({this.error, this.data, this.accessToken, this.notify});

  factory Response.fromJson(Map<String, dynamic> json) {
    var a;
    if (json['data'] != null) a = UserData.fromJson(json['data']);
    return Response(
      //error: json['error'].toString(),
      accessToken: json['access_token'].toString(),
      notify: toInt(json['notify'].toString()),
      data: a,
    );
  }
}

class UserData {
  String name;
  String phone;
  String avatar;
  String typeReg;
  String role;

  UserData({this.name, this.avatar, this.phone, this.typeReg,this.role});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'].toString(),
      avatar: json['avatar'].toString(),
      phone: json['phone'].toString(),
      typeReg: json['typeReg'].toString(),
      role: json['role'].toString(),
    );
  }
}
