import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/VoterListResponse.dart';

class DbHelper {
  static const _DATA_BASE_NAME = "voters_data.db";
  static const _DATA_BASE_VERSION = 1;

  static const _TABLE_VOTERS = 'voters';

  //column for feeds table
  static const COLUMN_NAME = 'name';

  // make this a singleton class
  DbHelper._();

  static final DbHelper instance = DbHelper._();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _DATA_BASE_NAME);
    return await openDatabase(path, version: _DATA_BASE_VERSION, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $_TABLE_VOTERS (
            $COLUMN_NAME TEXT )
          ''');
  }

  // feeds table work
  Future<int?> insertFeeds(Voters voters) async {
    Database? db = await instance.database;
    var result = await db?.insert(_TABLE_VOTERS, {
      'name': voters.fullNameEn
    });
    return result;
  }

  Future<int?> getCount() async {
    //database connection
    Database? db = await instance.database;
    var x = await db?.rawQuery('SELECT COUNT (*) from voters');
    int? count = Sqflite.firstIntValue(x!);

    if(count !=null)
    {
      return count;
    }
    else
      {
        return 0;
      }
  }
  
  Future<List<Map<String, dynamic>>?> getVotersMap() async {
    Database? db = await instance.database;
    var result = await db?.query(_TABLE_VOTERS);
    return result;
  }

  Future<List<Voters>> getAllFeeds() async {
    List<Voters>? listItem = List<Voters>.empty(growable: true);
    var votersMapList = await getVotersMap(); // Get 'Map List' from database
    int count = votersMapList!.length;
    for (int i = 0; i < count; i++) {
      listItem.add(Voters(
        fullNameEn: votersMapList[i]['name']
      ));
    }
    return listItem;
  }

  Future<int?> deleteFeedData() async {
    Database? db = await instance.database;
    await db?.execute("DROP TABLE IF EXISTS voters");
    await db?.execute('''
          CREATE TABLE $_TABLE_VOTERS (
            $COLUMN_NAME TEXT )
          ''');
  }

}
