import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tomo_app/ui/model/pref.dart';
import 'package:tomo_app/ui/server/AddEvent.dart';
import 'package:tomo_app/ui/server/uploadImage.dart';
import 'package:tomo_app/ui/server/uploadavatar.dart';
import 'package:tomo_app/widgets/colorloader2.dart';
import 'package:tomo_app/widgets/easyDialog2.dart';
import 'package:tomo_app/widgets/iAvatarWithPhotoFileCaching.dart';
import 'package:tomo_app/widgets/ibutton3.dart';
import '../../main.dart';

class AddEventScreen extends StatefulWidget {
  final Function(String) onDialogOpen;

  const AddEventScreen({key, this.onDialogOpen}) : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  var windowWidth;
  var windowHeight;
  Widget _dialogBody = Container();
  bool wait = false;
  double _show = 0;
  final picker = ImagePicker();
  double mainDialogShow = 0;
  Widget mainDialogBody = Container();

  String dropdownvalue;
  var items = ['Paid', 'Free'];

  final _formKey = GlobalKey<FormState>();
  final FocusNode fnTitle = FocusNode();
  final FocusNode fnDescription = FocusNode();
  final FocusNode fnEeventDate = FocusNode();
  final FocusNode fnEventTime = FocusNode();
  final FocusNode fnPrice = FocusNode();
  final TextEditingController _textController = new TextEditingController();

  bool _autovalidate = false;
  String _title;
  String _Description;
  String _eventDate;
  String _eventTime;
  String _price;

  DateTime currentDate = DateTime.now();

  double _height;
  double _width;

  String _hour, _minute, _time;

