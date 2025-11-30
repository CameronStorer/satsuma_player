import 'package:flutter/material.dart'; // holding material widgets
import '../app_logic/media_management.dart';
import 'dart:io'; // input/output
import 'package:path/path.dart' as path; // file path recognition

// widgets to represent content for each song page tab
final List<Widget> songTabContents = [
  Scaffold(
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

  Text("hi"),
  ElevatedButton(
    onPressed: () {
      scanForMedia();
    },
    child: Text("Rescan Library"),
  ),
];
      // Expanded(
      //   child: ListView.builder(
      //     itemCount: songs.length,
      //     padding: const EdgeInsets.all(8),

      //     itemBuilder: (BuildContext context, int index) {
      //       final String currentSong = songs[index];
      //       final String currentArtist = artists[index];

      //       return SizedBox(
      //         height: 50,
      //         // color: Color.fromARGB(255, 255, 153, 0),
      //         child: RichText(
      //           textAlign: TextAlign.center, // Center align the text
      //           text: TextSpan(
      //             style: TextStyle(
      //               color: Colors.black,
      //               fontWeight: FontWeight.bold,
      //             ),
      //             children: <TextSpan>[
      //               TextSpan(
      //                 text: '$currentSong ',
      //                 style: TextStyle(
      //                   color: const Color.fromARGB(255, 255, 217, 0),
      //                   fontSize: 18,
      //                 ),
      //               ),
      //               TextSpan(
      //                 text: currentArtist,
      //                 style: TextStyle(
      //                   color: const Color.fromARGB(255, 99, 53, 0),
      //                   fontSize: 14,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      // ),