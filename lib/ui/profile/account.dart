import 'package:flutter/material.dart';
import 'package:tomo_app/widgets/iAvatarWithPhotoFileCaching.dart';
import 'package:tomo_app/widgets/ibutton3.dart';
import 'package:tomo_app/widgets/ibutton5.dart';
import 'package:tomo_app/widgets/ilist4.dart';

import '../../main.dart';

class AccountScreen extends StatefulWidget {
  final Function(String) onDialogOpen;
  AccountScreen({Key key, this.onDialogOpen}) : super(key: key);
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  ///////////////////////////////////////////////////////////////////////////////
  //

  _makePhoto(){
    print("Make photo");
    widget.onDialogOpen("makePhoto");
  }

  _onChangePassword(){
    widget.onDialogOpen("changePassword");
  }

  _pressEditProfileButton(){
    print("User pressed Edit profile");
    widget.onDialogOpen("EditProfile");
  }

  _pressLogOutButton(){
    print("User pressed Log Out");
    account.logOut();
  }

  _pressLoginButton(){
    print("User pressed \"LOGIN\" button");
    route.push(context, "/login");
  }

  _pressDontHaveAccountButton(){
    print("User press \"Don't have account\" button");
    route.push(context, "/createaccount");
  }
  //
  //
  ///////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;

  @override
  void initState() {
    account.addCallback(this.hashCode.toString(), callback);
    super.initState();
  }

  callback(bool reg){
    setState(() {
    });
  }

  @override
  void dispose() {
    account.removeCallback(this.hashCode.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery
        .of(context)
        .size
        .width;
    windowHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Directionality(
        textDirection: strings.direction,
        child: Stack(
        children: <Widget>[

         // if (account.isAuth())(
          Container(
            margin: EdgeInsets.only(top: MediaQuery
                .of(context)
                .padding
                .top + 40),
            child: Container(
                child: ListView(
                  padding: EdgeInsets.only(top: 0),
                  shrinkWrap: true,
                  children: _getList(),
                )
            ),
          ),
            /*)else(
              _mustAuth()
          ),*/

        ],

    ));
  }

  _getList() {
    var list = List<Widget>();

    list.add(
        Stack(
          children: [
            IAvatarWithPhotoFileCaching(
              avatar: account.userAvatar,
              color: theme.colorPrimary,
              colorBorder: theme.colorGrey,
              callback: _makePhoto,
            ),
            _logoutWidget(),
          ],
        ));
    list.add(SizedBox(height: 10,));

    list.add(Container(
      color: theme.colorBackgroundGray,
      child: _userInfo(),
    ));

    list.add(SizedBox(height: 30,));

    list.add(Container(
        margin: EdgeInsets.only(left: 30, right: 30),
        child: _logout()
    ));

    list.add(SizedBox(height: 15,));

    if (account.typeReg == "email")
      list.add(Container(
          margin: EdgeInsets.only(left: 30, right: 30),
          child: _changePassword()
      ));

    list.add(SizedBox(height: 100,));

    return list;
  }

  _logout(){
    return Container(
      alignment: Alignment.center,
      child: IButton3(
          color: theme.colorPrimary,
          text: strings.get(146),                           // Edit Profile
          textStyle: theme.text14boldWhite,
          pressButton: _pressEditProfileButton
      ),
    );
  }

  _changePassword(){
    return Container(
      alignment: Alignment.center,
      child: IButton3(
          color: theme.colorPrimary,
          text: strings.get(145),                           // Change password
          textStyle: theme.text14boldWhite,
          pressButton: _onChangePassword
      ),
    );
  }


  _userInfo(){
    return Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[

            IList4(text: "${strings.get(57)}:", // "Username",
              textStyle: theme.text14bold,
              text2: account.userName,
              textStyle2: theme.text14bold,
            ),
            SizedBox(height: 10,),
            if (account.typeReg == "email")
              IList4(text: "${strings.get(58)}:", // "E-mail",
                textStyle: theme.text14bold,
                text2: account.email,
                textStyle2: theme.text14bold,
              ),
            if (account.typeReg == "google")
              Row(children: [
                Expanded(child: Text(strings.get(273), style: theme.text14bold,)), // "Log In with Google",
                Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 100,
                    child: IButton5(
                        color: Color(0xffd9534f), text: "", textStyle: theme.text14boldWhite,
                        icon: "assets/google.png",),
                )
              ],),
            if (account.typeReg == "facebook")
              Row(children: [
                Expanded(child: Text(strings.get(274), style: theme.text14bold,)), // "Log In with Facebook",
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 100,
                  child: IButton5(
                    color: Color(0xff428bca), text: "", textStyle: theme.text14boldWhite,
                    icon: "assets/facebook.png",),
                )
              ],),
            SizedBox(height: 10,),
            IList4(text: "${strings.get(59)}:", // "Phone",
              textStyle: theme.text14bold,
              text2: account.phone,
              textStyle2: theme.text14bold,
            ),
            SizedBox(height: 10,),

          ],
        )

    );
  }

  _mustAuth(){
    return Center(
      child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              UnconstrainedBox(
                  child: Container(
                      width: windowWidth/3,
                      child: Image.asset("assets/auth.png",
                        fit: BoxFit.contain, color: Colors.black.withAlpha(80),
                      )
                  )
              ),
              SizedBox(height: 30,),
              Container(
                margin: EdgeInsets.only(left: windowWidth*0.15, right: windowWidth*0.15),
                child: Text(strings.get(125), textAlign: TextAlign.center,), // "You must sign-in to access to this section",
              ),
              SizedBox(height: 40,),
              Container(
                margin: EdgeInsets.only(left: windowWidth*0.1, right: windowWidth*0.1),
                child: IButton3(pressButton: _pressLoginButton, text: strings.get(22), // LOGIN
                  color: theme.colorPrimary,
                  textStyle: theme.text16boldWhite,),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
                child: InkWell(
                    onTap: () {
                      _pressDontHaveAccountButton();
                    }, // needed
                    child:Text(strings.get(19),                    // ""Don't have an account? Create",",
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: theme.text14primary
                    )),
              )
            ],
          )
      ),
    );
  }

  _logoutWidget(){
    return Container(
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(top: 10, right: 10),
      child: Stack(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorBackgroundDialog,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: Offset(1, 1), // changes position of shadow
                ),
              ],
            ),
            child: Icon(Icons.exit_to_app, color: theme.colorDefaultText..withOpacity(0.1), size: 30),
          ),
          Positioned.fill(
            child: Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.grey[400],
                  onTap: (){
                    _pressLogOutButton();
                  }, // needed
                )),
          )
        ],
      ),);
  }

}