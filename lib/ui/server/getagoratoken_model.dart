import 'package:tomo_app/ui/model/utils.dart';

class GetAgoraTokenData {
  int status;
  String message;
  String token;


  GetAgoraTokenData({this.status, this.message, this.token});

  factory GetAgoraTokenData.fromJson(Map<String, dynamic> json) {

    return GetAgoraTokenData(
      status: toInt(json['status'].toString()),
      message: json['message'].toString(),
      token: json['token'].toString(),
    );
  }
}


