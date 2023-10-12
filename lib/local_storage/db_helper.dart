import 'dart:async';
import 'dart:io';

import 'package:congress_app/utils/app_utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/BoothResponseData.dart';
import '../model/VoterListResponse.dart';

class DbHelper {
  static const _DATA_BASE_NAME = "voters_data.db";
  static const _DATA_BASE_VERSION = 5;
  static const _TABLE_VOTERS = 'voters';
  static const _TABLE_BOOTHS = 'booths';

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
     await createVotersTable(db);
     await createBoothTable(db);
  }

  Future<void> createVotersTable(Database db) async {
    await db.execute("CREATE TABLE voters ("
        "id INTEGER,"
        "acNo INTEGER,"
        "partNo INTEGER,"
        "sectionNo INTEGER,"
        "slnoinpart INTEGER,"
        "fullNameEn TEXT,"
        "fullNameV1 TEXT,"
        "fmNameEn TEXT,"
        "lastnameEn TEXT,"
        "fmNameV1 TEXT,"
        "lastnameV1 TEXT,"
        "rlnType TEXT,"
        "rlnFmNmEn TEXT,"
        "rlnLNmEn TEXT,"
        "rlnFmNmV1 TEXT,"
        "rlnLNmV1 TEXT,"
        "epicNo TEXT,"
        "gender TEXT,"
        "age TEXT,"
        "dob TEXT,"
        "mobileNo TEXT,"
        "pcNo INTEGER,"
        "pcnameEn TEXT,"
        "pcnameV1 TEXT,"
        "acNameEn TEXT,"
        "acNameV1 TEXT,"
        "sectionNameV1 TEXT,"
        "sectionNameEn TEXT,"
        "villageNameEn TEXT,"
        "villageNameV1 TEXT,"
        "postoffNameEn TEXT,"
        "postoffNameV1 TEXT,"
        "postoffPin TEXT,"
        "partNameEn TEXT,"
        "partNameV1 TEXT,"
        "psbuildingNameEn TEXT,"
        "psbuildingNo INTEGER,"
        "psbuildingNameV1 TEXT,"
        "tahsilNameEn TEXT,"
        "tahsilNameV1 TEXT,"
        "policestNameEn TEXT,"
        "policestNameV1 TEXT,"
        "whatsappNo TEXT,"
        "newAddress TEXT,"
        "aadhaarNo TEXT,"
        "email TEXT,"
        "referenceName TEXT,"
        "bloodGroup TEXT,"
        "profession TEXT,"
        "facebookUrl TEXT,"
        "instagramUrl TEXT,"
        "twitterUrl TEXT,"
        "otherDetails TEXT,"
        "chouseNo TEXT,"
        "chouseNoV1 TEXT,"
        "isDuplicate BOOLEAN,"
        "isDead BOOLEAN,"
        "isVisited BOOLEAN,"
        "hasVoted BOOLEAN"
        ")");
  }

  Future<void> createBoothTable(Database db) async {
    await db.execute("CREATE TABLE booths ("
        "partNo INTEGER,"
        "partNameEn TEXT,"
        "partNameV1 TEXT,"
        "tahsilNameEn TEXT,"
        "tahsilNameV1 TEXT,"
        "psbuildingNameEn TEXT,"
        "psbuildingNo INTEGER,"
        "psbuildingNameV1 TEXT"
        ")");
  }

  // voters table work
  Future<int?> insertVoters(Voters voters) async {
    Database? db = await instance.database;
    var raw = await db?.insert(
      _TABLE_VOTERS,
      voters.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
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

  Future<List<Voters>?> getAllVoters(int limit,int off,String mandal,String boothId,String search,String filterSearchBy) async {
    List<Voters>? listItem = List<Voters>.empty(growable: true);
    final db = await database;
    try {

      String whereArgs = "";
      String searchBy = "";

      if(search.isNotEmpty)
      {
        if(filterSearchBy == "Name-Regular Search")
        {
          searchBy = "fullNameEn";
        }
        else  if(filterSearchBy == "SRNO")
        {
          searchBy = "fullNameEn";
        }
        else  if(filterSearchBy == "CardNo")
        {
          searchBy = "epicNo";
        }
        else  if(filterSearchBy == "MobileNo")
        {
          searchBy = "mobileNo";
        }
        else if(filterSearchBy == "Name-Match Case")
        {
          searchBy = "fullNameEn";
        }
      }

      if(mandal.isEmpty && boothId.isEmpty)
      {
        if(searchBy.toString().trim().isNotEmpty)
        {
          whereArgs = " WHERE " + searchBy + " like '%" +search+ "%' " ;
        }
        else
        {
          whereArgs = "";
        }

      }
      else if(mandal.isNotEmpty && boothId.isNotEmpty)
      {
        if(searchBy.toString().trim().isNotEmpty)
        {
          whereArgs = " WHERE tahsilNameEn = '$mandal' And partNameEn = '$boothId' And " + searchBy + " like '%" +search+ "%' " ;
        }
        else
        {
          whereArgs = " WHERE tahsilNameEn = '$mandal' AND partNameEn = '$boothId' ";
        }
      }
      else if(mandal.isNotEmpty && boothId.isEmpty)
      {
        if(searchBy.toString().trim().isNotEmpty)
        {
            whereArgs = " WHERE tahsilNameEn = '$mandal' And " + searchBy + " like '%" +search+ "%' " ;
        }
        else
        {
            whereArgs = " WHERE tahsilNameEn = '$mandal'";
        }
      }
      else if(mandal.isEmpty && boothId.isNotEmpty)
      {
        if(searchBy.toString().trim().isNotEmpty)
        {
          whereArgs = " WHERE partNameEn = '$boothId' And " + searchBy + " like '%" +search+ "%' " ;
        }
        else
        {
          whereArgs = " WHERE partNameEn = '$boothId'";
        }
      }

      if(whereArgs.isEmpty)
      {
          var response = await db?.rawQuery('SELECT * FROM voters LIMIT $limit OFFSET $off');
          if(response !=null)
          {
            listItem = response.map((c) => Voters.fromJson(c)).toList();
          }
          else
          {
            listItem = List<Voters>.empty(growable: true);
          }
      }
      else
      {
          String query = 'SELECT * FROM voters $whereArgs LIMIT $limit OFFSET $off';
          print("<><> Query Data :: " + query);
          var response = await db?.rawQuery(query);
          if(response !=null)
          {
            listItem = response.map((c) => Voters.fromJson(c)).toList();
          }
          else
          {
            listItem = List<Voters>.empty(growable: true);
          }
      }

    } catch (e) {
      print(e);
      listItem = List<Voters>.empty(growable: true);
    }
    return listItem;
  }

  Future<int?> deleteVoterData() async {
    Database? db = await instance.database;
    await db?.execute("DROP TABLE IF EXISTS voters");
    createVotersTable(db!);
    return null;
  }

  // booth table work
  Future<int?> insertBooth(Parts parts) async {
    Database? db = await instance.database;
    var raw = await db?.insert(
      _TABLE_BOOTHS,
      parts.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<int?> getCountBooth() async {
    //database connection
    Database? db = await instance.database;
    var x = await db?.rawQuery('SELECT COUNT (*) from booths');
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

  Future<int?> deleteBoothData() async {
    Database? db = await instance.database;
    await db?.execute("DROP TABLE IF EXISTS booths");
    createBoothTable(db!);
    return null;
  }

  Future<List<String>?> getAllMandal() async {
    List<String>? listItem = List<String>.empty(growable: true);
    try {
      final db = await database;
      var response = await db?.rawQuery('SELECT DISTINCT tahsilNameEn FROM voters ORDER BY tahsilNameEn');
      if(response !=null)
      {
        int count = response.length;
        for (int i = 0; i < count; i++) {
          if(checkValidString(response[i]['tahsilNameEn'].toString()).toString().isNotEmpty)
            {
              if(checkValidString(response[i]['tahsilNameEn'].toString()) != "0")
              {
                listItem.add(response[i]['tahsilNameEn'].toString());
              }
            }
        }
      }
      else
      {
        listItem = List<String>.empty(growable: true);
      }
    } catch (e) {
      print(e);
      listItem = List<String>.empty(growable: true);
    }
    return listItem;
  }

  Future<List<String>?> getAllBooth(String mandal) async {
    List<String>? listItem = List<String>.empty(growable: true);
    try {
      final db = await database;
      if(mandal.isNotEmpty && mandal != "All Mandal")
        {
          String whereArgs = " WHERE tahsilNameEn = '$mandal'";
          var response = await db?.rawQuery("SELECT DISTINCT partNameEn FROM voters $whereArgs ORDER BY partNameEn");
          if(response !=null)
          {
            int count = response.length;
            for (int i = 0; i < count; i++) {
              if(checkValidString(response[i]['partNameEn'].toString()).toString().isNotEmpty)
              {
                if(checkValidString(response[i]['partNameEn'].toString()) != "0")
                {
                  listItem.add(response[i]['partNameEn'].toString());
                }
              }
            }
          }
          else
          {
            listItem = List<String>.empty(growable: true);
          }
        }
      else
        {
          var response = await db?.rawQuery('SELECT DISTINCT partNameEn FROM voters ORDER BY partNameEn');
          if(response !=null)
          {
            int count = response.length;
            for (int i = 0; i < count; i++) {
              if(checkValidString(response[i]['partNameEn'].toString()).toString().isNotEmpty)
              {
                if(checkValidString(response[i]['partNameEn'].toString()) != "0")
                {
                  listItem.add(response[i]['partNameEn'].toString());
                }
              }
            }
          }
          else
          {
            listItem = List<String>.empty(growable: true);
          }
        }
    } catch (e) {
      print(e);
      listItem = List<String>.empty(growable: true);
    }
    return listItem;
  }

  Future<int?> deleteAllTableData() async {
    await deleteVoterData();
 //   await deleteBoothData();
    return null;
  }
}
