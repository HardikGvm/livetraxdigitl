

import 'package:livetraxdigitl/ui/server/login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLogin {

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  login(Function(String type, String id, String name, String photo, String email) callback, Function(String) callbackError) async{
    try {
      print("Google Login Start...");
      await _googleSignIn.signIn();
      if (_googleSignIn.currentUser == null){
        callbackError("login_canceled");
        return;
      }
      print("${_googleSignIn.currentUser.email}");
      print("${_googleSignIn.currentUser.displayName}");
      print("${_googleSignIn.currentUser.photoUrl}");

      callback("google", _googleSignIn.currentUser.id, _googleSignIn.currentUser.displayName, _googleSignIn.currentUser.photoUrl,_googleSignIn.currentUser.email);
    } catch (error) {
      print(error);
      callbackError("$error");
    }
  }


}