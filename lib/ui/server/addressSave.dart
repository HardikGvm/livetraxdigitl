import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:livetraxdigitl/ui/config/api.dart';

import 'addressGet.dart';

saveAddress(
    String text,
    String lat,
    String lng,
    String type,
    String defaultAddress,
    String uid,
    Function(List<AddressData>, AddressData) callback,
    Function(String) callbackError) async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uid",
    };

    var body = json.encoder.convert({
      'text': '$text',
      'lat': '$lat',
      'lng': '$lng',
      'type': '$type',
      'default': '$defaultAddress',
    });

    print('body: $body');
    var url = "${serverPath}saveAddress";
    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print("saveAddress");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401) return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        Response ret = Response.fromJson(jsonResult);
        AddressData _current = new AddressData();
        for (int i = 0; i < ret.address.length; i++) {
          print("check address here > " + (ret.address[i].text == text).toString() + " ADD> " + ret.address[i].text);
          if (ret.address[i].text == text) {
            _current = ret.address[i];
            break;
          }
        }
        callback(ret.address, _current);
      } else
        callbackError("error=${jsonResult["error"]}");
    } else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}
