import 'package:flutter/widgets.dart';
import 'package:livetraxdigitl/ui/config/api.dart';
import 'package:livetraxdigitl/ui/config/server/fcbToken.dart';
import 'package:livetraxdigitl/ui/model/pref.dart';

import '../../main.dart';

class Account {
  String _fcbToken;
  String userName = "";
  String userId = "";
  String email = "";
  String phone = "";
  String description="";
  String userAvatar = "";
  String token = "";
  String role = "";
  String typeReg = "";
  String referral_code = "";


  int notifyCount = 0;
  String currentOrder = "";
  String openOrderOnMap = "";
  String backRoute = "";
  String backRouteMap = "";

  bool _initUser = true;

  okUserEnter(
      String name,
      String password,
      String _description,
      String avatar,
      String _email,
      String _token,
      String _phone,
      int unreadNotify,
      String _userId,
      String _typeReg,
      String _role,
      String _referral_code) {
    _initUser = true;
    userName = name;
    userAvatar = avatar;
    if (userAvatar == null) userAvatar = serverImgNoUserPath;
    if (userAvatar.isEmpty) userAvatar = serverImgNoUserPath;
    email = _email;
    if (_phone != null) phone = _phone;
    if (_description != null) description = _description;
    if (_role != null) role = _role;
    if (_typeReg != null) typeReg = _typeReg;
    if (_referral_code != null) referral_code = _referral_code;

    token = _token;
    userId = _userId;
    notifyCount = unreadNotify;

    pref.set(Pref.userId, userId);
    pref.set(Pref.userEmail, _email);
    pref.set(Pref.userPassword, password);
    pref.set(Pref.userDescription, description);
    pref.set(Pref.userAvatar, avatar);
    pref.set(Pref.userRole, role);
    pref.set(Pref.typeReg, typeReg);
    pref.set(Pref.userName, userName);
    pref.set(Pref.token, token);
    pref.set(Pref.phone, phone);
    pref.set(Pref.referral_code, referral_code);


    print("User TESTTTTTT email=$email ,pass=$password ,avatar=$avatar ,userName=$userName ,Code=$referral_code,description=$description ");
    _callAll(true);
    if (_fcbToken != null) addNotificationToken(account.token, _fcbToken);
    chatGetUnread();
  }

  _callAll(bool value) {
    for (var callback in callbacks.values) {
      try {
        print("Check callback HERE ---> " + value.toString());
        callback(value);
      } catch (ex) {}
    }

  }

  _callAllWithRedirect(bool value,Function() pushRedirection) {
    for (var callback in callbacks.values) {
      try {
        print("Check callback HERE ---> " + value.toString());
        callback(value);
      } catch (ex) {}
    }
    pushRedirection();
  }

  var callbacks = Map<String, Function(bool)>();

  addCallback(String name, Function(bool) callback) {
    callbacks.addAll({name: callback});
  }

  removeCallback(String name) {
    callbacks.remove(name);
  }

  redraw() {
    _callAll(_initUser);
  }

  logOut(Function() pushRedirection) {
    _initUser = false;
    pref.clearUser();
    userName = "";
    userAvatar = "";
    email = "";
    token = "";
    _callAllWithRedirect(false,pushRedirection);
  }

  isAuth(Function(bool) callback) {

    var emails = pref.get(Pref.userEmail);
    var pass = pref.get(Pref.userPassword);



    print("Check Step 3 > " + emails.toString() + " " + pass.toString());
    if (emails.isNotEmpty && pass.isNotEmpty) {
      /*login(email, pass, (String name, String password, String avatar, String email, String token, String phone, int unreadNotify, String userId){
        callback(true);
        okUserEnter(name, password, avatar, email, token, phone, unreadNotify, userId);
      }, (String err) {
        callback(false);
      });*/

      email = pref.get(Pref.userEmail);
      userName = pref.get(Pref.userName);
      userId = pref.get(Pref.userId);
      phone = pref.get(Pref.phone);
      description = pref.get(Pref.userDescription);
      userAvatar = pref.get(Pref.userAvatar);
      token = pref.get(Pref.token);
      role = pref.get(Pref.userRole);
      typeReg = pref.get(Pref.typeReg);

      callback(true);
    } else
      callback(false);
  }

  //
  // Orders screen
  //
  Function() callbackOrdersReload;

  addOrdersCallback(Function() callback) {
    callbackOrdersReload = callback;
  }

  //
  // notifications
  //

  getFavoritesState(String id){
    return false;
  }

  revertFavoriteState(String id){
    return false;
  }



  setFcbToken(String token) {
    _fcbToken = token;
    if (_initUser) addNotificationToken(account.token, _fcbToken);
  }

  addNotify() {
    notifyCount++;
    _callAll(_initUser);
    if (callbackNotifyReload != null) callbackNotifyReload();
    if (callbackOrdersReload != null) callbackOrdersReload();
  }

  notifyRefresh() {
    _callAll(_initUser);
    if (callbackNotifyReload != null) callbackNotifyReload();
    if (callbackOrdersReload != null) callbackOrdersReload();
  }

  Function() callbackNotifyReload;

  addNotifyCallback(Function() callback) {
    callbackNotifyReload = callback;
  }

  //
  // chat
  //

  int chatCount = 0;
  Function() callbackChatReload;

  addChatCallback(Function() callback) {
    callbackChatReload = callback;
  }

  addChat() {
    chatGetUnread();
    _callAll(_initUser);
    if (callbackChatReload != null) callbackChatReload();
  }

  chatRefresh() {
    if (callbackChatReload != null) callbackChatReload();
  }

  chatGetUnread() {
    /*chatUnread(token, (int count){
      chatCount = count;
      _callAll(true);
      }, (String _){});*/
  }

  setUserAvatar(String _avatar) {
    userAvatar = _avatar;
    _callAll(true);
  }
}
