import 'package:flutter/material.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget(
      {Key key,
      this.title,
      this.button1,
      this.button2,
        this.height,
      this.onButton1Clicked,
      this.onButton2Clicked})
      : super(key: key);

  final String title;
  final String button1;
  final String button2;
  final double height;
  final VoidCallback onButton1Clicked;
  final VoidCallback onButton2Clicked;

  @override
  _DialogWidgetState createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(
                Radius.circular(6) //                 <--- border radius here
                ),
          ),
          height: widget.height??140,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              widget.title,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            widget.button2 == null
                ? SizedBox(
                    width: 80,
                    child: ElevatedButton(
                        onPressed: widget.onButton1Clicked,
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.grey),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: BorderSide(color: Colors.transparent),
                            ))),
                        child: Text(
                          widget.button1,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                          onPressed: widget.onButton1Clicked,
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.transparent),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                                side: BorderSide(color: Colors.grey),
                              ))),
                          child: Text(
                            widget.button1,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: widget.onButton2Clicked,
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.amber),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                                side: BorderSide(color: Colors.transparent),
                              ))),
                          child: Text(
                            widget.button2,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
          ])),
    );
  }
}
