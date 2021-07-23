
import 'package:http/http.dart' as http;
import 'package:tomo_app/ui/config/api.dart';
import 'dart:convert';
import 'addressGet.dart';

deleteAddress(String id, String uid, Function(List<AddressData>,AddressData) callback, Function(String) callbackError,AddressData _Current) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    var body = json.encoder.convert({
      'id': '$id'
    });

    print('body: $body');
    var url = "${serverPath}delAddress";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    print("delAddress");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        Response ret = Response.fromJson(jsonResult);


        callback(ret.address,_Current);
      }else
        callbackError("error=${jsonResult["error"]}");
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

