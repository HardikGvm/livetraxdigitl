import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:livetraxdigitl/ui/config/api.dart';
import 'package:livetraxdigitl/ui/model/utils.dart';

event_list_api(
    String artist,
    int page,
    int limit,
    Function(List<EventData> list) callback,
    Function(String) callbackError) async {


  //await new Future.delayed(new Duration(seconds: 2));

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
    };

    var body = json.encoder.convert({
      'artist': '$artist',
      'page': '$page',
      'limit': '$limit',
      "sortBy": "event_date",
      "sortAscDesc": "asc"
    });

    var url = "${serverPath}listEvent";

    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));
    print("::: Reena Data url::: " +url);
    print("::: Reena Data body::: " +body);
    print("::: Reena Data response::: " + response.body);
    if (response.statusCode == 200) {
      print("::: Reena Data ::: " + response.body);
      print("::: Reena Data url ::: " + url + " PAGE> " + page.toString());
      var jsonResult = json.decode(response.body);
      Response ret = Response.fromJson(jsonResult);

      if (ret.data != null) {
        for (int i = 0; i < ret.data.length; i++) {
          print("IS STATUS LIVE > " +
              ret.data[i].title +
              " L." +
              ret.data[i].is_live.toString());
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
  int is_live;
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
      this.image,
      this.is_live});

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
        image: json['image'],
        is_live: json['is_live']);
  }
}
