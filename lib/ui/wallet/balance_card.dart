import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livetraxdigitl/ui/checkout/paymentMethod.dart';
import 'package:livetraxdigitl/ui/config/theme.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({Key key, this.balance}) : super(key: key);

  final String balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .27,
            color: AppThemeData.navyBlue1,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Total Balance,',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppThemeData.lightNavyBlue),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          balance,
                          style: GoogleFonts.mulish(
                              textStyle: Theme.of(context).textTheme.display1,
                              fontSize: 35,
                              fontWeight: FontWeight.w800,
                              color: AppThemeData.yellow2),
                        ),
                        Text(
                          ' \$',
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                              color: AppThemeData.yellow.withAlpha(200)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Eq:',
                          style: GoogleFonts.mulish(
                              textStyle: Theme.of(context).textTheme.display1,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppThemeData.lightNavyBlue),
                        ),
                        Text(
                          ' 10,000\$',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.of(context).pushNamed('/checkout/payment',
                        //     arguments: PaymentMethod(
                        //       isTopup: true,
                        //     ));
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PaymentMethod(
                            // productId: widget.productId,
                            // price: widget.price,
                            isTopup: true,
                          ),
                        ));
                      },
                      child: Container(
                          width: 85,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              border:
                                  Border.all(color: Colors.white, width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 5),
                              Text("Top up",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          )),
                    )
                  ],
                ),
                Positioned(
                  left: -170,
                  top: -170,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: AppThemeData.lightBlue2,
                  ),
                ),
                Positioned(
                  left: -160,
                  top: -190,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: AppThemeData.lightBlue1,
                  ),
                ),
                Positioned(
                  right: -170,
                  bottom: -170,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: AppThemeData.yellow2,
                  ),
                ),
                Positioned(
                  right: -160,
                  bottom: -190,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: AppThemeData.yellow,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
