import 'package:livetraxdigitl/ui/model/utils.dart';

class VirtualGiftData {
  int status;
  String message;
  List<data> sampledata;

  VirtualGiftData({this.status, this.message, this.sampledata});

  factory VirtualGiftData.fromJson(Map<String, dynamic> json) {
    var a;
    //if (json['data'] != null) a = data.fromJson(json['data']);
    if (json['data'] != null){
      var items = json['data'];
      var t = items.map((f)=> data.fromJson(f)).toList();
      a = t.cast<data>().toList();
    }
    return VirtualGiftData(
      status: toInt(json['status'].toString()),
      message: json['message'].toString(),
      sampledata: a,
    );
  }
}

class data {
  int id;
  String name;
  String image;
  String price;
  String created_at;
  String updated_at;
  bool isSelected=false;

  data(
      {this.id,
      this.name,
      this.image,
      this.price,
      this.created_at,
      this.updated_at});

  factory data.fromJson(Map<String, dynamic> json) {
    return data(
      id: toInt(json['id'].toString()),
      name: json['name'].toString(),
      image: json['image'].toString(),
      price: json['price'].toString(),
      created_at: json['created_at'].toString(),
      updated_at: json['updated_at'].toString(),
    );
  }
}
