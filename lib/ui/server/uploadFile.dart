import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:livetraxdigitl/ui/config/api.dart';

//uploadImage(String _image, String uid, Function(String, String) callback, Function(String) callbackError) async {
uploadFile(String _audiofile, String _imagefile, String _textfile,String uid, Function(String, int imageid,int audioid,int lyricsid) callback,
    Function(String) callbackError) async {
  //
  // resize image
  //
  try {
    //Image image = decodeImage(File(_audiofile).readAsBytesSync());
    //Image thumbnail = copyResize(image, width: 1000);

    //var data = await rootBundle.load(_audiofile);

    //File tempFile = File(_audiofile);

    // Uint8List audioByte = await _readFileByte(_audiofile);
    // String audio64 = base64.encode(audioByte);
    // print('reading of bytes is FILE  audio64>> 1');

    /*final audio = await _getAudioContent(_audiofile);
    String audio64 = base64Encode(audio);*/
    //File(_audiofile)..writeAsBytesSync(encodef(thumbnail));

    /*await File(_audiofile).writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));*/

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Bearer $uid"
    };

    print('reading of bytes is FILE  audio64>> 2');
    var url = "${serverPath}uploadAudioFile";
    print('reading of bytes is FILE  audio64>> 3');


    var request = http.MultipartRequest("POST", Uri.parse(url));
    print('reading of bytes is FILE  audio64>> 4');
    request.headers.addAll(requestHeaders);
    print('reading of bytes is FILE  audio64>> 5');
    var pic = await http.MultipartFile.fromPath("audios", _audiofile);
    print('reading of bytes is FILE  audio64>> 6');
    request.files.add(pic);

    var pic1 = await http.MultipartFile.fromPath("image", _imagefile);
    request.files.add(pic1);

    var textfile = await http.MultipartFile.fromPath("lyrics", _textfile);
    request.files.add(textfile);

    print('reading of bytes is FILE  audio64>> 7');
    print(request);
    print(request.files.first.length);
    var response = await request.send();
    print('reading of bytes is FILE  audio64>> 8');
    var responseData = await response.stream.toBytes();
    print('reading of bytes is FILE  audio64>> 9');
    var responseString = String.fromCharCodes(responseData);

    print("uploadImage $request");
    print("responseString $responseString");
    print(responseString);

    var jsonResult = json.decode(responseString);
    Response ret = Response.fromJson(jsonResult);
    print("ID=====");
    print(ret.details.imageid);
    print(ret.details.audioid);
    print(ret.details);
    if (ret.error == "0") {
      var path = "";
      if (ret.details.audioname != null)
        path = "$serverImages${ret.details.audioname}";
      else
        path = "${serverImages}noimage.png";
      callback(path, ret.details.imageid,ret.details.audioid,ret.details.lyricid);
    } else
      callbackError(ret.error.toString());
  } catch (ex) {
    print("uploadImage ERRORRRR " + ex.toString());
    callbackError(ex.toString());
  }
}

Future<Uint8List> _readFileByte(String filePath) async {
  Uri myUri = Uri.parse(filePath);
  File audioFile = new File.fromUri(myUri);
  Uint8List bytes;
  await audioFile.readAsBytes().then((value) {
    bytes = Uint8List.fromList(value);
    print('reading of bytes is FILE >> ' + filePath.toString() + " URI " + myUri.toString());
    print('reading of bytes is completed >> ' + bytes.length.toString());
  }).catchError((onError) {
    print(
        'Exception Error while reading audio from path:' + onError.toString());
  });
  return bytes;
}

Future<List<int>> _getAudioContent(String name) async {
  if (!File(name).existsSync()) {
    await _copyFileFromAssets(name);
  }
  return File(name).readAsBytesSync().toList();
}

Future<void> _copyFileFromAssets(String path) async {
  print("Check FILESSS 1--- >> " + path);
  var data = await rootBundle.load(path);
  print("Check FILESSS 2--- >> " +
      path +
      " FILESS " +
      data.offsetInBytes.toString() +
      " LENGTH " +
      data.lengthInBytes.toString());
  //final path = directory.path + '/$name';
  await File(path).writeAsBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

// class Response {
//   String error;
//   String filename;
//   int id;
//
//   Response({this.error, this.filename,this.id});
//
//   factory Response.fromJson(Map<String, dynamic> json) {
//     return Response(
//       error: json['error'].toString(),
//       filename: json['file'].toString(),
//       id: int.parse(json['id'].toString()),
//     );
//   }
// }
class Response {
  String error;
  String success;
  Details details;

  Response({this.error, this.success, this.details});

  Response.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    success = json['success'];
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['success'] = this.success;
    if (this.details != null) {
      data['details'] = this.details.toJson();
    }
    return data;
  }
}

class Details {
  int imageid;
  String imagename;
  int audioid;
  String audioname;
  int lyricid;
  String lyricfileName;

  Details(
      {this.imageid,
        this.imagename,
        this.audioid,
        this.audioname,
        this.lyricid,
        this.lyricfileName});

  Details.fromJson(Map<String, dynamic> json) {
    imageid = json['imageid'];
    imagename = json['imagename'];
    audioid = json['audioid'];
    audioname = json['audioname'];
    lyricid = json['lyricid'];
    lyricfileName = json['lyricfileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageid'] = this.imageid;
    data['imagename'] = this.imagename;
    data['audioid'] = this.audioid;
    data['audioname'] = this.audioname;
    data['lyricid'] = this.lyricid;
    data['lyricfileName'] = this.lyricfileName;
    return data;
  }
}
// class Response {
//   String error;
//   String success;
//   Details details;
//
//   Response({this.error, this.success, this.details});
//
//   Response.fromJson(Map<String, dynamic> json) {
//     error = json['error'];
//     success = json['success'];
//     details =
//     json['details'] != null ? new Details.fromJson(json['details']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['error'] = this.error;
//     data['success'] = this.success;
//     if (this.details != null) {
//       data['details'] = this.details.toJson();
//     }
//     return data;
//   }
// }
//
// class Details {
//   int imageid;
//   String imagename;
//   int audioid;
//   String audioname;
//
//   Details({this.imageid, this.imagename, this.audioid, this.audioname});
//
//   Details.fromJson(Map<String, dynamic> json) {
//     imageid = json['imageid'];
//     imagename = json['imagename'];
//     audioid = json['audioid'];
//     audioname = json['audioname'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['imageid'] = this.imageid;
//     data['imagename'] = this.imagename;
//     data['audioid'] = this.audioid;
//     data['audioname'] = this.audioname;
//     return data;
//   }
// }