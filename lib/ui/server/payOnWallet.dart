import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:livetraxdigitl/main.dart';
import 'package:livetraxdigitl/ui/config/api.dart';

payOnWallet(String token,String amount,String productId,String userId, Function(String id) callback,
    Function(String) callbackError) async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $token",
    };

    // var body = json.encoder.convert({'id': '$id'});

    var url = "${serverPath}payOnWallet";
    var body = json.encoder.convert({
      'total': '$amount',
      'comment': 'Payed',
      'productid': '$productId',
      'touser': '$userId',
    });
    print(":::requestHeaders::: " +requestHeaders.toString());

    var response = await http
        .post(Uri.parse(url), headers: requestHeaders,body: body)
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      Response ret = Response.fromJson(jsonResult);
      //if (ret.error == "0") {
      print('Response Message: ${ret.id}');
      if (ret.id != null) {
        callback(ret.id);
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
  String id;

  Response({this.error, this.balance, this.id});

  Response.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    balance = json['balance'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['balance'] = this.balance;
    data['id'] = this.id;
    return data;
  }
}
