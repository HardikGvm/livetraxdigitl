import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:livetraxdigitl/payment/PaypalServices.dart';
import 'package:livetraxdigitl/ui/server/ArtistListAPI.dart';
import 'package:livetraxdigitl/widgets/colorloader2.dart';
import '../../main.dart';
import 'ArtistDetailScreen.dart';

class ArtistList extends StatefulWidget {
  const ArtistList({Key key}) : super(key: key);

  @override
  _ArtistListState createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  bool _wait = false;

  List<UserData> list = [];
  bool isLoadMore = false;
  static int pagination_index = 1;
  var windowWidth;
  var windowHeight;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _waits(true);

    int pagination_index = 1;
    _artist('artist', pagination_index, 4, true);

    //  CheckPaypal();
  }

  PaypalServices services = PaypalServices();
  String accessToken;
  bool _needsScroll = false;
  bool _NoMoreData = false;
  bool _ReadyToCall = true;

  CheckPaypal() async {
    final request = BraintreeCreditCardRequest(
      cardNumber: '4863379846187769',
      expirationMonth: '01',
      expirationYear: '2022',
    );

    /*final transactions = getOrderParams();
    final res =
    await services.createPaypalPayment(transactions, accessToken);*/

    accessToken = await services.getAccessToken();
    print("Check Payment Nonce Here TOK > " +
        accessToken);
    BraintreePaymentMethodNonce result = await Braintree.tokenizeCreditCard(
      accessToken,
      request,
    );

    print("Check Payment Nonce Here > " +
        result.nonce +
        " DES " +
        result.description);
  }

  @override
  void dispose() {
    print(":::Dispose:::");
    pagination_index = 1;
    _needsScroll = false;
    _NoMoreData = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Artists';
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    if (_needsScroll) {
      //_scrollToEnd();
      _needsScroll = false;
    }

    CheckPaypal();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/sample.png"),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                controller: _scrollController,
                shrinkWrap: true,
                children: List.generate(
                  list == null || list.isEmpty ? 0 : list.length,
                  (index) {
                    return GestureDetector(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: new NetworkImage((list == null ||
                                            list.isEmpty ||
                                            list[index].image == null)
                                        ? 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'
                                        : list[index].image),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 1.0,
                                      style: BorderStyle.solid)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 16.0, bottom: 8.0),
                            child: Text(
                              list == null && list.isEmpty ||
                                      list[index].artist_name == null
                                  ? 'Artist'
                                  : list[index].artist_name,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ArtistDetailScreen(
                                  artist_id: list[index].id.toString(),
                                  artist_name: list[index].artist_name,
                                  artist_description: list[index].description,
                                  artist_image: list[index].image)),
                        );
                        pagination_index = 1;
                      },
                    );
                  },
                ),
              ),
            ),
            if (_wait)
              (Container(
                color: Color(0x80000000),
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
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: MaterialButton(
                  child: Text('More Artist', style: TextStyle(fontSize: 16)),
                  onPressed: () => {
                    _artist('artist', pagination_index, 4, false),
                    isLoadMore = true
                  },
                  color: Colors.white,
                  textColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _okUserEnter(List<UserData> list) {
    _waits(false);
    setState(() {
      _ReadyToCall = true;
    });
    print(":::isLoadMore::" + isLoadMore.toString());
    if (isLoadMore) {
      isLoadMore = false;
      if (list != null && list.length != 0) {
        print(":::list.length::" + list.length.toString());
        for (var i = 0; i < list.length; i++) {
          UserData userData = list[i];
          print(":::INDEX::: " + i.toString());
          // print(":::Artist Name::: " + userData.artist_name);
          print("::: image ::: " + userData.image);
          this.list.add(userData);
        }
        setState(() {});
        print(":::pagination_index::" + pagination_index.toString());

        _needsScroll = true;
      } else {
        _NoMoreData = true;
        _needsScroll = false;
      }
    } else {
      this.list = list;
      setState(() {});
    }
  }

  _artist(String type, int page, int limit, bool isFirst) {

    if (_ReadyToCall) {
      if (_NoMoreData) {
        _error(strings.get(2292));
      } else {
        if (!isFirst) {
          pagination_index = pagination_index + 1;
          print("Pages PLUS>> " + pagination_index.toString());
        }
        _waits(true);
        setState(() {
          _ReadyToCall = false;
        });

        artist_list_api(type, pagination_index, limit, _okUserEnter, _error);
      }
    }
  }

  _waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
  }

  _error(String error) {
    _waits(false);
    setState(() {
      _ReadyToCall = true;
    });
    openDialog("${strings.get(158)} $error"); // "Something went wrong. ",
  }

  // double _show = 0;
  // Widget _dialogBody = Container();

  openDialog(String _text) {
    // _dialogBody = Column(
    //   children: [
    //     Text(
    //       _text,
    //       style: theme.text14,
    //     ),
    //     SizedBox(
    //       height: 40,
    //     ),
    //     IButton3(
    //         color: theme.colorPrimary,
    //         text: strings.get(66), // Cancel
    //         textStyle: theme.text14boldWhite,
    //         pressButton: () {
    //           setState(() {
    //             // _show = 0;
    //           });
    //         }),
    //   ],
    // );

    setState(() {
      // _show = 1;
    });
  }

  // _scrollToEnd() async {
  //   SchedulerBinding.instance.addPostFrameCallback((_) {
  //     _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 10),
  //       curve: Curves.easeOut,
  //     );
  //   });
  // }
}
