import 'package:flutter/material.dart';
import 'package:livetraxdigitl/ui/server/walletBalance.dart';
import 'package:livetraxdigitl/ui/server/walletHistory.dart';
import 'package:livetraxdigitl/ui/wallet/balance_card.dart';
import 'package:livetraxdigitl/widgets/colorloader2.dart';
import 'package:livetraxdigitl/widgets/ibutton3.dart';
import 'package:need_resume/need_resume.dart';

import '../../main.dart';

class WalletListScreen extends StatefulWidget {
  const WalletListScreen({key}) : super(key: key);

  @override
  _WalletListScreenState createState() => _WalletListScreenState();
}

class _WalletListScreenState extends ResumableState<WalletListScreen> {
  bool _wait = false;
  var windowWidth;
  var windowHeight;
  bool isChanges = false;

  bool isArtist = true;
  List<History> transactionhistory = [];
  String availableBalance = "0.0";

  @override
  void onReady() {
    callAPI();
    super.onReady();
  }

  @override
  void onResume() {
    print("::: On Resume ::: ");
    callAPI();
    super.onResume();
  }

  @override
  void onPause() {
    super.onPause();
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    //isArtist = (account.role == "artist");
    print("Check List > " + isArtist.toString());
    print(transactionhistory.length);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('WALLET'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: BalanceCard(
                      balance: availableBalance,
                    ),
                  ),
                  Text("Transactions History"),
                  SizedBox(
                    height: 20,
                  ),
                  new ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: transactionhistory.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 5,
                        child: const DecoratedBox(
                          decoration: const BoxDecoration(color: Colors.black),
                        ),
                      );
                    },
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Container(
                        //height: 180,
                        color: Color.fromARGB(247, 247, 247, 255),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            children: [
                              new Flexible(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                    child: Icon(
                                      (transactionhistory[index].arrival == 0)
                                          ? Icons.arrow_circle_down
                                          : Icons.arrow_circle_up,
                                      color:
                                          (transactionhistory[index].arrival ==
                                                  0)
                                              ? Colors.redAccent
                                              : Colors.green,
                                    ),
                                    width: 60.0,
                                    height: 60.0,
                                  ),
                                ),
                                flex: 1,
                              ),
                              new Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              (transactionhistory[index]
                                                          .arrival ==
                                                      0)
                                                  ? transactionhistory[index]
                                                      .productname
                                                      .toString()
                                                  : transactionhistory[index]
                                                                  .touser ==
                                                              0 &&
                                                          transactionhistory[
                                                                      index]
                                                                  .productid ==
                                                              0
                                                      ? "You Add Money"
                                                      : transactionhistory[
                                                              index]
                                                          .username
                                                          .toString(),
                                              style: theme.text16boldPimary,
                                            ),
                                          ),
                                          Visibility(
                                            child: Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Text(
                                                (transactionhistory[index]
                                                            .arrival ==
                                                        0)
                                                    ? "-" +
                                                        transactionhistory[
                                                                index]
                                                            .amount +
                                                        "\$"
                                                    : "+" +
                                                        transactionhistory[
                                                                index]
                                                            .amount +
                                                        "\$",
                                                style:
                                                    (transactionhistory[index]
                                                                .arrival ==
                                                            0)
                                                        ? theme.text16boldRed
                                                        : theme.text16boldGreen,
                                              ),
                                            ),
                                            visible: isArtist,
                                          )
                                        ],
                                      ),
                                      Text(
                                        transactionhistory[index].updatedAt,
                                        style: theme.text12grey,
                                      ),
                                    ],
                                  ),
                                ),
                                flex: 2,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // new ListView.separated(
                  //   shrinkWrap: true,
                  //   scrollDirection: Axis.vertical,
                  //   itemCount: transactionhistory.length,
                  //   separatorBuilder: (BuildContext context, int index) {
                  //     return SizedBox(
                  //       height: 5,
                  //       child: const DecoratedBox(
                  //         decoration: const BoxDecoration(color: Colors.black),
                  //       ),
                  //     );
                  //   },
                  //   itemBuilder: (BuildContext ctxt, int index) {
                  //     return Container(
                  //       //height: 180,
                  //       color: Color.fromARGB(247, 247, 247, 255),
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(5),
                  //         child: Row(
                  //           children: [
                  //             new Flexible(
                  //               child: ClipRRect(
                  //                 borderRadius: BorderRadius.circular(8.0),
                  //                 child: Container(
                  //                   child: Icon(
                  //                     (transactionhistory[index].comment == "Payed")
                  //                         ? Icons.arrow_circle_down
                  //                         : Icons.arrow_circle_up,
                  //                     color: (transactionhistory[index].comment ==
                  //                             "Payed")
                  //                         ? Colors.redAccent
                  //                         : Colors.green,
                  //                   ),
                  //                   width: 60.0,
                  //                   height: 60.0,
                  //                 ),
                  //               ),
                  //               flex: 1,
                  //             ),
                  //             new Flexible(
                  //               child: Padding(
                  //                 padding: const EdgeInsets.only(left: 8.0),
                  //                 child: Column(
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.spaceEvenly,
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: [
                  //                     Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                       children: <Widget>[
                  //                         Expanded(
                  //                           child: Text(
                  //                             transactionhistory[index]
                  //                                 .user
                  //                                 .toString(),
                  //                             style: theme.text16boldPimary,
                  //                           ),
                  //                         ),
                  //                         Visibility(
                  //                           child: Padding(
                  //                             padding: const EdgeInsets.all(0),
                  //                             child: Text(
                  //                               transactionhistory[index].amount,
                  //                               style: (transactionhistory[index]
                  //                                       .amount
                  //                                       .toString()
                  //                                       .contains("-"))
                  //                                   ? theme.text16boldRed
                  //                                   : theme.text16boldGreen,
                  //                             ),
                  //                           ),
                  //                           visible: isArtist,
                  //                         )
                  //                       ],
                  //                     ),
                  //                     Text(
                  //                       transactionhistory[index].updatedAt,
                  //                       style: theme.text12grey,
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               flex: 2,
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
            // child: SingleChildScrollView(
            //   physics: ScrollPhysics(),
            //   child: new
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

  _waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
  }

  double _show = 0;
  Widget _dialogBody = Container();

  openDialog(String _text) {
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
            text: strings.get(66), // Cancel
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

  _error(String error) {
    _waits(false);
    print("Get message here " + error);
    openDialog("$error"); // "Something went wrong. ",
  }

  _onSuccess(List<History> history) {
    _waits(false);
    setState(() {
      print(history.length);
      transactionhistory = history;
    });
  }

  _onSuccessGetbalance(String balance) {
    _waits(false);
    setState(() {
      availableBalance = balance;
      print(balance);
    });
  }

  void callAPI() {
    _waits(true);
    walletHistory(account.token, _onSuccess, _error);
    walletBalance(account.token, _onSuccessGetbalance, _error);
  }

  bool isVisibility(int index) {
    bool isVisible = false;
    return isVisible;
  }
}
