import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tomo_app/ui/config/api.dart';
import 'package:tomo_app/ui/model/utils.dart';

addEventAPI(
    String artist,
    String title,
    String desc,
    String event_date,
    String event_time,
    String price,
    Function(String message) callback,
    Function(String) callbackError) async {
  try {

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
    };

    var body = json.encoder.convert({
      'artist': '$artist',
      'title': '$title',
      'desc': '$desc',
      'event_date': '$event_date',
      'event_time': '$event_time',
      'price': '$price',
    });

    var url = "${serverPath}addEvent";

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
      if (ret.message != null) {
        callback(ret.message);
      }
    } else
      callbackError("statusCode=${response.statusCode}");
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
