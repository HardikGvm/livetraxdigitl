import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart';
import 'package:tomo_app/ui/config/api.dart';

uploadImage(String _avatarFile, String uid, Function(String) callback,
    Function(String) callbackError) async {
  //
  // resize image
  //
  try {
    var image = decodeImage(File(_avatarFile).readAsBytesSync());
    print("uploadAvatar decodeImage");
    var thumbnail = copyResize(image, width: 300);
    File(_avatarFile).writeAsBytesSync(encodeJpg(thumbnail));

    Map<String, String> requestHeaders = {
      'Accept': "application/json",
      'Content-type': 'application/json',
      'Authorization': "Bearer $uid"
    };

    var url = "${uploadImages}";
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.headers.addAll(requestHeaders);
    var pic = await http.MultipartFile.fromPath("file", _avatarFile);
    request.files.add(pic);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    print("uploadAvatar $request");
    print(":::Response String::: " + responseString);

    var jsonResult = json.decode(responseString);
    Response ret = Response.fromJson(jsonResult);

    if (ret.filename != null && ret.id != null) {
      callback(ret.id);
    } else
      callbackError(ret.filename);
  } catch (ex) {
    callbackError(ex.toString());
  }
}

class Response {
  String filename;
  String id;
  String date;

  Response({this.filename, this.id, this.date});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      id: json['id'].toString(),
      filename: json['filename'],
      date: json['date'],
    );
  }
}
