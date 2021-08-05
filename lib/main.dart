import 'package:flutter/material.dart';
import 'package:tomo_app/ui/call/messaging.dart';
import 'package:tomo_app/ui/checkout/addCreditCard.dart';
import 'package:tomo_app/ui/checkout/paymentMethod.dart';
import 'package:tomo_app/ui/checkout/shippingAddress.dart';
import 'package:tomo_app/ui/config/lang.dart';
import 'package:tomo_app/ui/config/theme.dart';
import 'package:tomo_app/ui/home/home.dart';
import 'package:tomo_app/ui/login/UserSelection.dart';
import 'package:tomo_app/ui/login/forgot.dart';
import 'package:tomo_app/ui/login/login.dart';
import 'package:tomo_app/ui/merchandise/home.dart';
import 'package:tomo_app/ui/model/account.dart';
import 'package:tomo_app/ui/model/pref.dart';
import 'package:tomo_app/ui/profile/account.dart';
import 'package:tomo_app/ui/signup/signup.dart';
import 'package:tomo_app/ui/start/splash.dart';
import 'package:tomo_app/widgets/route.dart';


void main() {
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


      },
    );
  }




}

