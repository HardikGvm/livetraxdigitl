import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tomo_app/ui/merchandise/homescreenModel.dart';
import 'package:tomo_app/ui/model/pref.dart';
import 'package:tomo_app/ui/server/changePassword.dart';
import 'package:tomo_app/ui/server/changeProfile.dart';
import 'package:tomo_app/ui/server/uploadavatar.dart';
import 'package:tomo_app/ui/wallet/WalletScreen.dart';
import 'package:tomo_app/widgets/colorloader2.dart';
import 'package:tomo_app/widgets/easyDialog2.dart';
import 'package:tomo_app/widgets/iAvatarWithPhotoFileCaching.dart';
import 'package:tomo_app/widgets/iappBar.dart';
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
  _makePhoto() {
    print("Make photo");
    _openDialogs("makePhoto");
  }

  _onChangePassword() {
    _openDialogs("changePassword");
  }

  _onRedirectScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WalletListScreen()),
    );
  }



  _pressEditProfileButton() {
    print("User pressed Edit profile");
    _openDialogs("EditProfile");
  }

  _pressLogOutButton() {
    print("User pressed Log Out");
    account.logOut(PushRedirection);
  }

  PushRedirection() {
    Navigator.pushNamedAndRemoveUntil(context, "/splash", (r) => false);
  }

  _pressLoginButton() {
    print("User pressed \"LOGIN\" button");
    route.push(context, "/login");
  }

  _pressDontHaveAccountButton() {
    print("User press \"Don't have account\" button");
    route.push(context, "/createaccount");
  }

  var windowWidth;
  var windowHeight;
  bool _wait = false;

  double mainDialogShow = 0;
  Widget mainDialogBody = Container();

  @override
  void initState() {
    account.addCallback(this.hashCode.toString(), callback);
    super.initState();
  }

  callback(bool reg) {
    setState(() {});
  }

  @override
  void dispose() {
    account.removeCallback(this.hashCode.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: <Widget>[
        Directionality(
            textDirection: strings.direction,
            child: Stack(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  margin:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Container(
                      child: ListView(
                    padding: EdgeInsets.only(top: 10),
                    shrinkWrap: true,
                    children: _getList(),
                  )),
                ),
              ],
            )),
        IAppBar(context: context, text: "", color: Colors.black),
        if (_wait)
          Container(
              color: Color(0x80000000),
              width: windowWidth,
              height: windowHeight,
              child: Center(
                child: ColorLoader2(
                  color1: theme.colorPrimary,
                  color2: theme.colorCompanion,
                  color3: theme.colorPrimary,
                ),
              )),
        IEasyDialog2(
            setPosition: (double value) {
              mainDialogShow = value;
            },
            getPosition: () {
              return mainDialogShow;
            },
            color: theme.colorGrey,
            body: mainDialogBody,
            backgroundColor: theme.colorBackground),
        IEasyDialog2(
          setPosition: (double value) {
            _show = value;
          },
          getPosition: () {
            return _show;
          },
          color: theme.colorGrey,
          body: _dialogBody,
          backgroundColor: theme.colorBackground,
        ),
      ]),
    );
  }

  _getList() {
    var list = List<Widget>();

    list.add(Stack(
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

    list.add(SizedBox(
      height: 10,
    ));

    list.add(Container(
      color: theme.colorBackgroundGray,
      child: _userInfo(),
    ));

    list.add(SizedBox(
      height: 30,
    ));

    list.add(Container(
        margin: EdgeInsets.only(left: 30, right: 30), child: _logout()));

    list.add(SizedBox(
      height: 15,
    ));

    if (account.typeReg == "email")
      list.add(Container(
          margin: EdgeInsets.only(left: 30, right: 30),
          child: _changePassword()));


    if (account.role == "artist") {
      list.add(SizedBox(
        height: 15,
      ));

      list.add(Container(
          margin: EdgeInsets.only(left: 30, right: 30),
          child: _ClickWallet()));
    }

    list.add(SizedBox(
      height: 100,
    ));

    return list;
  }

  _logout() {
    return Container(
      alignment: Alignment.center,
      child: IButton3(
          color: theme.colorPrimary,
          text: strings.get(64), // Edit Profile
          textStyle: theme.text14boldWhite,
          pressButton: _pressEditProfileButton),
    );
  }

  _changePassword() {
    return Container(
      alignment: Alignment.center,
      child: IButton3(
          color: theme.colorPrimary,
          text: strings.get(70), // Change password
          textStyle: theme.text14boldWhite,
          pressButton: _onChangePassword),
    );
  }

  _ClickWallet() {
    return Container(
      alignment: Alignment.center,
      child: IButton3(
          color: theme.colorPrimary,
          text: strings.get(2283), // Change password
          textStyle: theme.text14boldWhite,
          pressButton: _onRedirectScreen),
    );
  }

  _userInfo() {
    print("User Bane >> " + account.email);
    return Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            IList4(
              text: "${strings.get(2244)}:", // "Username",
              textStyle: theme.text14bold,
              text2: account.userName,
              textStyle2: theme.text14bold,
            ),
            SizedBox(
              height: 10,
            ),
            if (account.typeReg == "email")
              IList4(
                text: "${strings.get(33)}:", // "E-mail",
                textStyle: theme.text14bold,
                text2: account.email,
                textStyle2: theme.text14bold,
              ),
            if (account.typeReg == "google")
              Row(
                children: [
                  Expanded(
                      child: Text(
                    strings.get(273),
                    style: theme.text14bold,
                  )),
                  // "Log In with Google",
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 100,
                    child: IButton5(
                      color: Colors.grey,
                      text: "",
                      textStyle: theme.text14boldWhite,
                      icon: "assets/twitter.png",
                    ),
                  )
                ],
              ),
            if (account.typeReg == "facebook")
              Row(
                children: [
                  Expanded(
                      child: Text(
                    strings.get(274),
                    style: theme.text14bold,
                  )),
                  // "Log In with Facebook",
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 100,
                    child: IButton5(
                      color: Color(0xff428bca),
                      text: "",
                      textStyle: theme.text14boldWhite,
                      icon: "assets/facebook.png",
                    ),
                  )
                ],
              ),
            SizedBox(
              height: 10,
            ),
            IList4(
              text: "${strings.get(2245)}:", // "Phone",
              textStyle: theme.text14bold,
              text2: (account.phone.toString().trim() != "null")
                  ? account.phone
                  : "",
              textStyle2: theme.text14bold,
            ),
            SizedBox(
              height: 10,
            ),
            (account.role == "fan")
                ? IList4(
                    text: "${strings.get(2243)}:", // "Referral Code",
                    textStyle: theme.text14bold,
                    text2: account.referral_code,
                    textStyle2: theme.text14bold,
                  )
                : Container(),
          ],
        ));
  }

  _mustAuth() {
    return Center(
      child: Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UnconstrainedBox(
              child: Container(
                  width: windowWidth / 3,
                  child: Image.asset(
                    "assets/auth.png",
                    fit: BoxFit.contain,
                    color: Colors.black.withAlpha(80),
                  ))),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.only(
                left: windowWidth * 0.15, right: windowWidth * 0.15),
            child: Text(
              strings.get(125),
              textAlign: TextAlign.center,
            ), // "You must sign-in to access to this section",
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            margin: EdgeInsets.only(
                left: windowWidth * 0.1, right: windowWidth * 0.1),
            child: IButton3(
              pressButton: _pressLoginButton,
              text: strings.get(22),
              // LOGIN
              color: theme.colorPrimary,
              textStyle: theme.text16boldWhite,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
            child: InkWell(
                onTap: () {
                  _pressDontHaveAccountButton();
                }, // needed
                child:
                    Text(strings.get(19), // ""Don't have an account? Create",",
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: theme.text14primary)),
          )
        ],
      )),
    );
  }

  _logoutWidget() {
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
            child: Icon(Icons.exit_to_app,
                color: theme.colorDefaultText..withOpacity(0.1), size: 30),
          ),
          Positioned.fill(
            child: Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.grey[400],
                  onTap: () {
                    _pressLogOutButton();
                  }, // needed
                )),
          )
        ],
      ),
    );
  }

  final picker = ImagePicker();

  _openDialogs(String name) {
    if (name == "EditProfile") {
      print("Come HERE");
      _openEditProfileDialog();
    }
    if (name == "makePhoto") getImage();
    if (name == "changePassword") _pressChangePasswordButton();
  }

  final editControllerName = TextEditingController();
  final editControllerEmail = TextEditingController();
  final editControllerPhone = TextEditingController();
  final editControllerOldPassword = TextEditingController();
  final editControllerNewPassword1 = TextEditingController();
  final editControllerNewPassword2 = TextEditingController();
  Widget _dialogBody = Container();
  double _show = 0;

  _openEditProfileDialog() {
    editControllerName.text = account.userName;
    editControllerEmail.text = account.email;
    editControllerPhone.text = account.phone;

    _dialogBody = Directionality(
        textDirection: strings.direction,
        child: Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    strings.get(156),
                    textAlign: TextAlign.center,
                    style: theme.text18boldPrimary,
                  ) // "Edit profile",
                  ),
              // "Reason to Reject",
              SizedBox(
                height: 20,
              ),
              Text(
                "${strings.get(157)}:",
                style: theme.text12bold,
              ),
              // "User Name",
              _edit(editControllerName, strings.get(67), false, false),
              //  "Enter your User Name",
              SizedBox(
                height: 20,
              ),
              if (account.typeReg == "email")
                Text(
                  "${strings.get(159)}:",
                  style: theme.text12bold,
                ),
              // "E-mail",
              if (account.typeReg == "email")
                _edit(editControllerEmail, strings.get(160), false, false),
              //  "Enter your User E-mail",
              if (account.typeReg == "email")
                SizedBox(
                  height: 20,
                ),
              if (appSettings.otp != "true")
                Text(
                  "${strings.get(59)}:",
                  style: theme.text12bold,
                ),
              // Phone
              if (appSettings.otp != "true")
                _edit(editControllerPhone, strings.get(161), false, true),
              //  "Enter your User Phone",
              SizedBox(
                height: 30,
              ),
              Container(
                  width: windowWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: windowWidth / 2 - 45,
                          child: IButton3(
                              color: theme.colorPrimary,
                              text: strings.get(162), // Change
                              textStyle: theme.text14boldWhite,
                              pressButton: () {
                                setState(() {
                                  _show = 0;
                                });
                                _callbackSave();
                              })),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          width: windowWidth / 2 - 45,
                          child: IButton3(
                              color: theme.colorPrimary,
                              text: strings.get(155), // Cancel
                              textStyle: theme.text14boldWhite,
                              pressButton: () {
                                setState(() {
                                  _show = 0;
                                });
                              })),
                    ],
                  )),
            ],
          ),
        ));

    setState(() {
      _show = 1;
    });
  }

  _edit(TextEditingController _controller, String _hint, bool _obscure,
      bool isint) {
    return Container(
        height: 30,
        child: Directionality(
          textDirection: strings.direction,
          child: TextFormField(
            controller: _controller,
            onChanged: (String value) async {},
            cursorColor: theme.colorDefaultText,
            style: theme.text14,
            cursorWidth: 1,
            obscureText: _obscure,
            maxLines: 1,
            keyboardType: isint ? TextInputType.number : TextInputType.name,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: _hint,
                hintStyle: theme.text14),
          ),
        ));
  }

  _callbackSave() {
    print("User pressed Save profile");
    print(
        "User Name: ${editControllerName.text}, E-mail: ${editControllerEmail.text}, Phone: ${editControllerPhone.text}, Token: ${account.token}, UID: ${account.userId}");
    if (editControllerName.text.isEmpty) return openDialog(strings.get(158));
    if (editControllerEmail.text.isEmpty)
      return openDialog(strings.get(160)); // "Enter your Login"
    if (editControllerPhone.text.isEmpty) return openDialog(strings.get(161));

    changeProfile(
        account.token,
        editControllerName.text,
        editControllerEmail.text,
        editControllerPhone.text,
        _successChangeProfile,
        _errorChangeProfile);
  }

  openDialog(String _text) {
    waits(false);
    _dialogBody = Column(
      children: [
        Text(
          _text,
          style: theme.text14,
        ),
        SizedBox(
          height: 40,
        ),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(155), // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: () {
              setState(() {
                _show = 0;
              });
            }),
      ],
    );

    setState(() {
      _show = 1;
    });
  }

  _errorChangeProfile(String error) {
    _openDialogError("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  _successChangeProfile() {
    print("Check List Update HERE ---------->" + editControllerName.text);
    _openDialogError(strings.get(171)); // "User Profile change",
    account.userName = editControllerName.text;
    account.phone = editControllerPhone.text;
    account.email = editControllerEmail.text;
    setState(() {});
  }

  _openDialogError(String _text) {
    _dialogBody = Column(
      children: [
        Text(
          _text,
          style: theme.text14,
        ),
        SizedBox(
          height: 40,
        ),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(155), // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: () {
              setState(() {
                _show = 0;
              });
            }),
      ],
    );

    setState(() {
      _show = 1;
    });
  }

  getImage() {
    _dialogBody = Column(
      children: [
        InkWell(
            onTap: () {
              getImage2(ImageSource.gallery);
              setState(() {
                _show = 0;
              });
            }, // needed
            child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                margin: EdgeInsets.only(top: 10, bottom: 10),
                height: 40,
                color: theme.colorBackgroundGray,
                child: Center(
                  child: Text(strings.get(163)), // "Open Gallery",
                ))),
        InkWell(
            onTap: () {
              getImage2(ImageSource.camera);
              setState(() {
                _show = 0;
              });
            }, // needed
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              margin: EdgeInsets.only(bottom: 10),
              height: 40,
              color: theme.colorBackgroundGray,
              child: Center(
                child: Text(strings.get(164)), //  "Open Camera",
              ),
            )),
        SizedBox(
          height: 20,
        ),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(155), // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: () {
              setState(() {
                _show = 0;
              });
            }),
      ],
    );
    setState(() {
      _show = 1;
    });
  }

  waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
  }

  Future getImage2(ImageSource source) async {
    waits(true);
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null && pickedFile.path != null) {
      print("Photo file: ${pickedFile.path}");
      waits(true);
      uploadAvatar(pickedFile.path, account.token, (String avatar) {
        account.setUserAvatar(avatar);
        waits(false);
        setState(() {});
      }, (String error) {
        waits(false);
        _openDialogError(
            "${strings.get(128)} $error"); // "Something went wrong. ",
      });
    } else
      waits(false);
  }

  _pressChangePasswordButton() {
    _dialogBody = Directionality(
        textDirection: strings.direction,
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    strings.get(147),
                    textAlign: TextAlign.center,
                    style: theme.text18boldPrimary,
                  ) // "Change password",
                  ),
              // "Reason to Reject",
              SizedBox(
                height: 20,
              ),
              Text(
                "${strings.get(148)}:",
                style: theme.text12bold,
              ),
              // "Old password",
              _edit(editControllerOldPassword, strings.get(149), true, false),
              //  "Enter your old password",
              SizedBox(
                height: 20,
              ),
              Text(
                "${strings.get(150)}:",
                style: theme.text12bold,
              ),
              // "New password",
              _edit(editControllerNewPassword1, strings.get(152), true, false),
              //  "Enter your new password",
              SizedBox(
                height: 20,
              ),
              Text(
                "${strings.get(153)}:",
                style: theme.text12bold,
              ),
              // "Confirm New password",
              _edit(editControllerNewPassword2, strings.get(154), true, false),
              //  "Enter your new password",
              SizedBox(
                height: 30,
              ),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: windowWidth / 2 - 45,
                      child: IButton3(
                          color: theme.colorPrimary,
                          text: strings.get(162), // Change
                          textStyle: theme.text14boldWhite,
                          pressButton: () {
                            setState(() {
                              _show = 0;
                            });
                            _callbackChange();
                          })),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      width: windowWidth / 2 - 45,
                      child: IButton3(
                          color: theme.colorPrimary,
                          text: strings.get(155), // Cancel
                          textStyle: theme.text14boldWhite,
                          pressButton: () {
                            setState(() {
                              _show = 0;
                            });
                          })),
                ],
              )),
            ],
          ),
        ));

    setState(() {
      _show = 1;
    });
  }

  _callbackChange() {
    print("User pressed Change password");
    print(
        "Old password: ${editControllerOldPassword.text}, New password: ${editControllerNewPassword1.text}, "
        "New password 2: ${editControllerNewPassword2.text}");
    if (editControllerNewPassword1.text != editControllerNewPassword2.text)
      return _openDialogError(strings.get(167)); // "Passwords don't equals",
    if (editControllerNewPassword1.text.isEmpty ||
        editControllerNewPassword2.text.isEmpty)
      return _openDialogError(strings.get(170)); // "Enter New Password",

    if (!validateStructure(editControllerNewPassword2.text)) {
      return openDialog(strings.get(2255)); // "Enter Valid password"
    }
    changePassword(
        account.token,
        editControllerOldPassword.text,
        editControllerNewPassword1.text,
        _successChangePassword,
        _errorChangePassword);
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    print("Match Password herr > " + regExp.hasMatch(value).toString());
    return regExp.hasMatch(value);
  }

  _successChangePassword() {
    _openDialogError(strings.get(166)); // "Password change",
    pref.set(Pref.userPassword, editControllerNewPassword1.text);
  }

  _errorChangePassword(String error) {
    if (error == "1")
      return _openDialogError(strings.get(168)); // Old password is incorrect
    if (error == "2")
      return _openDialogError(
          strings.get(169)); // The password length must be more than 5 chars
    _openDialogError("${strings.get(128)} $error"); // "Something went wrong. ",
  }
}
