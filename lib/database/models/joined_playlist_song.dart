// lib/models/joined_playlist_song.dart

import 'package:drift/drift.dart';
import 'package:satsuma_player/database/app_database.dart';
import '../tables.dart';

// Drift automatically generates these classes from your tables.dart file
// Song is generated from the Songs table
// PlaylistSong is generated from the PlaylistSongs table

/// A custom class to hold the result of joining the Songs and PlaylistSongs tables.
class JoinedPlaylistSong {
  // This holds the song's metadata (title, artist, durationMs, etc.)
  final Song song; 
  
  // This holds the song's playlist-specific data (playlistId, songId, position)
  final PlaylistSong playlistSong;

  JoinedPlaylistSong({
    required this.song,
    required this.playlistSong,
  });
}