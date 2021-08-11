import 'dart:core';

import 'package:flutter/material.dart';
import 'package:tomo_app/payment/PaypalPayment.dart';
import 'package:tomo_app/ui/config/UserService.dart';
import 'package:tomo_app/widgets/internetConnection.dart';

import 'checkoutAppBar.dart';

class PaymentMethod extends StatefulWidget {
  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  //CheckoutService _checkoutService = new CheckoutService();
  UserService _userService = new UserService();
  List<PaymentOption> cardNumberList = new List<PaymentOption>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PaymentOption selectedPaymentCard;
  bool visibleInput = false;

  checkoutPaymentMethod() {
    if (selectedPaymentCard != null) {
      //Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
      // args['selectedCard'] = selectedPaymentCard;
      //Navigator.pushNamed(context, '/checkout/placeOrder', arguments: args);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaypalPayment(
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
              }),
        ),
      );
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

  listPaymentMethod() async {
    bool connectionStatus = await _userService.checkInternetConnectivity();
    List<PaymentOption> cardNumber_List = new List<PaymentOption>();
    if (connectionStatus) {
      setState(() {
        PaymentOption _option = new PaymentOption("Visa", "assets/visa.png");
        cardNumber_List.add(_option);
        PaymentOption _option1 = new PaymentOption("Amex", "assets/amex.png");
        cardNumber_List.add(_option1);
        PaymentOption _option2 =
            new PaymentOption("Mastercard", "assets/mastercard.png");
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
    listPaymentMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CheckoutAppBar('Cancel', 'Next', this.checkoutPaymentMethod,""),
      body: Container(
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
    );
  }
}

class PaymentOption {
  String paymentName;
  String sample_img;

  PaymentOption(String paymentName, String sample) {
    this.paymentName = paymentName;
    this.sample_img = sample;
  }
}
