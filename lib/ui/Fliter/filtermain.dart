import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLib;
import 'package:photofilters/filters/preset_filters.dart';
import 'package:photofilters/widgets/photo_filter.dart';

//void main() => runApp(FilterMain());

class FilterMain extends StatelessWidget {
  String _imagePath;

  FilterMain(String imagepath) {
    this._imagePath = imagepath;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(_imagePath),
    );
  }
}

class HomePage extends StatefulWidget {
  String _imagePath;
  HomePage(String imagepath){
      this._imagePath=imagepath;
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String fileName;

  @override
  Widget build(BuildContext context) {

  String str=widget._imagePath;

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Photo Filter'),
      ),
      body: Stack(
        children: <Widget>[
          widget._imagePath != null
              ? capturedImageWidget(widget._imagePath)
              : noImageWidget(),
          fabWidget(),
        ],
      ),
    );
  }

  Widget noImageWidget() {
    return SizedBox.expand(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Icon(
            Icons.image,
            color: Colors.grey,
          ),
          width: 60.0,
          height: 60.0,
        ),
        Container(
          margin: EdgeInsets.only(top: 8.0),
          child: Text(
            'No Image Captured',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    ));
  }

  Widget capturedImageWidget(String imagePath) {
    return SizedBox.expand(
      child: Image.file(File(
        imagePath,
      )),
    );
  }

  Widget fabWidget() {
    return Positioned(
      bottom: 30.0,
      right: 16.0,
      child: FloatingActionButton(
        onPressed: openCamera,
        child: Icon(
          Icons.photo_camera,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future openCamera()  async {


      var imageFile = File(widget._imagePath);
      fileName = path.basename(imageFile.path);
      var image = imageLib.decodeImage(imageFile.readAsBytesSync());
      image = imageLib.copyResize(image, width: 600);
      Map imagefile = await Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new PhotoFilterSelector(
            title: Text("Edit"),
            image: image,
            filters: presetFiltersList,
            filename: fileName,
            loader: Center(child: CircularProgressIndicator()),
            fit: BoxFit.contain,
            appBarColor: Colors.blue,
          ),
        ),
      );
      if (imagefile != null && imagefile.containsKey('image_filtered')) {
        setState(() {
          imageFile = imagefile['image_filtered'];
          widget._imagePath = imageFile.path;
        });
      }

  }
}
