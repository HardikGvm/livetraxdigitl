import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:livetraxdigitl/ui/config/api.dart';

import 'login.dart';

register(
    String email,
    String password,
    String name,
    String type,
    String photoUrl,
    Function(String name, String password, String avatar, String email,
            String token, String, String uid, String referral_code)
        callback,
    Function(String) callbackError,
    String userType,
    String referral_code) async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
    };

    //if (photoUrl.toString() == "null") {
    photoUrl = "";
    //}
    /*
    * Role-1 Admin
      Role-2 Artist
      Role-4 Fan*/
    String role = "4";
    var body;
    if (userType == "artist") {
      role = "2";
      body = json.encoder.convert({
        'email': '$email',
        'password': '$password',
        'artistName': '$name',
        'name': '$name',
        'typeReg': '$type',
        'photoUrl': "$photoUrl",
        'role': "$role",
        'referralCode': "$referral_code",
      });
    } else {
      body = json.encoder.convert({
        'email': '$email',
        'password': '$password',
        'name': '$name',
        'typeReg': '$type',
        'photoUrl': "$photoUrl",
        'role': "$role",
      });
    }

    var url = "${serverPath}regUser";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print("register: $url, $body");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      Response ret = Response.fromJson(jsonResult);
      //if (ret.error == "0") {
      print("CHeck Response DATT ==>>> " + (ret.data != null).toString() + " >> " + ret.error);
      print("CHeck Response ret.data.uid ==>>> " + ret.data.uid);
      if (ret.data != null) {
        var path = "";
        if (ret.data.avatar != null) path = "$serverImages${ret.data.avatar}";
        callback(ret.data.name, password, path, email, ret.data.access_token,
            ret.data.typeReg, ret.data.uid, ret.data.referral_code);
      } else if (ret.error == "3") {
        print("CHeck Response DATT ==> 3");
        callbackError("User already exist.");
      } else {
        print("CHeck Response DATT ==> 1");
        callbackError("error:ret.data=null");
      }
      /*}else {
        print("CHeck Response DATT ==> 2");
        callbackError("${ret.error}");
      }*/
    } else {
      print("CHeck Response DATT ==> 3");
      callbackError("statusCode=${response.body}");
    }
  } catch (ex) {
    print("CHeck Response DATT ==> 4 " + ex.toString());
    callbackError(ex.toString());
  }
}

class Response {
  String error;
  String message;
  UserData data;

  //String errorMsg;

  Response({this.message, this.data,this.error});

  factory Response.fromJson(Map<String, dynamic> json) {
    var a;
    if (json['data'] != null) a = UserData.fromJson(json['data']);
    return Response(
      error: json['error'].toString(),
      message: json['message'].toString(),
      data: a,
    );
  }
}
