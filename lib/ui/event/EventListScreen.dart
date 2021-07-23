import 'package:flutter/material.dart';
import 'package:need_resume/need_resume.dart';
import 'package:tomo_app/ui/event/AddEventScreen.dart';
import 'package:tomo_app/ui/model/pref.dart';
import 'package:tomo_app/ui/server/DeleteEvent.dart';
import 'package:tomo_app/ui/server/EventListAPI.dart';
import 'package:tomo_app/widgets/colorloader2.dart';
import 'package:tomo_app/widgets/ibutton3.dart';
import '../../main.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({key}) : super(key: key);

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends ResumableState<EventListScreen> {
  bool _wait = false;
  var windowWidth;
  var windowHeight;
  bool isChanges = false;
  List<EventData> list = new List();

  @override
  void onReady() {
    callAPI();
    super.onReady();
  }

  @override
  void onResume() {
    print("::: On Resume ::: ");
    isChanges = pref.getBool(Pref.isChanges);
    if (isChanges) {
      pref.setBool(Pref.isChanges, false);
      callAPI();
    }
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    list == null && list.isEmpty ||
                                            list[index].event_date == null
                                        ? '31.01.2015'
                                        : list[index].event_date,
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                Visibility(
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    tooltip: 'Delete Event',
                                    onPressed: () {
                                      deleteEventAPI(list[index].id.toString(), index,
                                          _onSuccessDelete, _error);
                                    },
                                  ),
                                  visible: isVisibility(index),
                                )
                              ],
                            ),
                            SizedBox(height: 30),
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
                            SizedBox(height: 30),
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
          push(
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
    event_list_api(artist, page, limit, _onSuccessEventList, _error);
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

  _onSuccessEventList(List<EventData> list) {
    _waits(false);
    this.list = list;
    var i;
    for (i = 0; i < list.length; i++) {
      print(":::ID::: " + list[i].id.toString());
    }
    setState(() {});
  }

  _onSuccessDelete(String message, int index) {
    _waits(false);
    if (message == 'User deleted successfully!') {
      print("::: Data deleted :::" + index.toString());
      list.removeAt(index);
      setState(() {});
    }
  }

  void callAPI() {
    _waits(true);
    if (list != null && list.length > 0) {
      print(":::Call API:::");
      list.clear();
    }
    _event(account.userId, 1, 0);
  }

  bool isVisibility(int index) {
    bool isVisible = false;
    if (list != null && list.isNotEmpty) {
      if (list[index].artist == int.parse(account.userId)) {
        isVisible = true;
      } else {
        isVisible = false;
      }
    } else {
      isVisible = false;
    }
    return isVisible;
  }
}
