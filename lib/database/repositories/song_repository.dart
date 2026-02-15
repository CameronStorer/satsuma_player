//import
import 'package:satsuma_player/database/tables.dart';

import '../app_database.dart';
import '../daos/song_dao.dart';
import 'package:path/path.dart' as path;
import 'package:drift/drift.dart';

// commands for the UI to communicate with the database
class SongRepository {
  final SongDao _songDao;

  // constructor
  SongRepository(AppDatabase db) : _songDao = db.songDao;

  // get all songs: direct Database Access Object communicator
  Future<List<Song>> getAllSongs() => _songDao.getAllSongs();
  // Sort them by title
  // Future<List<Song>> getSortedByTitle() => _songDao.sortedByTitle();

  // Add song from file path
  Future<void> addSongFromFile(String filePath) async {
    final song = SongsCompanion.insert(path: filePath, filename: Value(path.basename(filePath)));

    await _songDao.insertSong(song); // <-- calls the DAO
  }

  // mark song as favorite
  Future toggleFavorite(int id, bool value) => _songDao.toggleFavorite(id, value);

  // get song by its id
  Future<Song?> getSongById(int id) => _songDao.getSongById(id);

  // ensure that a song exists
  Future<bool> songExists(String path) => _songDao.songExists(path);

  // return count of songs
  Future<int?> songCount() => _songDao.countSongs();
}

/*

prevents UI code from touching SQL
makes future changes painless
makes testing easier

 */
