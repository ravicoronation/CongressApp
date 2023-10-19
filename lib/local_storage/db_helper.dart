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
  static const _DATA_BASE_VERSION = 8;
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
        "hasVoted BOOLEAN,"
        "total_count INTEGER,"
        "colorCode INTEGER"
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


 /* Future<int?> insertVoters(Voters voters) async {
    Database? db = await instance.database;
    var raw = await db?.insert(
      _TABLE_VOTERS,
      voters.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }*/


  // voters table work
  insertVoters(List<Voters> voters) async {
    Database? db = await instance.database;
    await db?.transaction((txn) async {
      Batch batch = txn.batch();
      for (var voter in voters)
      {
        voter.totalCount = 0;
        batch.insert(_TABLE_VOTERS, voter.toJson(),conflictAlgorithm: ConflictAlgorithm.replace);
      }
      batch.commit();
    });
  }

  //update voter work
  updateVoter(Voters voter) async {
    Database? db = await instance.database;
    var response = await db?.update(_TABLE_VOTERS, voter.toJson(),
        where: "id = ?", whereArgs: [voter.id]);
    return response;
  }

  //get single voter details
  Future<Voters> getVotersWithId(int id) async {
    Database? db = await instance.database;
    var response = await db?.query(_TABLE_VOTERS, where: "id = ?", whereArgs: [id]);
    if(response !=null)
      {
        return response.isNotEmpty ? Voters.fromJson(response.first) : Voters();
      }
    else
      {
        return Voters();
      }
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

  Future<List<Voters>?> getAllVoters(int limit,int off, String boothId,String search,String filterSearchBy,
      String vistedVoterFilter) async {
    List<Voters>? listItem = List<Voters>.empty(growable: true);
    final db = await database;
    try {

      String whereArgs = "";
      String searchBy = "";
      String isVisited = "";

      if(vistedVoterFilter.isNotEmpty)
      {
          if(vistedVoterFilter == "Visited Voters")
            {
              isVisited = "1";
            }
          else if(vistedVoterFilter == "Non-Visited Voters")
            {
              isVisited = "0";
            }
          else
          {
            isVisited = "";
          }
        }
      else
      {
          isVisited = "";
      }

      if(search.isNotEmpty)
      {
        if(filterSearchBy == "Name-Regular Search")
        {
          searchBy = "fullNameEn";
        }
        else  if(filterSearchBy == "SRNO")
        {
          searchBy = "slnoinpart";
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

      if(boothId.isEmpty && isVisited.isEmpty)
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
      else if(boothId.isNotEmpty && isVisited.isNotEmpty)
      {
        if(searchBy.toString().trim().isNotEmpty)
        {
          whereArgs = " WHERE partNameEn = '$boothId' And isVisited = '$isVisited' And " + searchBy + " like '%" +search+ "%' " ;
        }
        else
        {
          whereArgs = " WHERE partNameEn = '$boothId' AND isVisited = '$isVisited' ";
        }
      }
      else if(boothId.isNotEmpty && isVisited.isEmpty)
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
      else if(boothId.isEmpty && isVisited.isNotEmpty)
      {
        if(searchBy.toString().trim().isNotEmpty)
        {
          whereArgs = " WHERE isVisited = '$isVisited' And " + searchBy + " like '%" +search+ "%' " ;
        }
        else
        {
          whereArgs = " WHERE isVisited = '$isVisited'";
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


  Future<List<String>?> getAllBooth() async {
    List<String>? listItem = List<String>.empty(growable: true);
    try {
      final db = await database;
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
    } catch (e) {
      print(e);
      listItem = List<String>.empty(growable: true);
    }
    return listItem;
  }

  Future<List<Voters>?> getAllVotersFilterTypeWise(int limit,int off, String boothId,String search,String filterType)
  async {
    List<Voters>? listItem = List<Voters>.empty(growable: true);
    final db = await database;
    try {

      String whereArgs = "";
      String searchBy = "";
      String filterTypeParam = "";

      if(filterType == "House No Wise")
      {
        filterTypeParam = "chouseNo";
        searchBy = "chouseNo";
      }
      else if(filterType == "Address Wise")
      {
        filterTypeParam = "sectionNameEn";
        searchBy = "sectionNameEn";
      }
      else if(filterType == "Family Wise")
      {
        filterTypeParam = "chouseNo";
        searchBy = "chouseNo";
      }
      else if(filterType == "Duplicate Voters")
      {
        filterTypeParam = "isDuplicate";
        searchBy = "isDuplicate";
      }
      else
      {
        filterTypeParam = "";
        searchBy= "";
      }

      if(search.toString().trim().isNotEmpty)
      {
        whereArgs = " WHERE partNameEn = '$boothId' And " + searchBy + " like '%" +search+ "%' " ;
      }
      else if(boothId.toString().trim().isNotEmpty)
      {
        whereArgs = " WHERE partNameEn = '$boothId' ";
      }
      else
      {
        whereArgs = "";
      }

      if(filterType == "Family Wise")
        {
          if(whereArgs.isEmpty)
          {
            var response = await db?.rawQuery('SELECT *, COUNT (*) as total_count FROM voters GROUP BY $filterTypeParam ORDER BY total_count DESC LIMIT $limit OFFSET $off');
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
            String query = 'SELECT *, COUNT (*) as total_count FROM voters $whereArgs GROUP BY $filterTypeParam ORDER BY total_count DESC LIMIT $limit OFFSET $off';
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

        }
      else
        {
          if(whereArgs.isEmpty)
          {
            var response = await db?.rawQuery('SELECT *, COUNT (*) as total_count FROM voters GROUP BY $filterTypeParam LIMIT $limit OFFSET $off');
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
            String query = 'SELECT *, COUNT (*) as total_count FROM voters $whereArgs GROUP BY $filterTypeParam LIMIT $limit OFFSET $off';
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
        }
    } catch (e) {
      print(e);
      listItem = List<Voters>.empty(growable: true);
    }
    return listItem;
  }


  Future<List<Voters>?> getAllVotersFilterTypeAge(int limit,int off,
      String boothId,String search,String fromAge,String toAge) async {
    List<Voters>? listItem = List<Voters>.empty(growable: true);
    final db = await database;
    try {

      String whereArgs = "";
      String searchBy = "fullNameEn";

      if(fromAge.isEmpty && toAge.isEmpty)
      {
          whereArgs = " WHERE partNameEn = '$boothId' ";
      }
      else if(fromAge.isNotEmpty && toAge.isNotEmpty)
      {
        whereArgs = " WHERE partNameEn = '$boothId' And age >= $fromAge And age <= $toAge ";
      }
      else if(fromAge.isNotEmpty)
      {
        whereArgs = " WHERE partNameEn = '$boothId' And age >= $fromAge ";
      }
      else if(toAge.isNotEmpty)
      {
        whereArgs = " WHERE partNameEn = '$boothId' And age <= $toAge ";
      }

      if(search.toString().trim().isNotEmpty)
      {
        whereArgs = "$whereArgs And $searchBy like '%$search%' " ;
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

  Future<int?> deleteAllTableData() async {
    await deleteVoterData();
 //   await deleteBoothData();
    return null;
  }


  Future<List<Voters>?> getAllVotersBySearch(int limit,int off,String searchName,String searchCard) async {
    List<Voters>? listItem = List<Voters>.empty(growable: true);
    final db = await database;
    try {

      String whereArgs = "";
      String searchBy = "";

      if(searchName.isNotEmpty)
      {
        searchBy = "fullNameEn";
      }
      else if(searchCard.isNotEmpty)
      {
        searchBy = "epicNo";
      }
      else
      {
        searchBy = "";
      }

      if(searchBy.toString().trim().isNotEmpty)
      {
        if(searchName.isNotEmpty)
        {
          whereArgs = " WHERE " + searchBy + " like '%" +searchName+ "%' " ;
        }
        else
        {
          whereArgs = " WHERE " + searchBy + " like '%" +searchCard+ "%' " ;
        }
      }
      else
      {
        whereArgs = "";
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

  Future<num?> getAllVotersFilterTypeColor(String boothId,String colorCode)
  async {
    num? count = 0;
    final db = await database;
    try {

      String whereArgs = "";
      whereArgs = " WHERE partNameEn = '$boothId' And colorCode = '$colorCode' ";
      String query = 'SELECT *, COUNT (*) as total_count FROM voters $whereArgs';
      print("<><> Query Data :: " + query);
      var response = await db?.rawQuery(query);
      if(response !=null)
      {
        int countRes = response.length;
        for (int i = 0; i < countRes; i++) {
          count = response[i]['total_count'] as num?;
        }
      }
      else
      {
        count = 0;
      }
    } catch (e) {
      print(e);
      count = 0;
    }
    return count;
  }

  Future<List<Voters>?> getAllVoterFormFilterValue(int limit,int off, String search,String filterType,
      String filterValue,String title,String boothId) async {
    List<Voters>? listItem = List<Voters>.empty(growable: true);
    final db = await database;
    try {

      String whereArgs = "";
      String searchBy = "fullNameEn";

      if(title == "Color List")
      {
        whereArgs = " WHERE partNameEn = '$boothId' And colorCode = '$filterValue' ";
      }
      else if(title == "House No Wise")
      {
        whereArgs = " WHERE partNameEn = '$boothId' And chouseNo = '$filterValue' ";
      }
      else if(title == "Address Wise")
      {
        whereArgs = " WHERE partNameEn = '$boothId' And sectionNameEn = '$filterValue' ";
      }
      else if(title == "Family Wise")
      {
        whereArgs = " WHERE partNameEn = '$boothId' And chouseNo = '$filterValue' ";
      }
      else if(title == "Duplicate Voters")
      {
        whereArgs = " WHERE partNameEn = '$boothId' Or fullNameEn = '$filterValue' ";
      }

      if(search.toString().trim().isNotEmpty)
      {
        whereArgs = whereArgs + " And " + searchBy + " like '%" +search+ "%' " ;
      }

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

    } catch (e) {
      print(e);
      listItem = List<Voters>.empty(growable: true);
    }
    return listItem;
  }
}