  String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('ADD EVENT'),
        backgroundColor: Color.fromARGB(217, 217, 217, 255),
      ),
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        (20 + 20 + 16 + 24),
                    maxWidth: min(479, MediaQuery.of(context).size.width),
                  ),
                  child: Container(
                    height: (MediaQuery.of(context).size.height - 150),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        top: 10,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        left: 10,
                        right: 10,
                      ),
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IAvatarWithPhotoFileCaching(
                            avatar: account.userAvatar,
                            color: theme.colorPrimary,
                            colorBorder: theme.colorGrey,
                            callback: getImage,
                          ),
                          Form(
                            key: _formKey,
                            autovalidate: _autovalidate,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 28, bottom: 18, left: 18, right: 18),
                                  child: TextFormField(
                                    key: Key("txtTitle"),
                                    autocorrect: true,
                                    autofocus: false,
                                    textInputAction: TextInputAction.next,
                                    focusNode: fnTitle,
                                    onFieldSubmitted: (term) {
                                      fnTitle.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(fnDescription);
                                    },
                                    onSaved: (val) {
                                      _title = val;
                                    },
                                    maxLength: 254,
                                    textAlign: TextAlign.start,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.text,
                                    textCapitalization: TextCapitalization.none,
                                    maxLines: 1,
                                    expands: false,
                                    cursorWidth: 2,
                                    maxLengthEnforced: true,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Enter Title";
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: strings.get(2246),
                                      // hintText: " First name ",
                                      hintMaxLines: 1,
                                      contentPadding: EdgeInsets.all(4),
                                      counterText: "",
                                      labelStyle: TextStyle(
                                        fontSize: 12,
                                      ),
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                      ),
                                      errorMaxLines: 1,
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red[300])),
                                      errorStyle: TextStyle(
                                        color: Colors.red[300],
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 0, bottom: 18, left: 18, right: 18),
                                  child: TextFormField(
                                    key: Key("txtDescription"),
                                    autocorrect: true,
                                    autofocus: false,
                                    textInputAction: TextInputAction.next,
                                    focusNode: fnDescription,
                                    onFieldSubmitted: (term) {
                                      fnDescription.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(fnEeventDate);
                                    },
                                    onSaved: (val) {
                                      _Description = val;
                                    },
                                    maxLength: 254,
                                    textAlign: TextAlign.start,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.text,
                                    textCapitalization: TextCapitalization.none,
                                    maxLines: 1,
                                    expands: false,
                                    cursorWidth: 2,
                                    maxLengthEnforced: true,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Enter Description";
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: strings.get(2247),
                                      // hintText: " Last name ",
                                      hintMaxLines: 1,
                                      contentPadding: EdgeInsets.all(4),
                                      counterText: "",
                                      labelStyle: TextStyle(
                                        fontSize: 12,
                                      ),
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                      ),
                                      errorMaxLines: 1,
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red[300])),
                                      errorStyle: TextStyle(
                                        color: Colors.red[300],
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 0, bottom: 18, left: 18, right: 18),
                                  child: TextFormField(
                                    key: Key("txtEventDate"),
                                    controller: _dateController,
                                    onSaved: (val) {
                                      _eventDate = val;
                                    },
                                    onTap: () async {
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      _selectDate(context);
                                    },
                                    maxLength: 254,
                                    textAlign: TextAlign.start,
                                    textAlignVertical: TextAlignVertical.center,
                                    textCapitalization: TextCapitalization.none,
                                    maxLines: 1,
                                    expands: false,
                                    cursorWidth: 2,
                                    maxLengthEnforced: true,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Enter event date";
                                      }
                                    },
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: strings.get(2248),
                                      // hintText: " Email ",
                                      hintMaxLines: 1,
                                      contentPadding: EdgeInsets.all(4),
                                      counterText: "",
                                      labelStyle: TextStyle(
                                        fontSize: 12,
                                      ),
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                      ),
                                      errorMaxLines: 1,
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red[300])),
                                      errorStyle: TextStyle(
                                        color: Colors.red[300],
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 0, bottom: 18, left: 18, right: 18),
                                  child: TextFormField(
                                    key: Key("txtEventTime"),
                                    textInputAction: TextInputAction.next,
                                    controller: _timeController,
                                    onSaved: (val) {
                                      _eventTime = val;
                                    },
                                    onTap: () async {
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      _selectTime(context);
                                    },
                                    maxLength: 51,
                                    textAlign: TextAlign.start,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.text,
                                    textCapitalization: TextCapitalization.none,
                                    maxLines: 1,
                                    expands: false,
                                    cursorWidth: 2,
                                    maxLengthEnforced: true,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Enter event time";
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: strings.get(2249),
                                      // hintText: " Username ",
                                      hintMaxLines: 1,
                                      contentPadding: EdgeInsets.all(4),
                                      counterText: "",
                                      labelStyle: TextStyle(
                                        fontSize: 12,
                                      ),
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                      ),
                                      errorMaxLines: 1,
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red[300])),
                                      errorStyle: TextStyle(
                                        color: Colors.red[300],
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 0, bottom: 18, left: 18, right: 18),
                                  child: DropdownButtonFormField(
                                    isExpanded: true,
                                    value: dropdownvalue,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),

                                    hint: Text(strings.get(2250)),
                                    //Event Type
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    isDense: true,
                                    items: items.map((String items) {
                                      return DropdownMenuItem(
                                          value: items, child: Text(items));
                                    }).toList(),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropdownvalue = newValue;
                                      });
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: isVisibility(),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 0,
                                        bottom: 18,
                                        left: 18,
                                        right: 18),
                                    child: TextFormField(
                                      key: Key("txtPrice"),
                                      autocorrect: true,
                                      autofocus: false,
                                      textInputAction: TextInputAction.done,
                                      focusNode: fnPrice,
                                      onFieldSubmitted: (term) {
                                        fnPrice.unfocus();
                                      },
                                      onSaved: (val) {
                                        _price = val;
                                      },
                                      maxLength: 10,
                                      textAlign: TextAlign.start,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      keyboardType: TextInputType.number,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      maxLines: 1,
                                      expands: false,
                                      cursorWidth: 2,
                                      maxLengthEnforced: true,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Enter Price";
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: strings.get(2251),
                                        // hintText: " Password ",
                                        hintMaxLines: 1,
                                        contentPadding: EdgeInsets.all(4),
                                        counterText: "",

                                        labelStyle: TextStyle(
                                          fontSize: 12,
                                        ),
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                        ),
                                        errorMaxLines: 1,
                                        errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red[300])),
                                        errorStyle: TextStyle(
                                          color: Colors.red[300],
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: IButton3(
                            color: theme.colorPrimary,
                            text: strings.get(2252), // Proceed
                            textStyle: theme.text14boldWhite,
                            pressButton: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                addEventAPI(
                                    account.userId,
                                    _title,
                                    _Description,
                                    _eventDate,
                                    _eventTime,
                                    _price,
                                    _okUserEnter,
                                    _error);
                              } else {
                                _autovalidate = true;
                              }
                            })),
                  ),
                ),
              ],
            ),
          ),
          if (wait)
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
        ],
      ),
    );
  }

  getImage() {
    print(":::::TYtytyty:::::");
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

  Future getImage2(ImageSource source) async {
    _waits(true);
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null && pickedFile.path != null) {
      print(":::File Path::: " + pickedFile.path);
      _waits(true);
      uploadImage(pickedFile.path, account.token, (String avatar) {
        // account.setUserAvatar(avatar);
        print(":::Date::: " + avatar);
        _waits(false);
        setState(() {});
      }, (String error) {
        _waits(false);
        _openDialogError(
            "${strings.get(128)} $error"); // "Something went wrong. ",
      });
    } else
      _waits(false);
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

  _waits(bool value) {
    wait = value;
    if (mounted) setState(() {});
  }

  _okUserEnter(String message) {
    _waits(false);
    if (message == 'Event Created successfully!') {
      if (Navigator.canPop(context)) {
        pref.setBool(Pref.isChanges, true);
        Navigator.pop(context);
      } else {
        SystemNavigator.pop();
      }
    }
  }

  _error(String error) {
    _waits(false);
    _openDialogError("${strings.get(158)} $error"); // "Something went wrong. ",
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        // _timeController.text = formatDate(
        //     DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
        //     [hh, ':', nn, " ", am]).toString();
      });
  }

  bool isVisibility() {
    bool isVisible = true;
    if (dropdownvalue == 'Paid') {
      isVisible = true;
    } else if(dropdownvalue == 'Free'){
      isVisible = false;
    }
    return isVisible;
  }
}
