import 'package:flutter/material.dart';
import 'package:tomo_app/ui/event/AddEventScreen.dart';
import 'package:tomo_app/ui/server/EventListAPI.dart';
import 'package:tomo_app/widgets/colorloader2.dart';
import 'package:tomo_app/widgets/ibutton3.dart';
import '../../main.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({key}) : super(key: key);

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  bool _wait = false;
  var windowWidth;
  var windowHeight;
  List<EventData> list = new List();

  @override
  void initState() {
    super.initState();
    _waits(true);
    _event('2', 1, 1);
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('EVENTS'),
        backgroundColor: Color.fromARGB(217, 217, 217, 255),
      ),
      body: Stack(
        children: [
          new ListView.separated(
            itemCount: list == null || list.isEmpty ? 0 : list.length,
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
                color: Color.fromARGB(247, 247, 247, 255),
                child: Row(
                  children: [
                    new Flexible(
                      child: Image.network((list == null ||
                              list.isEmpty ||
                              list[index].image == null)
                          ? 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'
                          : list[index].image),
                      flex: 1,
                    ),
                    new Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          children: [
                            new Flexible(
                              child: Text(
                                list == null && list.isEmpty ||
                                        list[index].event_date == null
                                    ? '31.01.2015'
                                    : list[index].event_date,
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                            Text(
                              list == null && list.isEmpty ||
                                      list[index].title == null
                                  ? 'Thy Art is Murder'
                                  : list[index].title,
                              style: TextStyle(fontSize: 12.0),
                            ),
                            Text(
                              list == null && list.isEmpty ||
                                      list[index].desc == null
                                  ? 'Attila & Aversion Crown'
                                  : list[index].desc,
                              style: TextStyle(fontSize: 12.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    list == null && list.isEmpty ||
                                            list[index].event_time == null
                                        ? '12.00'
                                        : list[index].event_time,
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ),
                                IconButton(
                                  icon:
                                      const Icon(Icons.navigate_next_outlined),
                                  tooltip: 'Increase volume by 10',
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      flex: 1,
                    )
                  ],
                ),
              );
            },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEventScreen()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Color.fromARGB(217, 217, 217, 255),
      ),
    );
  }

  _event(String artist, int page, int limit) {
    print("::::Data::::");
    event_list_api(artist, page, limit, _okUserEnter, _error);
  }

  _waits(bool value) {
    _wait = value;
    print("::::TRUE::::");
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

  _okUserEnter(List<EventData> list) {
    _waits(false);
    this.list = list;
    setState(() {});
  }
}
