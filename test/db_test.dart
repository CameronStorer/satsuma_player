// import the files required to test
import '../lib/database/app_database.dart';
import '../lib/database/repositories/song_repository.dart';
import 'package:flutter_test/flutter_test.dart';

// create main async func
void main() async {
  // required for testing within this flutter project and using our databases
  TestWidgetsFlutterBinding.ensureInitialized(); // <-- REQUIRED FIX

  // basic print debug
  print('\n\n\nTHIS IS A DATABASE TEST\n\n\n');

  // initialize the database
  final db = AppDatabase();

  // instantialize an object of the SongRepository class
  final repo = SongRepository(db);

  // call repo's getAllSongs function to return a song list of every song
  List<Song> songs = await repo.getAllSongs();

  // this list will be empty at first and will need to be added to

  // let's attempt to add some songs to our song table in the database

  for (int i = 0; i < songs.length; i++) {
    print(songs[i]);
  }

}
