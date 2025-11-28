// import appropriate libraries
import 'package:flutter/material.dart';
import 'package:satsuma_player/app_logic/media_management.dart';
import 'tabs/playlists_tab.dart';
import 'tabs/songs_tab.dart';
import 'tabs/download_tab.dart';
import 'tabs/settings_tab.dart';

// main func
void main() {
  runApp(const SatsumaPlayer());
}

// app class
class SatsumaPlayer extends StatelessWidget {
  // constructor
  const SatsumaPlayer({super.key});

  // build UI
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

      home: CustomTabController(),
    );
  }
}

// tab controller class
class CustomTabController extends StatelessWidget {
  //constructor
  const CustomTabController({super.key});

  // build UI
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: const Color.fromARGB(255, 228, 143, 6),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Playlists', icon: Icon(Icons.list)),
              Tab(text: 'Songs', icon: Icon(Icons.music_note)),
              Tab(text: 'Download', icon: Icon(Icons.download)),
              Tab(text: 'Settings', icon: Icon(Icons.settings)),
            ],
          ),
        ),

        // Now display the contents of each tab
        body: const TabBarView(
          children: [PlaylistsTab(), SongsTab(), DownloadTab(), SettingsTab()],
        ),

        // bottom button bar
        bottomNavigationBar: Container(color: Color.fromARGB(255, 228, 143, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shuffle),
                iconSize: 18,
                padding: EdgeInsets.all(25),
                constraints: const BoxConstraints(),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.fast_rewind_rounded),
                iconSize: 40,
                padding: EdgeInsets.all(20),
                constraints: const BoxConstraints(),
              ),
              IconButton(
                onPressed: () {
                  mediaPlaybackAction("Pause");
                },
                icon: const Icon(Icons.pause_rounded),
                iconSize: 40,
                padding: EdgeInsets.all(20),
                constraints: const BoxConstraints(),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.fast_forward_rounded),
                iconSize: 40,
                padding: EdgeInsets.all(20),
                constraints: const BoxConstraints(),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.loop),
                iconSize: 18,
                padding: EdgeInsets.all(25),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
