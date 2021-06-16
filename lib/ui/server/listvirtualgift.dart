import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tomo_app/ui/config/api.dart';

import 'listvirtualgift_model.dart';

listVirtualGift(Function(List<data>) callback, Function(String) callbackError) async {
  try {
    //var url = "${serverPath}forgot?email=$email";
    var url = "${serverPath}listVirtualGift";

    var response = await http.post(Uri.parse(url), headers: {
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
      var jsonResult = json.decode(response.body);
      VirtualGiftData ret = VirtualGiftData.fromJson(jsonResult);
      if (ret.status == 200) {
        print("CALL _success Test ---> " + (ret.sampledata != null).toString());
        if (ret.sampledata != null) {
          callback(ret.sampledata);
        }else{
          callbackError(ret.message);
        }
      } else
        callbackError(jsonResult["error"]);
    } else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}
