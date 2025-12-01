//import
import '../app_database.dart';
import '../daos/song_dao.dart';
import 'package:path/path.dart' as path;
import 'package:drift/drift.dart';

class SongRepository {
  final SongDao _songDao;

  SongRepository(AppDatabase db) : _songDao = db.songDao;

  Future<List<Song>> getAllSongs() => _songDao.getAllSongs();
  Future<List<Song>> getSortedByTitle() => _songDao.sortedByTitle();

  Future<void> addSongFromFile(String filePath) async {
    final song = SongsCompanion.insert(
      path: filePath,
      filename: Value(path.basename(filePath)),
    );

    await _songDao.insertSong(song); // <-- calls the DAO
  }

  Future toggleFavorite(int id, bool value) =>
      _songDao.toggleFavorite(id, value);

  Future<Song?> getSongById(int id) => _songDao.getSongById(id);
}

/*

prevents UI code from touching SQL
makes future changes painless
makes testing easier

 */
