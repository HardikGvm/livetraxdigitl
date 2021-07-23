import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tomo_app/ui/config/api.dart';
import 'package:tomo_app/ui/model/utils.dart';

event_list_api(
    String artist,
    int page,
    int limit,
    Function(List<EventData> list) callback,
    Function(String) callbackError) async {

  try {

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
    };

    var body = json.encoder.convert({
      'artist': '$artist',
      'page': '$page',
      'limit': '$limit',
    });

    var url = "${serverPath}listEvent";

    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      print("::: Reena Data :::");
      var jsonResult = json.decode(response.body);
      Response ret = Response.fromJson(jsonResult);

      if (ret.data != null) {
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
  List<EventData> data;

  Response({this.status, this.pages, this.message, this.data});

  factory Response.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;

    List<EventData> imagesList =
        list.map((i) => EventData.fromJson(i)).toList();

    return Response(
      status: toInt(json['status'].toString()),
      pages: toInt(json['pages'].toString()),
      message: json['message'],
      data: imagesList,
    );
  }
}

class EventData {
  int id;
  int imageid;
  int artist;
  String price;
  String desc;
  String title;
  String event_date;
  String event_time;
  String image;

  EventData(
      {this.id,
      this.title,
      this.imageid,
      this.desc,
      this.artist,
      this.event_date,
      this.event_time,
      this.price,
      this.image});

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
        id: json['id'],
        title: json['title'],
        imageid: json['imageid'],
        desc: json['desc'],
        artist: json['artist'],
        event_date: json['event_date'],
        event_time: json['event_time'],
        price: json['price'],
        image: json['image']);
  }
}
