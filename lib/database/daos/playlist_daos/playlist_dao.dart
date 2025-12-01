//import
import 'package:drift/drift.dart';
import '../../app_database.dart';
import '../../tables.dart';

part 'playlist_dao.g.dart';

@DriftAccessor(tables: [Playlists])
class PlaylistDao extends DatabaseAccessor<AppDatabase> with _$PlaylistDaoMixin {
  PlaylistDao(AppDatabase db) : super(db);

  // insert playlist

  // get all playlists

  // get playlist by ID

  // update playlist

  // delete playlist

  // pin playlist


}