import 'package:flutter/material.dart';

void main() {
  runApp(background_image_another());
}

class background_image_another extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Container(
              child: FractionallySizedBox(
                heightFactor: 1.0,
                widthFactor: 1.0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/sample.png"),
                      fit: BoxFit.fill,
                      alignment:Alignment.topCenter,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
