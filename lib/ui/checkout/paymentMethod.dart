import 'dart:core';

import 'package:flutter/material.dart';
import 'package:livetraxdigitl/main.dart';
import 'package:livetraxdigitl/payment/PaypalPayment.dart';
import 'package:livetraxdigitl/ui/checkout/ConfirmPurchaseScreen.dart';
import 'package:livetraxdigitl/ui/config/UserService.dart';
import 'package:livetraxdigitl/ui/config/constant.dart';
import 'package:livetraxdigitl/ui/server/addToPlaylist.dart';
import 'package:livetraxdigitl/ui/server/getvideoCallCode.dart';
import 'package:livetraxdigitl/ui/server/payOnWallet.dart';
import 'package:livetraxdigitl/ui/server/walletBalance.dart';
import 'package:livetraxdigitl/widgets/colorloader2.dart';
import 'package:livetraxdigitl/widgets/dialog_widget.dart';
import 'package:livetraxdigitl/widgets/internetConnection.dart';
import 'package:need_resume/need_resume.dart';

import 'checkoutAppBar.dart';

class PaymentMethod extends StatefulWidget {
  final String productId;
  final String price;
  final bool isTopup;
  final String category;
  final String audio;
  final String imageId;
  final String lyricsid;
  final String desc;
  final String Name;

