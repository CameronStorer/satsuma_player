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
    return const MaterialApp(
      title: 'Satsuma Player',
      home: CustomTabController(),
    );
  }
}

// tab controller class
class CustomTabController extends StatelessWidget {
  //constructor
  const CustomTabController({super.key});

  // tab widget for tab-click-actions
  Widget _buildCommandTab(BuildContext context, IconData icon, String action) {
    return InkWell(
      // 💡 Key step: Use onTap to execute your command
      onTap: () => mediaPlaybackAction(action),
      // Set the splash color for visual feedback
      splashColor: Colors.blue.shade100,
      child: Tab(icon: Icon(icon)),
    );
  }

  // build UI
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
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

        bottomNavigationBar: TabBar(
          tabs: <Widget>[
            _buildCommandTab(context, Icons.fast_rewind_rounded, 'reverse'),
            _buildCommandTab(context, Icons.pause, 'pause'),
            _buildCommandTab(context, Icons.fast_forward_rounded, 'forward'),
          ],
        ),
      ),
    );
  }
}
