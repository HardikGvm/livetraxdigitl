
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tomo_app/ui/config/api.dart';

forgotPassword(String email, Function() callback, Function(String) callbackError) async {
  try {

    var url = "${serverPath}forgot?email=$email";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json',
      'Accept': "application/json",
    }).timeout(const Duration(seconds: 30));

    print('$url');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var jsonResult = json.decode(response.body);
    if (response.statusCode == 500)
      return callbackError(jsonResult["message"].toString());

    if (response.statusCode == 200) {
      if (jsonResult["status"] == 200)
        callback();
      else
        callbackError(jsonResult["message"]);
    }else
      callbackError("statusCode=${response.statusCode}");

  } catch (ex) {
    callbackError(ex.toString());
  }
}

