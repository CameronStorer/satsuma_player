// File to handle the scanning and management of media

// import the appropriate packages
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart'; // audio handling
import 'package:media_scanner/media_scanner.dart'; // for scanning media

final AudioPlayer audioPlayer = AudioPlayer();

Future<Directory> getMediaDir() async {
  Directory mediaDir;

  if (Platform.isWindows) {
    // Windows: put it in the user's Music folder
    final musicDir = Directory(
      path.join(Platform.environment['USERPROFILE']!, 'Music', 'SatsumaPlayer'),
    );
    mediaDir = musicDir;
  } else if (Platform.isAndroid) {
    // Android: public Music folder
    // Note: Starting Android 10+, you may need permissions (MANAGE_EXTERNAL_STORAGE) for true public access
    final externalMusicDir = Directory(
      '/storage/emulated/0/Music/SatsumaPlayer',
    );
    mediaDir = externalMusicDir;
  } else if (Platform.isIOS) {
    // iOS: app's Documents folder (sandboxed)
    final documentsDir = await getApplicationDocumentsDirectory();
    mediaDir = Directory(path.join(documentsDir.path, 'media'));
  } else if (Platform.isLinux || Platform.isMacOS) {
    // Other desktop OS: use home directory + Music
    final homeDir = Directory(Platform.environment['HOME']!);
    mediaDir = Directory(path.join(homeDir.path, 'Music', 'SatsumaPlayer'));
  } else {
    // fallback: app documents directory
    final documentsDir = await getApplicationDocumentsDirectory();
    mediaDir = Directory(path.join(documentsDir.path, 'media'));
  }

  // ensure the directory exists
  if (!await mediaDir.exists()) {
    await mediaDir.create(recursive: true);
  }

  return mediaDir;
}

// function to return a list of all media files detected by the app
Future<List<File>> scanForMedia() async {
  if (Platform.isAndroid) {
    await MediaScanner.loadMedia(path: "/storage/emulated/0/Music");
  }
  print("Media scan complete!");
  // set var dir = media directory
  final dir = await getMediaDir();

  // allowed extension types
  const allowedExtensions = ['.mp3', '.wav', '.mp4'];

  final files = <File>[];

  // Recursively list everything
  await for (final entity in dir.list(recursive: true, followLinks: false)) {
    if (entity is File) {
      final ext = path.extension(entity.path).toLowerCase();
      if (allowedExtensions.contains(ext)) {
        files.add(entity);
      }
    }
  }

  return files;
}

// function to play media when selected in the app
void playMedia(File file) {
  final ext = path.extension(file.path).toLowerCase();

  if (ext == '.mp3' || ext == '.wav') {
    playAudio(file.path);
    // } else if (ext == '.mp4') {
    //   playVideo(file.path);
  } else {
    print("Unsupported file type: $ext");
  }
}

// helper method to play audio files

Future<void> playAudio(String path) async {
  try {
    await audioPlayer.setFilePath(path);
    await audioPlayer.play();
  } catch (e) {
    print("Audio error: $e");
  }
}


// // helper method to play video files 
// void playVideo(String path) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => VideoPlayerPage(path: path),
//     ),
//   );
// }

void mediaPlaybackAction(String action){}