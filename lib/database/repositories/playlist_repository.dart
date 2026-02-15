// lib/repositories/playlist_repository.dart

// import
import 'package:drift/drift.dart';
import 'package:satsuma_player/database/daos/playlist_daos/playlist_dao.dart';
import 'package:satsuma_player/database/daos/playlist_daos/playlistsong_dao.dart';
import '../app_database.dart';
import '../tables.dart';
import '../daos/playlist_daos/playlistsong_dao.dart';
import '../daos/playlist_daos/playlist_dao.dart'; // Needed for cascading delete

class PlaylistRepository {
  final PlaylistDao _playlistDao;
  final PlaylistSongDao _playlistSongDao; // Needed to clear contents on delete

  PlaylistRepository(AppDatabase db) 
      : _playlistDao = db.playlistDao,
        _playlistSongDao = db.playlistSongDao;

  /// Get all playlists, typically sorted by name or pin status.
  Future<List<Playlist>> getAllPlaylists() => _playlistDao.getAllPlaylists();

  /// Creates a new playlist with the given name.
  Future<int> createPlaylist(String name) {
    final playlist = PlaylistsCompanion(name: Value(name));
    return _playlistDao.insertPlaylist(playlist);
  }

  /// Renames an existing playlist.
// Inside PlaylistRepository

/// Renames an existing playlist.
Future<int> updatePlaylistName(int id, String newName) {
  // Now we call the DAO method that accepts the ID and the new value.
  return _playlistDao.updatePlaylistName(id, newName);
}

  /// Deletes a playlist AND removes all song entries associated with it (cascading delete logic).
  Future<int> deletePlaylist(int id) async {
    // 1. Clear contents first (delete rows in PlaylistSongs table)
    await _playlistSongDao.clearPlaylist(id);

    // 2. Delete the playlist itself (from Playlists table)
    return _playlistDao.deletePlaylist(id);
  }

  /// Toggles the pinned status of a playlist.
  Future<int> togglePin(int id, bool value) => _playlistDao.togglePinStatus(id, value);

  /// Helper function to get a specific playlist object.
  Future<Playlist?> getPlaylistById(int id) => _playlistDao.getPlaylistById(id);
}