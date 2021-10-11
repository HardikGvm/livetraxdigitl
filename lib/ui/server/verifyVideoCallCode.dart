import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:livetraxdigitl/ui/config/api.dart';

verifyVideoCallCode(
    String token,
    String verifyCode,
    bool updateCode,
    Function(Data Data) callback,
    Function(String) callbackError) async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $token",
    };

    // var body = json.encoder.convert({'id': '$id'});

    var url = "${serverPath}videoCallstatus";
    var body = json.encoder.convert({
      "code": int.parse(verifyCode),
      "update":updateCode

    });
    print(":::requestHeaders::: " + requestHeaders.toString());
    print(":::body::: " + body);

    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));
    var jsonResult = json.decode(response.body);
    Response ret = Response.fromJson(jsonResult);
    // if (response.statusCode == 200) {
    //   var jsonResult = json.decode(response.body);
    //   Response ret = Response.fromJson(jsonResult);
    //   //if (ret.error == "0") {
    //   print('Response Message: ${ret.data}');
    //   if (ret.data != null) {
    //     callback(ret.data);
    //   }
    // } else {
    //   callbackError("statusCode=${response.statusCode}");
    // }

    if (ret.status == 200) {
      var msg=ret.message;
      if (msg != null && msg.isNotEmpty && msg=='success' ) {
        callback(ret.data);
      } else
        callbackError("${ret.message}");
    } else
      callbackError("${ret.message}");

  } catch (ex) {
    callbackError(ex.toString());
  }
}

// class Response {
//   int status;
//   String message;
//   Data data;
//
//   Response({this.status, this.message, this.data});
//
//   Response.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data.toJson();
//     }
//     return data;
//   }
// }
class Response {
  int status;
  String message;
  Data data;

  Response({this.status, this.message, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  int user;
  int artistid;
  int code;
  int valid;
  String createdAt;
  String updatedAt;
  String artistname;

  Data(
      {this.id,
        this.user,
        this.artistid,
        this.code,
        this.valid,
        this.createdAt,
        this.updatedAt,
        this.artistname});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    artistid = json['artistid'];
    code = json['code'];
    valid = json['valid'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    artistname = json['artistname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['artistid'] = this.artistid;
    data['code'] = this.code;
    data['valid'] = this.valid;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['artistname'] = this.artistname;
    return data;
  }
}
// class Data {
//   int id;
//   int user;
//   int artistid;
//   int code;
//   int valid;
//   String createdAt;
//   String updatedAt;
//
//   Data(
//       {this.id,
//         this.user,
//         this.artistid,
//         this.code,
//         this.valid,
//         this.createdAt,
//         this.updatedAt});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     user = json['user'];
//     artistid = json['artistid'];
//     code = json['code'];
//     valid = json['valid'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user'] = this.user;
//     data['artistid'] = this.artistid;
//     data['code'] = this.code;
//     data['valid'] = this.valid;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
