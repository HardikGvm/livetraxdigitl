import 'package:flutter/material.dart';
import 'package:tomo_app/ui/server/ArtistListAPI.dart';
import 'package:tomo_app/widgets/ibutton3.dart';
import '../../main.dart';
import 'ArtistDetailScreen.dart';

class ArtistList extends StatefulWidget {
  const ArtistList({Key key}) : super(key: key);

  @override
  _ArtistListState createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  bool _wait = false;

  List<UserData> list = new List();
  bool isLoadMore = false;
  static int pagination_index = 1;

  @override
  void initState() {
    super.initState();
    int pagination_index = 1;
    _artist('artist', pagination_index, 2);
  }
  @override
  void dispose() {
    print(":::Dispose:::");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Artists';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
        backgroundColor: Color.fromARGB(217, 217, 217, 255),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/sample.png"),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            Center(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
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
                              builder: (context) => ArtistDetailScreen()),
                        );
                        pagination_index = 1;
                      },
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: FlatButton(
                  child: Text('More Artist', style: TextStyle(fontSize: 16)),
                  onPressed: () => {
                    _artist('artist', pagination_index++, 2),
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
    print(":::isLoadMore::" + isLoadMore.toString());
    print(":::list.length::" + list.length.toString());
    print(":::pagination_index::" + pagination_index.toString());

    if (isLoadMore) {
      isLoadMore = false;
      if (list != null) {
        for (var i = 0; i < list.length; i++) {
          UserData userData = list[i];
          this.list.add(userData);
        }
        setState(() {});
      }
    } else {
      this.list = list;
      setState(() {});
    }
  }

  _artist(String type, int page, int limit) {
    artist_list_api(type, page, limit, _okUserEnter, _error);
  }

  _waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
  }

  _error(String error) {
    _waits(false);
    openDialog("${strings.get(158)} $error"); // "Something went wrong. ",
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
}
