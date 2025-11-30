//import
import '../app_database.dart';

class SongRepository {
  final SongDao _songDao;

  SongRepository(AppDatabase db) : _songDao = db.songDao;

  Future<List<Song>> getAllSongs() => _songDao.getAllSongs();
  Future<List<Song>> getSortedByTitle() => _songDao.sortedByTitle();

  Future<int> addSong(String path) async {
    final song = SongsCompanion.insert(path: path);
    return _songDao.insertSong(song);
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