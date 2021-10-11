import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:livetraxdigitl/ui/config/api.dart';

getvideoCallCode(
    String token,
    String productid,
    Function(String message) callback,
    Function(String) callbackError) async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $token",
    };

    // var body = json.encoder.convert({'id': '$id'});

    var url = "${serverPath}videoCall";
    var body = json.encoder.convert({
      "productid": int.parse(productid),

    });
    print(":::requestHeaders::: " + requestHeaders.toString());
    print(":::body::: " + body);

    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      Response ret = Response.fromJson(jsonResult);
      //if (ret.error == "0") {
      print('Response Message: ${ret.message}');
      if (ret.message != null) {
        callback(ret.message);
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

  Response.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
