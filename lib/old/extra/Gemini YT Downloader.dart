import 'dart:io';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// --- Global Variables ---
const String __app_id = 'flutter-downloader-app';
// const String __firebase_config = '{"apiKey": "dummy-key", "projectId": "default-project"}';
const String __initial_auth_token = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Parse Firebase config
  // final firebaseConfig = jsonDecode(__firebase_config);

  // await Firebase.initializeApp(
  //   options: FirebaseOptions(
  //     apiKey: firebaseConfig['apiKey'] ?? '',
  //     appId: '1:1:web:1', // placeholder
  //     messagingSenderId: '1', // placeholder
  //     projectId: firebaseConfig['projectId'] ?? 'default-project',
  //   ),
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Downloader',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const VideoDownloaderScreen(),
    );
  }
}

class VideoDownloaderScreen extends StatefulWidget {
  const VideoDownloaderScreen({super.key});

  @override
  State<VideoDownloaderScreen> createState() => _VideoDownloaderScreenState();
}

class _VideoDownloaderScreenState extends State<VideoDownloaderScreen> {
  final _urlController = TextEditingController();
  final YoutubeExplode _yt = YoutubeExplode();

  String _status = 'Enter a URL';
  bool _downloading = false;
  double _progress = 0;
  List<MuxedStreamInfo> _formats = [];
  MuxedStreamInfo? _selectedFormat;
  Video? _currentVideo;

  // late FirebaseAuth _auth;
  // late FirebaseFirestore _db;
  // String? _userId;

  // @override
  // void initState() {
  //   super.initState();
  //   _initializeFirebaseAuth();
  // }

  // Future<void> _initializeFirebaseAuth() async {
  //   _auth = FirebaseAuth.instance;
  //   _db = FirebaseFirestore.instance;

  //   if (__initial_auth_token.isNotEmpty) {
  //     await _auth.signInWithCustomToken(__initial_auth_token);
  //   } else {
  //     await _auth.signInAnonymously();
  //   }

  //   _auth.authStateChanges().listen((user) {
  //     setState(() {
  //       _userId = user?.uid ?? 'anonymous';
  //     });
  //   });
  // }

  Future<void> _fetchVideoInfo() async {
    if (_urlController.text.isEmpty) return;

    setState(() {
      _status = 'Fetching info...';
      _downloading = true;
      _formats = [];
      _selectedFormat = null;
      _progress = 0;
    });

    try {
      final video = await _yt.videos.get(_urlController.text);
      final manifest = await _yt.videos.streamsClient.getManifest(video.id);

      setState(() {
        _currentVideo = video;
        _formats = manifest.muxed.toList();
        _selectedFormat = _formats.isNotEmpty ? _formats.first : null;
        _status = 'Select format';
        _downloading = false;
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _downloading = false;
      });
    }
  }

  Future<void> _startDownload() async {
    if (_selectedFormat == null || _currentVideo == null) return;

    setState(() {
      _downloading = true;
      _progress = 0;
      _status = 'Downloading...';
    });

    try {
      final format = _selectedFormat!;
      final video = _currentVideo!;

      final dir = (Platform.isAndroid)
          ? (await getExternalStorageDirectory())?.path
          : (await getApplicationDocumentsDirectory()).path;

      final safeTitle = video.title.replaceAll(RegExp(r'[^\w\s\-]'), '');
      final path = '$dir/$safeTitle.${format.container.name}';

      final file = File(path);
      final out = file.openWrite();

      final stream = _yt.videos.streamsClient.get(format);
      int downloaded = 0;
      final total = format.size.totalBytes;

      await for (final chunk in stream) {
        out.add(chunk);
        downloaded += chunk.length;
        setState(() {
          _progress = downloaded / total;
          _status = 'Downloading: ${(_progress * 100).toStringAsFixed(1)}%';
        });
      }
      await out.close();

      // await _db
      //     .collection('artifacts/$_app_id/users/$_userId/downloads')
      //     .doc()
      //     .set({
      //   'videoId': video.id.value,
      //   'title': video.title,
      //   'author': video.author,
      //   'filePath': path,
      //   'quality': '${format.videoQualityLabel} (${format.container.name})',
      //   'timestamp': FieldValue.serverTimestamp(),
      // });

      setState(() {
        _status = 'Download complete: $path';
        _downloading = false;
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _downloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Downloader')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                  labelText: 'YouTube URL',
                  suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _fetchVideoInfo)),
            ),
            const SizedBox(height: 12),
            if (_formats.isNotEmpty)
              DropdownButton<MuxedStreamInfo>(
                isExpanded: true,
                value: _selectedFormat,
                items: _formats.map((f) {
                  return DropdownMenuItem(
                      value: f,
                      child: Text(
                          '${f.videoQualityLabel} - ${f.container.name} (${f.size.totalMegaBytes.toStringAsFixed(1)} MB)'));
                }).toList(),
                onChanged: (v) => setState(() => _selectedFormat = v),
              ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: (_selectedFormat != null && !_downloading)
                  ? _startDownload
                  : null,
              child: _downloading
                  ? LinearProgressIndicator(value: _progress)
                  : const Text('Download'),
            ),
            const SizedBox(height: 20),
            Text(_status),
            const SizedBox(height: 8),
            // Text('User ID: ${_userId ?? 'Loading...'}'),
          ],
        ),
      ),
    );
  }
}
