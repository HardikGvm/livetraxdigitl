import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';

class ArtistDetailScreen extends StatefulWidget {
  final String artist_name, artist_description, artist_image;

  const ArtistDetailScreen(
      {Key key,
      @required this.artist_name,
      @required this.artist_description,
      @required this.artist_image})
      : super(key: key);

  @override
  _ArtistDetailScreenState createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Artist'),
        backgroundColor: Color.fromARGB(217, 217, 217, 255),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        // For background Image
        decoration: BoxDecoration(
            image: DecorationImage(
                image: new NetworkImage(
                    (widget.artist_image != null) ? widget.artist_image : ""),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new Text(
                      (widget.artist_name != null &&
                              widget.artist_name.isNotEmpty)
                          ? widget.artist_name
                          : "Kiwi time",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new Text(
                        (widget.artist_description != null &&
                                widget.artist_description.isNotEmpty)
                            ? widget.artist_description
                            : 'Kiwi time is San Francisco band of four childhood friends.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.left),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: MaterialButton(
                  child: Text('Active', style: TextStyle(fontSize: 18)),
                  onPressed: () => {},
                  color: Colors.green,
                  textColor: Colors.white,
                  padding:
                      EdgeInsets.only(left: 32, right: 32, top: 12, bottom: 12),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FabCircularMenu(
        key: fabKey,
        fabOpenIcon: Icon(Icons.menu, color: Colors.red),
        fabCloseIcon: Icon(Icons.close, color: Colors.red),
        fabColor: Colors.white,
        ringDiameter: 340.0,
        ringWidth: 90.0,
        ringColor: Colors.white70,
        children: [
          IconButton(
              icon: Icon(Icons.event, color: Colors.red),
              iconSize: 28,
              onPressed: () {
                fabKey.currentState.close();
                print('Live Event');
              }),
          IconButton(
              icon: Icon(Icons.music_note, color: Colors.red),
              iconSize: 28,
              onPressed: () {
                fabKey.currentState.close();

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => MusicPlayListScreen()),
                // );

              }),
          IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.red),
              iconSize: 28,
              onPressed: () {
                fabKey.currentState.close();
                print('Buy Merchandise');
              })
        ],
      ),
    );
  }
}
