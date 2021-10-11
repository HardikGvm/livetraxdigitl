import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:livetraxdigitl/main.dart';
import 'package:livetraxdigitl/ui/config/api.dart';

walletBalance(String token, Function(String balance) callback,
    Function(String) callbackError) async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $token",
    };

    // var body = json.encoder.convert({'id': '$id'});

    var url = "${serverPath}walletgb";
    var body = json.encoder.convert({
    });
    print(":::requestHeaders::: " +requestHeaders.toString());

    var response = await http
        .post(Uri.parse(url), headers: requestHeaders,body: body)
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      Response ret = Response.fromJson(jsonResult);
      //if (ret.error == "0") {
      print('Response Message: ${ret.balance}');
      if (ret.balance != null) {
        callback(ret.balance);
      }
    } else {
      callbackError("statusCode=${response.statusCode}");
    }
  } catch (ex) {
    callbackError(ex.toString());
  }
}
class Response {
  int error;
  String balance;

  Response({this.error, this.balance});

  Response.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['balance'] = this.balance;
    return data;
  }
}
// class Response {
//   int status;
//   String message;
//
//   Response({this.status, this.message});
//
//   factory Response.fromJson(Map<String, dynamic> json) {
//     return Response(
//       status: toInt(json['status'].toString()),
//       message: json['message'],
//     );
//   }
// }
