import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tomo_app/ui/config/api.dart';
import 'package:tomo_app/ui/model/utils.dart';

LiveStatusEvent(int id, int isLive, Function(String message, int index) callback,
    Function(String) callbackError) async {

  try {

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
    };

    var body = json.encoder.convert({'id': '$id', 'is_live':'$isLive'});

    var url = "${serverPath}updateStatusEvent";

    print(":::Reena_Index::: " + isLive.toString() + " url " + url);

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
      print('Response Message: ${ret.message}');
      if (ret.message != null) {
        callback(ret.message, isLive);
      }
    } else {
      callbackError("statusCode=${response.statusCode}");
    }
  } catch (ex) {
    callbackError(ex.toString());
  }
}

class Response {
  int status;
  String message;

  Response({this.status, this.message});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      status: toInt(json['status'].toString()),
      message: json['message'],
    );
  }
}
