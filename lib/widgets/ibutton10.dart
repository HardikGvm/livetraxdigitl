import 'package:flutter/material.dart';

class IButton10 extends StatelessWidget {
  @required final Function() pressButton;
  final Color color;
  final String text;
  final double height;
  final TextStyle textStyle;
  final bool onlyBorder;
  IButton10({this.pressButton, this.text = "", this.color = Colors.blue, this.textStyle, this.height = 45, this.onlyBorder = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: (onlyBorder) ? Colors.transparent : color,
          border: (onlyBorder) ? Border.all(color: color) : null,
          borderRadius: new BorderRadius.circular(25),
        ),
        child: Stack(
      children: <Widget>[
        Container(
          height: height,
          width: 100,
          child: Center(child: Text(text, style: textStyle, textAlign: TextAlign.center,)
          ),
        ),
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0) ),
              child: InkWell(
                splashColor: Colors.blue[400],
                onTap: (){
                  if (pressButton != null)
                    pressButton();
                }, // needed
              )),
        )
      ],
    ));
  }
}