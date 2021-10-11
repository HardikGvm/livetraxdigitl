import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:livetraxdigitl/ui/config/api.dart';

//uploadImage(String _image, String uid, Function(String, String) callback, Function(String) callbackError) async {
uploadImage(String _avatarFile, String uid, Function(String,int id) callback,
    Function(String) callbackError) async {
  //
  // resize image
  //
  try {
    // Image image = decodeImage(File(_avatarFile).readAsBytesSync());
    // Image thumbnail = copyResize(image, width: 1000);
    // File(_avatarFile)..writeAsBytesSync(encodeJpg(thumbnail));

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Bearer $uid"
    };
    var url = "${serverPath}uploadImage";
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.headers.addAll(requestHeaders);
    var pic = await http.MultipartFile.fromPath("file", _avatarFile);
    request.files.add(pic);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    print("uploadImage $request");
    print(responseString);
    var jsonResult = json.decode(responseString);
    Response ret = Response.fromJson(jsonResult);
    if (ret.error == "0") {
      var path = "";
      if (ret.filename != null)
        path = "$serverImages${ret.filename}";
      else
        path = "${serverImages}noimage.png";
      callback(path,ret.id);
    } else
      callbackError(ret.error.toString());
  } catch (ex) {
    callbackError(ex.toString());
  }
}

class Response {
  String error;
  String filename;
  int id;

  Response({this.error, this.filename, this.id});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      error: json['error'].toString(),
      filename: json['filename'].toString(),
      id: int.parse(json['id'].toString()),
    );
  }
}
