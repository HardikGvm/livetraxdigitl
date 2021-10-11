import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:livetraxdigitl/main.dart';
import 'package:livetraxdigitl/ui/config/api.dart';

walletHistory(String token, Function(List<History> history) callback,
    Function(String) callbackError) async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $token",
    };

    // var body = json.encoder.convert({'id': '$id'});

    var url = "${serverPath}walletHistory";
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
      print('Response Message: ${ret.history}');
      if (ret.history != null) {
        callback(ret.history);
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
  List<History> history;

  Response({this.status, this.history});

  Response.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['history'] != null) {
      history = new List<History>();
      json['history'].forEach((v) {
        history.add(new History.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.history != null) {
      data['history'] = this.history.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class History {
  int id;
  String createdAt;
  String updatedAt;
  int user;
  String amount;
  String total;
  int arrival;
  String comment;
  int touser;
  int productid;
  String username;
  String productname;

  History(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.amount,
        this.total,
        this.arrival,
        this.comment,
        this.touser,
        this.productid,
        this.username,
        this.productname});

  History.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'];
    amount = json['amount'];
    total = json['total'];
    arrival = json['arrival'];
    comment = json['comment'];
    touser = json['touser'];
    productid = json['productid'];
    username = json['username'];
    productname = json['productname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user'] = this.user;
    data['amount'] = this.amount;
    data['total'] = this.total;
    data['arrival'] = this.arrival;
    data['comment'] = this.comment;
    data['touser'] = this.touser;
    data['productid'] = this.productid;
    data['username'] = this.username;
    data['productname'] = this.productname;
    return data;
  }
}
