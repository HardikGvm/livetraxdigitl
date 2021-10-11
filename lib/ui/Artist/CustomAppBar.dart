import 'package:flutter/material.dart';
import 'package:livetraxdigitl/main.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  final String leftButtonText;
  final String rightButtonText;
  final String centerButtonText;
  final void Function () rightButtonFunction;

  CustomAppBar(this.leftButtonText, this.rightButtonText, this.rightButtonFunction,this.centerButtonText);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                if(account.role == "artist"){
                  Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
                }else{
                  Navigator.pop(context);
                }

              },
              child: Icon(Icons.arrow_back),
            ),
            Center(child: Text(
                widget.centerButtonText,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                )
            ),),
            GestureDetector(
              onTap: (){
                widget.rightButtonFunction();
              },
              child: Text(
                  widget.rightButtonText,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}

