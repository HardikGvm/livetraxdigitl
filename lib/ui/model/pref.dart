import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  SharedPreferences _prefs;

  static String userId = "userid";
  static String userName = "userName";
  static String userEmail = "userEmail";
  static String userPassword = "userPassword";
  static String userAvatar = "userAvatar";
  static String userRole = "userRole";
  static String typeReg = "typeReg";
  static String token = "token";
  static String phone = "phone";
  static String referral_code = "referral_code";
  static String isChanges = "isChanges";

  static String uiMainColor = "uiMainColor";
  static String uiDarkMode = "uiDarkMode";

  static String language = "language";
  static String userSelectLanguage = "userSelectLanguage";
  static String bottomBarType = "bottomBarType";



  init() async {
    print("DATA SET HERE ----------------------------->>> CALL 11 " +
        (_prefs == null).toString());
    await _init2();
  }

  _init2() async {
    print("DATA SET HERE ----------------------------->>> SET GET " +
        (_prefs == null).toString());
    _prefs = await SharedPreferences.getInstance();
  }

  set(String key, String value) async {
    print("DATA SET HERE ----------------------------->>> SET Prefs " +
        (_prefs == null).toString());
    if (_prefs == null) await _init2();
    _prefs.setString(key, value);
    print("DATA SET HERE ----------------------------->>> SET " +
        key +
        " VA VAL " +
        value);
  }

  setBool(String key, bool value) async {
    print("DATA SET HERE ----------------------------->>> SET Prefs " +
        (_prefs == null).toString());
    if (_prefs == null) await _init2();
    _prefs.setBool(key, value);
    print("DATA SET HERE ----------------------------->>> SET " +
        key +
        " VA VAL " +
        value.toString());
  }

  bool getBool(String key) {
    bool isData = false;
    try {
      isData = _prefs.getBool(key);
    } catch (ex) {}
    return isData;
  }

  String get(String key) {
    String text = "";
    try {
      text = _prefs.getString(key);
      if (text == null) text = "";
    } catch (ex) {}
    return text;
  }



  clearUser() {
    print("DATA SET HERE ----------------------------->>> CLEAR ");
    set(Pref.userEmail, "");
    set(Pref.userPassword, "");
    set(Pref.userAvatar, "");
    set(Pref.userRole, "");
    set(Pref.userName, "");
    set(Pref.token, "");
    set(Pref.phone, "");
    set(Pref.userId, "");
    set(Pref.referral_code, "");
    set(Pref.typeReg, "");
  }
}
