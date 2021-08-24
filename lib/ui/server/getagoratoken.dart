import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:livetraxdigitl/ui/config/api.dart';

import 'getagoratoken_model.dart';

GetAgoraToken(
    String channelname,
    int Eventid,
    String username,
    Function(String,int, String, String) callback,
    Function(String) callbackError) async {
  try {
    //var url = "${serverPath}forgot?email=$email";

    var url = "${serverPath}genrateToken";



    var body = json.encoder.convert({
      'channelname': '$channelname',
      'username': '$username',
    });

    print("Check Body > " + "$body");

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
    };

    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print('$url');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var jsonResult = json.decode(response.body);
    if (response.statusCode == 500)
      return callbackError(jsonResult["message"].toString());

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      GetAgoraTokenData ret = GetAgoraTokenData.fromJson(jsonResult);
      if (ret.status == 200) {
        print("CALL _success Test ---> " + (ret.token != null).toString());
        if (ret.token != null) {
          callback(channelname,Eventid, username, ret.token);
        } else {
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
