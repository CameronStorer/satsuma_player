// import necessary libraries
import 'package:flutter/material.dart'; // holding material widgets
import 'package:path/path.dart' as path; // file path recognition
import 'dart:io'; // input/output
import 'app_logic/media_management.dart'; // local dart file for file management
import 'package:just_audio/just_audio.dart';

// main function to run the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// MyApp class (stateless widget)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Widget build function
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // app title
      title: 'Satsuma Player',

      // 1. Define light theme (default theme)
      theme: ThemeData(
        // light brightness
        brightness: Brightness.light,
        useMaterial3: true,
        // Custom light colors
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
        ),
      ),

      // 2. Define dark theme
      darkTheme: ThemeData(
        // dark brightness
        brightness: Brightness.dark,
        useMaterial3: true,
        // Custom dark colors
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
      ),
      // home page title
      home: const HomePage(title: 'Satsuma Player'),
    );
  }
}

// HomePage class (stateful widget)
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

////////////////// BOILER PLATE ABOVE THIS LINE ///////////////////

// HomePageState class
class _HomePageState extends State<HomePage> {
  @override
  // the build method of the HomePageState
  Widget build(BuildContext context) {
    // define some local variables to be displayed on the page

    // list holding test songs
    final List<String> songs = [
      'Paper Cuts',
      'Alone',
      'Faded',
      'Cradles',
      'Happier',
      'Stay',
      'Light It Up',
      'Silence',
      'Friends',
      'The Spectre',
      'Wolves',
      'Sing Me to Sleep',
      'Runaway',
      'You Are Not Alone',
      'On My Way',
      'Darkside',
      'Ignite',
      'Lily',
      'Never Be Alone',
      'Reality',
      'Heading Home',
      'Dreamer',
      'Fly Away',
      'Summer',
      'Find Me',
      'Together',
      'Take You Home',
      'Flashbacks',
      'Shelter',
      'Goodbye',
    ];
    // list holding artist names
    final List<String> artists = [
      'Wes Ghost',
      'Marshmello',
      'Alan Walker',
      'Illenium',
      'Marshmello',
      'The Kid LAROI',
      'Major Lazer',
      'Marshmello',
      'Marshmello',
      'Alan Walker',
      'Selena Gomez',
      'Alan Walker',
      'Alan Walker',
      'K-391',
      'Alan Walker',
      'Alan Walker',
      'K-391',
      'Alan Walker',
      'Alan Walker',
      'Lost Frequencies',
      'Lost Frequencies',
      'Axwell Λ Ingrosso',
      'Alan Walker',
      'Marshmello',
      'Marshmello',
      'Marshmello',
      'Marshmello',
      'Porter Robinson & Madeon',
      'Marshmello',
      'Marshmello',
    ];
    // list holding genres
    final List<String> genres = [
      'Rock',
      'Pop',
      'Classical',
      'Podcast',
      'Jazz',
      'Chill',
    ];
    // list of Playlist objects
    final List<Playlist> userPlaylists = const [
      Playlist('Coding Focus', 'assets/covers/1.png', 45),
      Playlist('Coding Focus', 'assets/covers/2.png', 1),
      Playlist('Coding Focus', 'assets/covers/3.png', 23),
      Playlist('Coding Focus', 'assets/covers/4.png', 67),
      Playlist('Coding Focus', 'assets/covers/5.png', 100),
      Playlist('Coding Focus', 'assets/covers/6.png', 12),
    ];
    // number of tabs on the top nav bar
    const int navTabs = 4;
    // number of tabs on the song nav bar
    const int songNavBar = 3;
    ThemeMode themeMode = ThemeMode.light;
    bool isDarkMode = false;

    /////////////////// CREATE THE APP'S PAGES ///////////////////////////


    // widgets to represent content for each tab
    final List<Widget> tabContents = [
      // --- playlists tab content: ---
      Column(
        // Column is used for the title shown above the grid (of playlists)
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // page title
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Your Playlists',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
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
                        child: Image.asset(
                          playlist.imagePath,
                          fit: BoxFit.cover,
                        ),
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
      ),

      // songs tab content:
      DefaultTabController(
        length: songNavBar,
        // scaffold
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Your Songs',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],),
                // buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TabBar(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      tabs: [
                        Tab(icon: Icon(Icons.search), text: 'Search'),
                        Tab(icon: Icon(Icons.sort), text: 'Sort By'),
                        Tab(icon: Icon(Icons.loop), text: 'Rescan'),
                      ],
                    ),
                  ),
            ]),
            Expanded(child: TabBarView(children: songTabContents)),
          ],
        ),
      ),


      // download page content
      Center(child: Text('Download Content')),


      // settings page content
      // Column(children: <Widget> [
      //   Center(child: Text('Settings Content')),
      // ],),
      // Settings tab with inline switch
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (value) {
                  setState(() {
                    themeMode = value ? ThemeMode.dark : ThemeMode.light;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    ];

    // widget to represent the Now Playing bar
    final Widget nowPlayingBar = Center(child: Text('Now Playing Content'));

    // the more important part that is ACTUALLY DISPLAYED
    return DefaultTabController(
      // number of tabs to have
      length: navTabs, // specify tab num
      // scaffold is what is actually presented to the user
      child: Scaffold(
        // the top nav bar
        appBar: AppBar(
          // title: Text("Satsuma Player"),
          // no title desired
          toolbarHeight: 0,

          // tab bar navigation
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.playlist_play), text: 'Playlists'),
              Tab(icon: Icon(Icons.music_note), text: 'Songs'),
              Tab(icon: Icon(Icons.download), text: 'Download'),
              Tab(icon: Icon(Icons.settings), text: 'Settings'),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 228, 143, 6),
        ),

        // main page content
        body: TabBarView(children: tabContents),

        // now playing bar
        bottomNavigationBar: artists.isNotEmpty
            ? BottomAppBar(
                color: const Color.fromARGB(255, 228, 143, 6),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Now Playing: ${songs[0]} by ${artists[0]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : null,
      ),
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
