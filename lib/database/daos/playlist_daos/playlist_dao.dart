//import
import 'package:drift/drift.dart';
import '../../app_database.dart';
import '../../tables.dart';

part 'playlist_dao.g.dart';

@DriftAccessor(tables: [Playlists])
class PlaylistDao extends DatabaseAccessor<AppDatabase> with _$PlaylistDaoMixin {
  PlaylistDao(AppDatabase db) : super(db);

  // 1. Insert a new playlist
  // Returns the ID of the newly inserted playlist
  Future<int> insertPlaylist(PlaylistsCompanion playlist) => 
    into(playlists).insert(playlist);

  // 2. Get all playlists, sorted by name ascending
  Future<List<Playlist>> getAllPlaylists() => 
    (select(playlists)..orderBy([(p) => OrderingTerm.asc(p.name)])).get();

  // 3. Get playlist by ID
  Future<Playlist?> getPlaylistById(int id) => 
    (select(playlists)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  // 4. Update an existing playlist (e.g., changing the name)
  // Returns true if a row was replaced, false otherwise
// Inside PlaylistDao
// ...
// Targeted update function for name
Future<int> updatePlaylistName(int id, String newName) => 
  (update(playlists)..where((tbl) => tbl.id.equals(id))).write(
    PlaylistsCompanion(name: Value(newName))
  );
// ...
  // 5. Delete a playlist by ID
  // Returns the number of affected rows (should be 1)
  Future<int> deletePlaylist(int id) => 
    (delete(playlists)..where((tbl) => tbl.id.equals(id))).go();

  // 6. Toggle a playlist's 'pinned' status
  // NOTE: This assumes you've added an `isPinned` column to your Playlists table.
  Future<int> togglePinStatus(int id, bool value) => 
    (update(playlists)..where((p) => p.id.equals(id)))
        .write(PlaylistsCompanion(
            isPinned: Value(value),
        ));
}