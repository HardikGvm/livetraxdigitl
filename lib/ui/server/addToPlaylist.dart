import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:livetraxdigitl/ui/config/api.dart';
import 'package:livetraxdigitl/ui/config/constant.dart';

addToPlaylist(String token, String desc, String title, String imageid,
    String audio,   String artistid,String lyricsid,Function() callback, Function(String) callbackError) async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $token",
    };

    // var body = json.encoder.convert({'id': '$id'});

    var url = "${serverPath}addToPlaylist";
    var body = json.encoder.convert({
      "album_id": 0,
      'desc': '$desc',
      'title': '$title',
      'imageid': int.parse(imageid),
      'audio': '$audio',
      'artistid': int.parse(artistid) ,
      'lyricsid': int.parse(lyricsid) ,
    });
    print(":::requestHeaders::: " + requestHeaders.toString());
    print(":::body::: " + body);

    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      Response ret = Response.fromJson(jsonResult);
      //if (ret.error == "0") {
      print('Response Message: ${ret.title}');
      if (ret.artistid != null) {
        callback();
      }
    } else {
      callbackError("statusCode=${response.statusCode}");
    }
  } catch (ex) {
    callbackError(ex.toString());
  }
}

class Response {
  int albumId;
  String desc;
  String title;
  int imageid;
  String audio;
  int artistid;
  int user;
  CreatedAt createdAt;
  CreatedAt updatedAt;

  Response(
      {this.albumId,
      this.desc,
      this.title,
      this.imageid,
      this.audio,
      this.artistid,
      this.user,
      this.createdAt,
      this.updatedAt});

  Response.fromJson(Map<String, dynamic> json) {
    albumId = json['album_id'];
    desc = json['desc'];
    title = json['title'];
    imageid = json['imageid'];
    audio = json['audio'];
    artistid = json['artistid'];
    user = json['user'];
    createdAt = json['created_at'] != null
        ? new CreatedAt.fromJson(json['created_at'])
        : null;
    updatedAt = json['updated_at'] != null
        ? new CreatedAt.fromJson(json['updated_at'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['album_id'] = this.albumId;
    data['desc'] = this.desc;
    data['title'] = this.title;
    data['imageid'] = this.imageid;
    data['audio'] = this.audio;
    data['artistid'] = this.artistid;
    data['user'] = this.user;
    if (this.createdAt != null) {
      data['created_at'] = this.createdAt.toJson();
    }
    if (this.updatedAt != null) {
      data['updated_at'] = this.updatedAt.toJson();
    }
    return data;
  }
}

class CreatedAt {
  String date;
  int timezoneType;
  String timezone;

  CreatedAt({this.date, this.timezoneType, this.timezone});

  CreatedAt.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    timezoneType = json['timezone_type'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['timezone_type'] = this.timezoneType;
    data['timezone'] = this.timezone;
    return data;
  }
}
