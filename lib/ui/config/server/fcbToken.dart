import 'package:http/http.dart' as http;

import '../api.dart';

addNotificationToken(String uid, String fcbToken) async {
  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization': "Bearer $uid",
    };

    String body = '{"fcbToken": "$fcbToken"}';

    print('body: $body');
    var url = "${serverPath}fcbToken";

    var response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: body)
        .timeout(const Duration(seconds: 30));

    print("fcbToken");
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  } catch (_) {}

}
