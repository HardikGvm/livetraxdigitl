
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:livetraxdigitl/main.dart';


final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

firebaseGetToken() async {
  print ("Firebase messaging: _getToken");

  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("Firebase messaging:onMessage: $message");
      var _message = message["data"]["chat"];
      if (_message == 'true'){
        account.addChat();
        return;
      }
      account.addNotify();
    },
    onLaunch: (Map<String, dynamic> message) async {
      print("Firebase messaging:onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
      print("Firebase messaging:onResume: $message");
      account.chatRefresh();
      account.notifyRefresh();
    },
    //onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
  );

  firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false));

  firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    print("Firebase messaging: Settings registered: $settings");

  });

  firebaseMessaging.getToken().then((String token) {
    assert(token != null);
    print ("Firebase messaging: token=$token");
    account.setFcbToken(token);
  });
}