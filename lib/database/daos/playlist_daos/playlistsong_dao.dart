//import
import 'package:drift/drift.dart';
import '../../app_database.dart';
import '../../tables.dart';
import '../../models/joined_playlist_song.dart'; // We'll assume you create a joined model

part 'playlistsong_dao.g.dart';

@DriftAccessor(tables: [PlaylistSongs, Songs])
class PlaylistSongDao extends DatabaseAccessor<AppDatabase> with _$PlaylistSongDaoMixin {
  PlaylistSongDao(AppDatabase db) : super(db);

  // 1. Insert a song into a specific playlist (at a certain position)
  // Returns the row ID of the inserted record in PlaylistSongs
  Future<int> insertPlaylistSong(PlaylistSongsCompanion entry) => 
    into(playlistSongs).insert(entry);

  // 2. Get all songs for a given playlist, joined with Song details, and sorted by position.
  Future<List<JoinedPlaylistSong>> getSongsInPlaylist(int playlistId) {
    final query = select(playlistSongs).join([
      innerJoin(songs, songs.id.equalsExp(playlistSongs.songId)),
    ]);

    query.where(playlistSongs.playlistId.equals(playlistId));
    // query.orderBy([(t) => OrderingTerm.asc(playlistSongs.position)]);

    // Map the result to a custom data class combining fields from both tables
    return query.map((row) {
      // Assumes JoinedPlaylistSong is a custom class combining PlaylistSong and Song data
      return JoinedPlaylistSong(
        song: row.readTable(songs),
        playlistSong: row.readTable(playlistSongs),
      );
    }).get();
  }

  // 3. Get the maximum position currently used in a playlist
  // Useful for determining where to insert the next song (at the end).
  Future<int> getNextPosition(int playlistId) async {
    final maxPos = playlistSongs.position.max();
    final query = selectOnly(playlistSongs)
      ..addColumns([maxPos])
      ..where(playlistSongs.playlistId.equals(playlistId));
    
    final result = await query.map((row) => row.read(maxPos)).getSingleOrNull();
    // If the playlist is empty (result is null), the next position is 0. Otherwise, it's max + 1.
    return (result ?? -1) + 1;
  }
  
  // 4. Update the position of a song within a playlist (reordering)
  // Requires the ID of the song/playlist pair and the new position.
  Future<int> updateSongPosition(int playlistId, int songId, int newPosition) => 
    (update(playlistSongs)
      ..where((tbl) => tbl.playlistId.equals(playlistId) & tbl.songId.equals(songId)))
      .write(PlaylistSongsCompanion(position: Value(newPosition)));

  // 5. Delete a song from a specific playlist
  Future<int> deleteSongFromPlaylist(int playlistId, int songId) => 
    (delete(playlistSongs)
      ..where((tbl) => tbl.playlistId.equals(playlistId) & tbl.songId.equals(songId)))
      .go();

  // 6. Delete ALL songs from a playlist (e.g., when the user clears a playlist)
  Future<int> clearPlaylist(int playlistId) => 
    (delete(playlistSongs)..where((tbl) => tbl.playlistId.equals(playlistId))).go();
}