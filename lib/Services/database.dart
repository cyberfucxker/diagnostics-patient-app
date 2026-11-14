import 'dart:io';

import 'package:diagnostics_patient/Models/local_package_detail_model.dart';
import 'package:diagnostics_patient/Models/local_user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = 'AddToCart.db';
  static final _databaseseversion = 1;

  /// User Table
  // Table Name
  static final userTable = 'userTable';
  // Table Field Name
  static final utId = 'id';
  static final utUserId = 'userId';
  static final utUserName = 'userName';
  static final utUserGender = 'userGender';
  static final utUserAge = 'userAge';
  static final utUserRelation = 'userRelation';


  /// Package Detail Table
  // Table Name
  static final packageDetailTable = 'packageDetailTable';
  // Table Field Name
  static final pdtId = 'id';
  static final pdtUserId = 'packageMemberId';
  static final pdtPackageId = 'packageId';
  static final pdtPackageType = 'packageType';
  static final pdtPackageName = 'packageName';
  static final pdtPackageMrp = 'packageMrp';
  static final pdtPackagePrice = 'packagePrice';
  static final pdtPackageParameters = 'packageParameters';
  static final pdtPackageDiscount = 'packageDiscount';

  static Database? _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseseversion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    /// User Table Create
    await db.execute('''
      CREATE TABLE $userTable (
        $utId INTEGER PRIMARY KEY,
        $utUserId INTEGER NOT NULL,
        $utUserName TEXT NOT NULL,      
        $utUserGender TEXT NOT NULL,      
        $utUserAge TEXT NOT NULL,      
        $utUserRelation TEXT NOT NULL      
      )
      ''');

    /// Detail Package
    await db.execute('''
      CREATE TABLE $packageDetailTable (
        $pdtId INTEGER PRIMARY KEY,
        $pdtUserId INTEGER NOT NULL,
        $pdtPackageId INTEGER NOT NULL,
        $pdtPackageType INTEGER NOT NULL,      
        $pdtPackageName TEXT NOT NULL,      
        $pdtPackageMrp INTEGER NOT NULL,      
        $pdtPackagePrice INTEGER NOT NULL,
        $pdtPackageParameters TEXT NOT NULL,      
        $pdtPackageDiscount TEXT NOT NULL      
      )
      ''');
  }

  /// Insert in Database

  Future<int> insertUserDetail(Map<String,dynamic> row) async{
    Database db = await instance.database;
    return await db.insert(userTable, row);
  }

  Future<int> insertPackageDetail(Map<String,dynamic> row) async{
    Database db = await instance.database;
    return await db.insert(packageDetailTable, row);
  }

  /// Get All User Detail List

  Future<List<Map<String,dynamic>>> userQueryAll() async{
    Database db = await instance.database;
    return await db.query(userTable);
  }

  Future<List<Map<String,dynamic>>> packageQueryAll() async{
    Database db = await instance.database;
    return await db.query(packageDetailTable);
  }

  Future<List<LocalUserModel>> userModelQueryAll() async{
    Database db = await instance.database;
    final List<Map<String,dynamic>> queryResult = await db.query(userTable);
    return queryResult.map((e) => LocalUserModel.fromJson(e)).toList();
  }

  Future<List<LocalPackageModel>> packageModelQueryAll() async{
    Database db = await instance.database;
    final List<Map<String,dynamic>> queryResult = await db.query(packageDetailTable);
    return queryResult.map((e) => LocalPackageModel.fromJson(e)).toList();
  }



  // Future<List<User>> retrieveUsers() async {
  //   final List<Map<String, Object?>> queryResult = await db.query('users');
  //   return queryResult.map((e) => User.fromMap(e)).toList();
  // }

  /// Check user have or not

  Future<List> checkUser(uid) async{
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $userTable WHERE $utUserId="$uid"');
  }

  Future<List> checkPackageExist({required uid,required packageId,required packageType}) async{
    print('user id ${uid} and package id ${packageId} and package type is $packageType');
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $packageDetailTable WHERE $pdtUserId="$uid" AND $pdtPackageId="$packageId" AND $pdtPackageType="$packageType"');
  }

  /// Delete All Data From Database

  Future deletePackageFromCart({required uid,required packageId,required packageType}) async{
    Database db = await instance.database;
    return await db.rawQuery('DELETE FROM $packageDetailTable WHERE $pdtUserId="$uid" AND $pdtPackageId="$packageId" AND $pdtPackageType="$packageType"');
  }

}
