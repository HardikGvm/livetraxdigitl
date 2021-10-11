import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:livetraxdigitl/ui/config/api.dart';

getplaylistByArtist(
    String uid,
    String artistId,

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
    var url = "${serverPath}getplaylistByArtist";

    // var body = json.encoder.convert({
    //
    // });
    var body = json.encoder.convert({
      'artistid': artistId,
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

// class Response {
//   int status;
//   String message;
//   int pages;
//   List<Playlist> palyList;
//
//   Response({this.status, this.message, this.pages, this.palyList});
//
//   Response.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     pages = json['pages'];
//     if (json['palyList'] != null) {
//       palyList = new List<Playlist>();
//       json['palyList'].forEach((v) {
//         palyList.add(new Playlist.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     data['pages'] = this.pages;
//     if (this.palyList != null) {
//       data['palyList'] = this.palyList.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
class Response {
  int status;
  String message;
  List<PalyList> palyList;

  Response({this.status, this.message, this.palyList});

  Response.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['palyList'] != null) {
      palyList = new List<PalyList>();
      json['palyList'].forEach((v) {
        palyList.add(new PalyList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.palyList != null) {
      data['palyList'] = this.palyList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PalyList {
  int id;
  int albumId;
  String createdAt;
  String updatedAt;
  String title;
  String desc;
  int imageid;
  String audio;
  int user;
  int artistid;
  int lyricsid;
  String music;
  String image;
  String lyrics;
  String lyricsData;
  bool isSelected = false;
  PalyList(
      {this.id,
        this.albumId,
        this.createdAt,
        this.updatedAt,
        this.title,
        this.desc,
        this.imageid,
        this.audio,
        this.user,
        this.artistid,
        this.lyricsid,
        this.music,
        this.image,
        this.lyrics,
        this.lyricsData});

  PalyList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    albumId = json['album_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    title = json['title'];
    desc = json['desc'];
    imageid = json['imageid'];
    audio = json['audio'];
    user = json['user'];
    artistid = json['artistid'];
    lyricsid = json['lyricsid'];
    music = json['music'];
    image = json['image'];
    lyrics = json['lyrics'];
    lyricsData = json['lyricsData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['album_id'] = this.albumId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['imageid'] = this.imageid;
    data['audio'] = this.audio;
    data['user'] = this.user;
    data['artistid'] = this.artistid;
    data['lyricsid'] = this.lyricsid;
    data['music'] = this.music;
    data['image'] = this.image;
    data['lyrics'] = this.lyrics;
    data['lyricsData'] = this.lyricsData;
    return data;
  }
}
// class Response {
//   int status;
//   String message;
//   List<PalyList> palylist;
//
//   Response({this.status, this.message, this.palylist});
//
//   Response.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['palyList'] != null) {
//       palylist = new List<PalyList>();
//       json['palyList'].forEach((v) {
//         palylist.add(new PalyList.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.palylist != null) {
//       data['palyList'] = this.palylist.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class PalyList {
//   int id;
//   int albumId;
//   String createdAt;
//   String updatedAt;
//   String title;
//   String desc;
//   int imageid;
//   String audio;
//   int user;
//   int artistid;
//   int lyricsid;
//   String music;
//   String image;
//   String lyrics;
//
//   PalyList(
//       {this.id,
//         this.albumId,
//         this.createdAt,
//         this.updatedAt,
//         this.title,
//         this.desc,
//         this.imageid,
//         this.audio,
//         this.user,
//         this.artistid,
//         this.lyricsid,
//         this.music,
//         this.image,
//         this.lyrics});
//
//   PalyList.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     albumId = json['album_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     title = json['title'];
//     desc = json['desc'];
//     imageid = json['imageid'];
//     audio = json['audio'];
//     user = json['user'];
//     artistid = json['artistid'];
//     lyricsid = json['lyricsid'];
//     music = json['music'];
//     image = json['image'];
//     lyrics = json['lyrics'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['album_id'] = this.albumId;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['title'] = this.title;
//     data['desc'] = this.desc;
//     data['imageid'] = this.imageid;
//     data['audio'] = this.audio;
//     data['user'] = this.user;
//     data['artistid'] = this.artistid;
//     data['lyricsid'] = this.lyricsid;
//     data['music'] = this.music;
//     data['image'] = this.image;
//     data['lyrics'] = this.lyrics;
//     return data;
//   }
// }
// class Playlist {
//   int id;
//   int albumId;
//   String createdAt;
//   String updatedAt;
//   String title;
//   String desc;
//   int imageid;
//   String audio;
//   int user;
//   int artistid;
//   String music;
//   String image;
//   bool isSelected = false;
//
//   Playlist(
//       {this.id,
//       this.albumId,
//       this.createdAt,
//       this.updatedAt,
//       this.title,
//       this.desc,
//       this.imageid,
//       this.audio,
//       this.user,
//       this.artistid,
//       this.music,
//       this.image});
//
//   Playlist.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     albumId = json['album_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     title = json['title'];
//     desc = json['desc'];
//     imageid = json['imageid'];
//     audio = json['audio'];
//     user = json['user'];
//     artistid = json['artistid'];
//     music = json['music'];
//     image = json['image'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['album_id'] = this.albumId;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['title'] = this.title;
//     data['desc'] = this.desc;
//     data['imageid'] = this.imageid;
//     data['audio'] = this.audio;
//     data['user'] = this.user;
//     data['artistid'] = this.artistid;
//     data['music'] = this.music;
//     data['image'] = this.image;
//     return data;
//   }
// }
