import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tomo_app/ui/config/api.dart';

import 'login.dart';

register(
    String email,
    String password,
    String name,
    String type,
    String photoUrl,
    Function(String name, String password, String avatar, String email,
            String token, String)
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
      'name': '$name',
      'typeReg': '$type',
      'photoUrl': "$photoUrl"
    });

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
      print("CHeck Response DATT ==> " + (ret.data != null).toString());
      if (ret.data != null) {
        var path = "";
        if (ret.data.avatar != null) path = "$serverImages${ret.data.avatar}";
        callback(ret.data.name, password, path, email, ret.accessToken,
            ret.data.typeReg);
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
      callbackError("statusCode=${response.statusCode}");
    }
  } catch (ex) {
    print("CHeck Response DATT ==> 4");
    callbackError(ex.toString());
  }
}

class Response {
  String error;
  UserData data;
  String accessToken;

  //String errorMsg;

  Response({this.error, this.data, this.accessToken});

  factory Response.fromJson(Map<String, dynamic> json) {
    var a;
    if (json['data'] != null) a = UserData.fromJson(json['data']);
    return Response(
      //error: json['error'].toString(),
      accessToken: json['access_token'].toString(),
      data: a,
    );
  }
}
