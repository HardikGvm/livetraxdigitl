import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tomo_app/ui/config/api.dart';
import 'package:tomo_app/ui/model/utils.dart';

musicList(
    int page,
    int limit,
    Function(List<MusicData> list) callback,
    Function(String) callbackError) async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
    };

    var body = json.encoder.convert({
      'page': '$page',
      'limit': '$limit',
    });

    var url = "${serverPath}listPlayList";

    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {

      var jsonResult = json.decode(response.body);
      Response ret = Response.fromJson(jsonResult);

      if (ret.data != null) {
        for (int i = 0; i < ret.data.length; i++) {

        }
        callback(ret.data);
      } else
        callbackError("error:ret.data=null");
    } else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

class Response {
  int status, pages;
  String message;
  List<MusicData> data;

  Response({this.status,this.message, this.pages,  this.data});

  factory Response.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;

    List<MusicData> imagesList =
    list.map((i) => MusicData.fromJson(i)).toList();

    return Response(
      status: toInt(json['status'].toString()),
      message: json['message'],
      pages: toInt(json['pages'].toString()),
      data: imagesList,
    );
  }
}

class MusicData {
  int id;
  int album_id;
  String title;
  String desc;
  int imageid;
  String audio;
  String music;
  String image;

  MusicData({this.id,
    this.album_id,
    this.title,
    this.desc,
    this.imageid,
    this.audio,
    this.music,
    this.image});

  factory MusicData.fromJson(Map<String, dynamic> json) {
    return MusicData(
        id: json['id'],
        album_id: json['album_id'],
        title: json['title'],
        desc: json['desc'],
        imageid: json['imageid'],
        audio: json['audio'],
      music: json['music'],
        image: json['image'],);
  }
}
