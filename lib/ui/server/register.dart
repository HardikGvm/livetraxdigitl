
import 'package:http/http.dart' as http;
import 'package:tomo_app/ui/config/api.dart';
import 'dart:convert';

import 'login.dart';

register(String email, String password, String name, String type, String photoUrl,
    Function(String name, String password, String avatar, String email, String token, String) callback,
    Function(String) callbackError) async {

  try {

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
    };

    var body = json.encoder.convert(
        {
          'email': '$email',
          'password': '$password',
          'name': '$name',
          'typeReg' : '$type',
          'photoUrl' : "$photoUrl"
        }
    );
    var url = "${serverPath}regUser";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    print("register: $url, $body");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      Response ret = Response.fromJson(jsonResult);
      if (ret.error == "0") {
        if (ret.data != null) {
          var path = "";
          if (ret.data.avatar != null)
            path = "$serverImages${ret.data.avatar}";
          callback(ret.data.name, password, path, email, ret.accessToken, ret.data.typeReg);
        }else
          callbackError("error:ret.data=null");
      }else
        callbackError("${ret.error}");
    }else
      callbackError("statusCode=${response.statusCode}");

  } catch (ex) {
    callbackError(ex.toString());
  }
}

class Response {
  String error;
  UserData data;
  String accessToken;
  //String errorMsg;
  Response({this.error, this.data, this.accessToken});
  factory Response.fromJson(Map<String, dynamic> json){
    var a;
    if (json['user'] != null)
      a = UserData.fromJson(json['user']);
    return Response(
      error: json['error'].toString(),
      accessToken: json['access_token'].toString(),
      data: a,
    );
  }
}
