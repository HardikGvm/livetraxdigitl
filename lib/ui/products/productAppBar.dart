import 'package:flutter/material.dart';

class productAppBar extends StatefulWidget with PreferredSizeWidget {
  final String leftButtonText;
  final String rightButtonText;
  final String centerButtonText;
  final void Function () rightButtonFunction;
  final void Function () leftButtonFunction;

  productAppBar(this.leftButtonText, this.rightButtonText, this.rightButtonFunction,this.centerButtonText,this.leftButtonFunction);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _productAppBarState createState() => _productAppBarState();
}

class _productAppBarState extends State<productAppBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                //Navigator.pop(context);
                widget.leftButtonFunction();
              },
              child: Text(
                widget.leftButtonText,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey
                ),
              ),
            ),
            Center(child: Text(
                widget.centerButtonText,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
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

