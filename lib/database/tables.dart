// THIS FILE HOLDS THE TABLES THAT WE WILL USE IN OUR DATABASE

// import required libraries
import 'package:drift/drift.dart';

// create Songs table (holds all songs)
class Songs extends Table {
  IntColumn get id => integer().autoIncrement()(); // create id column
  TextColumn get path => text().unique()(); // full file path to the audio file
  TextColumn get filename => text().nullable()();
  TextColumn get title => text().withDefault(const Constant('Unkown Title'))(); // song meta data (title, artist, durationMs)
  TextColumn get artist => text().withDefault(const Constant('Unkown Artist'))();
  IntColumn get durationMs => integer().withDefault(const Constant(0))();
  BoolColumn get favorite => boolean().withDefault(const Constant(false))(); // useful fields for sorting / filtering
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
}

// create the Playlists table (holds playlists)
class Playlists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get songCount => integer().withDefault(const Constant(0))();
}

// create the PlaylistSongs table (holds the songs in each playlist)
class PlaylistSongs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get playlistId => integer().references(Playlists, #id)();
  IntColumn get songId => integer().references(Songs, #id)();
  IntColumn get position => integer()(); // order within playlist
}