  const PaymentMethod({
    Key key,
    this.productId,
    this.price,
    this.isTopup,
    this.category,
    this.audio,
    this.imageId,
    this.lyricsid,
    this.desc,
    this.Name,
  }) : super(key: key);

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends ResumableState<PaymentMethod> {
  //CheckoutService _checkoutService = new CheckoutService();
  UserService _userService = new UserService();
  List<PaymentOption> cardNumberList = new List<PaymentOption>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PaymentOption selectedPaymentCard;
  bool visibleInput = false;
  bool _wait = false;
  String availableBalance = "0.0";

  checkoutPaymentMethod() {
    if (selectedPaymentCard != null) {
      //Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
      // args['selectedCard'] = selectedPaymentCard;
      //Navigator.pushNamed(context, '/checkout/placeOrder', arguments: args);

      if (selectedPaymentCard.paymentName == "Wallet Balance") {
        print("======== account.token========" + account.token);
        if (double.parse(widget.price) <= double.parse(availableBalance)) {
          _waits(true);
          payOnWallet(account.token, widget.price, widget.productId, Artistid,
              _onSuccess, _error);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("You have No Money in Wallet !"),
          ));
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaypalPayment(
                //payAmount: _total,
                /*currency: code,
              userFirstName: "",
              userLastName: "",
              userEmail: "",
              payAmount: _total,
              secret: homeScreen.mainWindowData.payments.payPalSecret,
              clientId: homeScreen.mainWindowData.payments.payPalClientId,
              sandBoxMode: homeScreen.mainWindowData.payments.payPalSandBoxMode,*/
                onFinish: (w) {
              //_onSuccess("PayPal: $w");
              print("Paypal Payment Done Here >>");

              _showMyDialog();
            }),
          ),
        );
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: new Text('Select any card'),
          action: SnackBarAction(
            label: 'Close',
            textColor: Colors.white,
            onPressed: () {
              _scaffoldKey.currentState.removeCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  _onSuccess(String id) {
    _waits(false);
    setState(() {
      _waits(true);
      _showMyDialog();
      if (widget.category.isNotEmpty) if (widget.category == "1") {
        addToPlaylist(
            account.token,
            widget.desc,
            widget.Name,
            widget.imageId,
            widget.audio,
            Artistid,
            widget.lyricsid,
            _onSuccessAddPlayList,
            _error);
      } else if (widget.category == "3") {
        getvideoCallCode(account.token, widget.productId,
            _onSuccesspurchaseVideoCall, _error);
      }

      // print(history.length);
      // transactionhistory = history;
    });
  }

  _onSuccessAddPlayList() {
    _waits(false);
    setState(() {
      // print(history.length);
      // transactionhistory = history;
    });
  }

  _onSuccesspurchaseVideoCall(String message) {
    _waits(false);
    setState(() {});
  }

  Future<void> _showMyDialog() async {
    _waits(false);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Your transaction successfully completed.',
            style: TextStyle(fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Container(),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConfirmPurchaseScreen(
                            category: widget.category,
                          )),
                );
              },
            ),
          ],
        );
      },
    );
  }

  listPaymentMethod() async {
    bool connectionStatus = await _userService.checkInternetConnectivity();
    List<PaymentOption> cardNumber_List = new List<PaymentOption>();
    if (connectionStatus) {
      setState(() {
        if (!widget.isTopup) {
          PaymentOption _optionWallet = new PaymentOption("Wallet Balance",
              "assets/wallet.png", "Available Balance : $availableBalance\$");
          cardNumber_List.add(_optionWallet);
        }
        PaymentOption _option =
            new PaymentOption("Visa", "assets/visa.png", "");
        cardNumber_List.add(_option);
        PaymentOption _option1 =
            new PaymentOption("Amex", "assets/amex.png", "");
        cardNumber_List.add(_option1);
        PaymentOption _option2 =
            new PaymentOption("Mastercard", "assets/mastercard.png", "");
        cardNumber_List.add(_option2);

        cardNumberList = cardNumber_List;
      });
    } else {
      internetConnectionDialog(context);
    }
  }

  showSavedCreditCard() {
    return Container(
      child: Column(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cardNumberList.length,
            itemBuilder: (BuildContext context, int index) {
              PaymentOption item = cardNumberList[index];
              print("Image DATA > " +
                  item.paymentName.toString() +
                  " Size " +
                  cardNumberList.length.toString());
              return CheckboxListTile(
                secondary: Container(
                  child: Image(
                      image: AssetImage(item.sample_img),
                      fit: BoxFit.fill,
                      height: 40,
                      alignment: Alignment.topCenter),
                ),
                title: Text(item.paymentName),
                onChanged: (value) {
                  setState(() {
                    selectedPaymentCard = item;
                  });
                },
                subtitle: Text(item.totalwalletbalance),
                value: selectedPaymentCard == item,
              );
            },
          )
        ],
      ),
    );
  }

  setVisibileInput() {
    setState(() {
      visibleInput = !visibleInput;
    });
  }

  animatePaymentContainers() {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 1000),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(child: child, scale: animation);
        },
        child: cardNumberList.length != 0
            ? showSavedCreditCard()
            : Text('No card found'));
  }

  @override
  void initState() {
    super.initState();
    print("IIIDDD===");
    print(widget.price);
    print(widget.productId);
  }

  @override
  void onReady() {
    callAPI();
    if (!widget.isTopup) listPaymentMethod();
    super.onReady();
  }

  @override
  void onResume() {
    callAPI();
    super.onResume();
  }

  void callAPI() {
    _waits(true);
    walletBalance(account.token, _onSuccessGetbalance, _error);
  }

  _waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
  }

  _onSuccessGetbalance(String balance) {
    _waits(false);
    setState(() {
      availableBalance = balance;
      print(balance);
      listPaymentMethod();
    });
  }

  _error(String error) {
    _waits(false);
    print("Get message here " + error);
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.8),
        builder: (_) => DialogWidget(
              title: "" + error,
              button1: 'Ok',
              onButton1Clicked: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ));
  }

  var windowWidth;
  var windowHeight;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: CheckoutAppBar('Cancel', 'Next', this.checkoutPaymentMethod, ""),
      body: Stack(
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Payment Options',
                    style: TextStyle(
                        fontFamily: 'NovaSquare',
                        fontSize: 20.0,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.bold),
                  ),
                  /*Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
                  child: Center(
                    child: Icon(
                      Icons.credit_card,
                      size: 200.0,
                    )
                  ),
                ),*/
                  animatePaymentContainers(),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/checkout/addCreditCard');
                    },
                    child: ListTile(
                      leading: Icon(Icons.add),
                      title: Text('Add new Card'),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (_wait)
            (Container(
              width: windowWidth,
              height: windowHeight,
              child: Center(
                child: ColorLoader2(
                  color1: theme.colorPrimary,
                  color2: theme.colorCompanion,
                  color3: theme.colorPrimary,
                ),
              ),
            ))
          else
            (Container()),
        ],
      ),
    );
  }
}

class PaymentOption {
  String paymentName;
  String sample_img;
  String totalwalletbalance;

  PaymentOption(String paymentName, String sample, String totalwalletbalance) {
    this.paymentName = paymentName;
    this.sample_img = sample;
    this.totalwalletbalance = totalwalletbalance;
  }
}
