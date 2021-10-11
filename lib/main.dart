import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:livetraxdigitl/demotest.dart';
import 'package:livetraxdigitl/ui/call/messaging.dart';
import 'package:livetraxdigitl/ui/checkout/addCreditCard.dart';
import 'package:livetraxdigitl/ui/checkout/paymentMethod.dart';
import 'package:livetraxdigitl/ui/checkout/shippingAddress.dart';
import 'package:livetraxdigitl/ui/config/lang.dart';
import 'package:livetraxdigitl/ui/config/theme.dart';
import 'package:livetraxdigitl/ui/home/home.dart';
import 'package:livetraxdigitl/ui/login/UserSelection.dart';
import 'package:livetraxdigitl/ui/login/forgot.dart';
import 'package:livetraxdigitl/ui/login/login.dart';
import 'package:livetraxdigitl/ui/merchandise/home.dart';
import 'package:livetraxdigitl/ui/model/account.dart';
import 'package:livetraxdigitl/ui/model/pref.dart';
import 'package:livetraxdigitl/ui/products/AddProductScreen.dart';
import 'package:livetraxdigitl/ui/profile/account.dart';
import 'package:livetraxdigitl/ui/signup/signup.dart';
import 'package:livetraxdigitl/ui/start/splash.dart';
import 'package:livetraxdigitl/widgets/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  pref.init().then((instance) {
    theme.init();
    // language
    var id = pref.get(Pref.language);
    var lid = Lang.english;
    if (id.isNotEmpty) lid = int.parse(id);
    strings.setLang(lid); // set default language - English
    runApp(LiveStreamApp());
  });
}

//
// Language data
//
Lang strings = Lang();

Account account = Account();
Pref pref = Pref();
AppThemeData theme = AppThemeData();
AppFoodRoute route = AppFoodRoute();

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

class LiveStreamApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _theme = ThemeData(
      fontFamily: 'Raleway',
      primarySwatch: theme.primarySwatch,
    );

    if (theme.darkMode) {
      _theme = ThemeData(
        fontFamily: 'Raleway',
        brightness: Brightness.dark,
        unselectedWidgetColor: Colors.white,
        primarySwatch: theme.primarySwatch,
      );
    }
    return MaterialApp(
      title: strings.get(10),
      // "Food Delivery Flutter App UI Kit",
      debugShowCheckedModeBanner: false,
      theme: _theme,
      // home:  DemoApp(),
      initialRoute: '/splash',
      routes: {
        '/splash': (BuildContext context) => SplashScreen(),
        '/login': (BuildContext context) => Login(),
        '/signup': (BuildContext context) => CreateAccountScreen(),
        '/forgot': (BuildContext context) => ForgotScreen(),
        '/message': (BuildContext context) => RealTimeMessaging(),
        '/home': (BuildContext context) => Home(),
        '/userselection': (BuildContext context) => UserSelection(),
        '/account': (BuildContext context) => AccountScreen(),
        '/homescreen': (BuildContext context) => HomeScreen(),
        '/address': (BuildContext context) => ShippingAddress(),
        '/checkout/payment': (BuildContext context) => PaymentMethod(),
        '/checkout/addCreditCard': (context) => AddCreditCard(),
        '/addproducts': (context) => AddProductScreen(),
        //0'/addproducts': (context) => ListProductScreen(),
      },
    );
  }
}
