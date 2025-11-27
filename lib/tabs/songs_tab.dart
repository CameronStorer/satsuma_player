// import required libraries
import 'package:flutter/material.dart';
import '../app_logic/media_management.dart';
import 'package:path/path.dart' as path; // file path recognition
import 'dart:io'; // input/output


// define the StatefulWidget class
class SongsTab extends StatefulWidget {
  // constructor
  const SongsTab({super.key});

  @override
  State<SongsTab> createState() => _SongsTabState();
}

// define the State class
class _SongsTabState extends State<SongsTab> {
  // manage state variables here

  // build the UI for this tab content
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      // scaffold
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(46),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // title
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Your Songs',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TabBar(
                        // padding: const EdgeInsets.symmetric(horizontal: 2),
                        tabs: [
                          Tab(icon: Icon(Icons.search), text: 'Search'),
                          Tab(icon: Icon(Icons.sort), text: 'Sort By'),
                          Tab(icon: Icon(Icons.loop), text: 'Rescan'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Expanded(
          child: Scaffold(
            body: FutureBuilder<List<File>>(
              future: scanForMedia(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No media found."));
                }

                final files = snapshot.data!;

                return ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    // final filename = file.path.split('/').last;

                    return ListTile(
                      leading: const Icon(Icons.music_note),
                      title: Text(path.basename(file.path)),
                      onTap: () {
                        playMedia(file);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
