import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:livetraxdigitl/ui/config/api.dart';

import 'getplaylistByArtist.dart';

getplayAlllist(
    String uid,
    Function(List<PalyList> list) callback,
    Function(String) callbackError) async {
  // try {
  //   Map<String, String> requestHeaders = {
  //     'Content-type': 'application/json',
  //     'Accept': "application/json",
  //     'Authorization': "Bearer $uid",
  //   };
  //
  //   var body = json.encoder.convert({
  //     'artistid': artistId,
  //   });
  //   // print("ArtistId===" + Artistid);
  //   var url = "${serverPath}getplaylistByArtist";
  //
  //   var response = await http
  //       .post(Uri.parse(url), headers: requestHeaders, body: body)
  //       .timeout(const Duration(seconds: 30));
  //
  //     print("iff");
  //     var jsonResult = json.decode(response.body);
  //     Response ret = Response.fromJson(jsonResult);
  //   if (ret.error == "0") {
  //       if (ret.playList != null) {
  //         print("pppp iff");
  //       // for (int i = 0; i < ret.playList.length; i++) {
  //       //
  //       // }
  //       callback(ret.playList);
  //     } else {
  //         print("pppp else");
  //       callbackError("playListNull");
  //     }
  //   } else
  //     print("else");
  //     callbackError("statusCode=${response.statusCode}");
  // } catch (ex) {
  //   print("catch");
  //   callbackError(ex.toString());
  // }
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uid",
    };
    var url = "${serverPath}getplaylist";

    var body = json.encoder.convert({

    });


    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print('Response body: ${response.body}');

    var jsonResult = json.decode(response.body);
    Response ret = Response.fromJson(jsonResult);
    print('Response status: ${ret.status}');
    if (ret.status == 200) {
      if (ret.palyList.isNotEmpty) {
        callback(ret.palyList);
      } else
        callbackError("${ret.message}");
    } else
      callbackError("${ret.message}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

