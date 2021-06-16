import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:tomo_app/ui/Music/MusicPlayList.dart';

class ArtistDetailScreen extends StatefulWidget {
  const ArtistDetailScreen({Key key}) : super(key: key);

  @override
  _ArtistDetailScreenState createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Artist'),
        backgroundColor: Color.fromARGB(217, 217, 217, 255),
      ),
      body: Container(
        // For background Image
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage("lib/assets/images/background_image.png"),
        //         fit: BoxFit.cover)),

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: new Text(
                'Kiwi Time',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: new Text(
                  'Kiwi time is San Francisco band of four childhood friends.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center),
            )
          ],
        ),
      ),
      floatingActionButton: FabCircularMenu(
        fabOpenIcon: Icon(Icons.menu, color: Colors.red),
        fabCloseIcon: Icon(Icons.close, color: Colors.red),
        fabColor: Colors.white,
        ringColor: Colors.white30,
        children: [
          IconButton(
              icon: Icon(Icons.event, color: Colors.red),
              onPressed: () {
                print('Live Event');
              }),
          IconButton(
              icon: Icon(Icons.music_note, color: Colors.red),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MusicPlayList()),
                );
              }),
          IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.red),
              onPressed: () {
                print('Buy Merchandise');
              })
        ],
      ),
    );
  }
}
