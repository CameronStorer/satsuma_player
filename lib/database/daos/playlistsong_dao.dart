//import
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'playlistsong_dao.g.dart';

@DriftAccessor(tables: [PlaylistSongs])
class PlaylistSongDao extends DatabaseAccessor<AppDatabase> with _$PlaylistSongDaoMixin {
  PlaylistSongDao(AppDatabase db) : super(db);

  // insert a song

  // get all songs

  // get by ID

  // update

  // delete

  // Query sorted

}