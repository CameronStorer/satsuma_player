// lib/repositories/playlistsong_repository.dart

// import
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';
import '../daos/playlist_daos/playlistsong_dao.dart';
import '../models/joined_playlist_song.dart';

class PlaylistSongRepository {
  final PlaylistSongDao _playlistSongDao;

  PlaylistSongRepository(AppDatabase db) : _playlistSongDao = db.playlistSongDao;

  /// Get all songs for a specific playlist, including Song metadata, ordered by position.
  Future<List<JoinedPlaylistSong>> getSongsInPlaylist(int playlistId) => 
      _playlistSongDao.getSongsInPlaylist(playlistId);

  /// Adds a single song to the END of a playlist.
  Future<void> addSongToPlaylist(int playlistId, int songId) async {
    // 1. Determine the correct position (at the end)
    final position = await _playlistSongDao.getNextPosition(playlistId);

    // 2. Create the junction table entry
    final entry = PlaylistSongsCompanion.insert(
      playlistId: playlistId,
      songId: songId,
      position: position,
    );

    // 3. Insert the entry
    await _playlistSongDao.insertPlaylistSong(entry);

    // NOTE: You would typically update the 'songCount' in the Playlists table here 
    // using the PlaylistDao (or handle that update in a Drift trigger/transaction).
  }
  
  /// Removes a song from a specific playlist.
  Future<int> removeSongFromPlaylist(int playlistId, int songId) =>
      _playlistSongDao.deleteSongFromPlaylist(playlistId, songId);

  /// Updates the position of a single song within a playlist (low-level reordering).
  Future<int> updateSongPosition(int playlistId, int songId, int newPosition) => 
      _playlistSongDao.updateSongPosition(playlistId, songId, newPosition);

  /// Clears all songs from a given playlist.
  Future<int> clearPlaylist(int playlistId) => 
      _playlistSongDao.clearPlaylist(playlistId);
}