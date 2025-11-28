// import required libraries
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// define the StatefulWidget class
class DownloadTab extends StatefulWidget {
  // constructor
  const DownloadTab({super.key});

  @override
  State<DownloadTab> createState() => _DownloadTabState();
}

// define the State class
class _DownloadTabState extends State<DownloadTab> {
  // manage state variables here

  // build the UI for this tab content
  @override
  Widget build(BuildContext context) {

  final _urlController = TextEditingController();
  final YoutubeExplode _yt = YoutubeExplode();

  String _status = 'Enter a URL';
  bool _downloading = false;
  double _progress = 0;
  List<MuxedStreamInfo> _formats = [];
  MuxedStreamInfo? _selectedFormat;
  Video? _currentVideo;

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






    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Download Songs',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
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
      ],);
  }
}
