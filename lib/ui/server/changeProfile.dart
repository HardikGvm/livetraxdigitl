import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:livetraxdigitl/ui/config/api.dart';

changeProfile(String uid, String name, String email, String phone,String description,
    Function() callback, Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{"name" : ${json.encode(name)}, "email": ${json.encode(email)}, "description": ${json.encode(description)}, "phone": ${json.encode(phone)}}';

    var url = "${serverPath}changeProfile";
    print("Body Here >> " + body + " URL " + url  + " <> " + uid);
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    print(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        callback();
      }else
        callbackError(jsonResult["error"]);
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}
