// this file holds the main logic of our database

// import required libraries
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// local imports
import 'tables.dart';
import 'daos/song_dao.dart';
import 'daos/playlist_daos/playlist_dao.dart';
import 'daos/playlist_daos/playlistsong_dao.dart';

part 'app_database.g.dart'; // Drift generator output

// auto generates DAO's?
@DriftDatabase(
  tables: [Songs, Playlists, PlaylistSongs],
  daos: [SongDao, PlaylistDao, PlaylistSongDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    // create persistent SQLite file?
    final file = File(p.join(dir.path, 'satsuma_player.sqlite'));
    return NativeDatabase(file);
  });
}

/*

Generates a persistent SQLite file
Auto-generates DAOs
You only need one AppDatabase() instance for the whole app

 */
