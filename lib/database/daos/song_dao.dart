// DAO's stand for DATA ACCESS OBJECT

// this class's only purpose is to talk to the DB

// handles all function calls into the database called QUERIES

// import
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'song_dao.g.dart';

@DriftAccessor(tables: [Songs])
class SongDao extends DatabaseAccessor<AppDatabase> with _$SongDaoMixin {
  SongDao(AppDatabase db) : super(db);

  // insert a song
  Future<int> insertSong(SongsCompanion song) => into(songs).insert(song, mode: InsertMode.insertOrIgnore);

  // Get all songs
  Future<List<Song>> getAllSongs() => select(songs).get();

  // Count all songs
  Future<int?> countSongs() async {
    final countExp = songs.id.count();
    return (selectOnly(songs)..addColumns([countExp])).map((row) => row.read(countExp)).getSingle();
  }

  // get by ID
  Future<Song?> getSongById(int id) => (select(songs)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  // Update
  Future<bool> updateSong(Song song) => update(songs).replace(song);

  // Delete
  Future<int> deleteSong(int id) => (delete(songs)..where((tbl) => tbl.id.equals(id))).go();

  // Query sorted
  Future<List<Song>> sortedByTitle() => (select(songs)..orderBy([(t) => OrderingTerm.asc(t.title)])).get();

  // Mark favorite - inputs = id and value
  Future toggleFavorite(int id, bool value) => (update(songs)..where((s) => s.id.equals(id))).write(SongsCompanion(favorite: Value(value)));

  // is song present
  Future<bool> songExists(String path) async {
    final query = select(songs)..where((tbl) => tbl.path.equals(path));
    return (await query.get()).isNotEmpty;
  }
}

/*

This gives CRUD
Sorting
Favorites
Get individual Songs
Update/Delete
Perfect for media player UI

*/
