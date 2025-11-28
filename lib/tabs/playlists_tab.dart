// import required libraries
import 'package:flutter/material.dart';

// define the StatefulWidget class
class PlaylistsTab extends StatefulWidget {
  // constructor
  const PlaylistsTab({super.key});

  @override
  State<PlaylistsTab> createState() => _PlaylistsTabState();
}

// define the State class
class _PlaylistsTabState extends State<PlaylistsTab> {
  // manage state variables here

  // build the UI for this tab content
  @override
  Widget build(BuildContext context) {
    // list of Playlist objects
    final List<Playlist> userPlaylists = const [
      Playlist('Coding Focus', 'assets/covers/1.png', 45),
      Playlist('Coding Focus', 'assets/covers/2.png', 1),
      Playlist('Coding Focus', 'assets/covers/3.png', 23),
      Playlist('Coding Focus', 'assets/covers/4.png', 67),
      Playlist('Coding Focus', 'assets/covers/5.png', 100),
      Playlist('Coding Focus', 'assets/covers/6.png', 12),
    ];

    return Column(
      // Column is used for the title shown above the grid (of playlists)
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // page title
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Your Playlists',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(onPressed: () {}, padding: EdgeInsets.all(15), icon: Icon(Icons.add_circle)),
          ],
        ),
        // --- build the playlist grid ---
        Expanded(
          // use a GridView.builder
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: userPlaylists.length,
            // --- gridDelegate to help organize grid elements ---
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              // set some attributes for the grid
              // Max width allowed for each item.
              // Flutter calculates how many can fit.
              // Setting this lower makes the tiles smaller.
              maxCrossAxisExtent: 140.0, // max width 140 pixels
              crossAxisSpacing: 10.0,
              mainAxisSpacing:
                  15.0, // Increased vertical spacing for better separation
              childAspectRatio:
                  0.8, // Adjusted aspect ratio to account for text below the square image
            ),

            // --- Build Each Playlist Item ---
            itemBuilder: (context, index) {
              final Playlist playlist = userPlaylists[index];
              // The individual item structure remains the same
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // 1. COVER ART
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(playlist.imagePath, fit: BoxFit.cover),
                    ),
                  ),
                  // 2. TITLE
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      playlist.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  // 3. SONG COUNT
                  Text(
                    '${playlist.songCount} songs',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// playlist class to hold playlist details
class Playlist {
  // class variables
  final String title;
  final String imagePath;
  final int songCount;

  // class constructor
  const Playlist(this.title, this.imagePath, this.songCount);
}
