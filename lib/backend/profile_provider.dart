import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'constants.dart';

class Users with ChangeNotifier {
  bool isProfileExists = false;
  List<User> _users = [
    User(
      userName: " ",
      gender: "Male",
      userAge: 20,
      userWeight: 80,
      userHeight: 175,
      userFatPerc: 12,
      af: "None",
    )
  ];

  List<User> get users {
    return [..._users];
  }

  Database _profileDb;
  Future<Database> get profileDb async {
    if (_profileDb != null) return _profileDb;
    _profileDb = await initPDb();
    return _profileDb;
  }

  initPDb() async {
    return await openDatabase(
        join(await getDatabasesPath(), 'caloriemeter2.db'),
        onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE users (
        name TEXT PRIMARY KEY, gender TEXT, age INTEGER, weight INTEGER, height INTEGER, fatperc REAL, activityfactor TEXT
      )
       ''');
    }, version: 1);
  }

  Future<void> fetchAndSetUserDB() async {
    final db = await profileDb;

    final dataList = await db.query('users').catchError((e) {
      print(e.toString());
    });

    if (dataList.length != 0) {
      isProfileExists = true;
      _users = dataList
          .map(
            (item) => User(
              userName: item['name'],
              gender: item['gender'],
              userAge: item['age'],
              userWeight: item['weight'],
              userHeight: item['height'],
              userFatPerc: item['fatperc'],
              af: item['activityfactor'],
            ),
          )
          .toList();
    }

    notifyListeners();
  }

  Future<void> createProfile(User updatedUser) async {
    final db = await profileDb;

    db.rawInsert('''
      INSERT INTO users (
        name, gender, age, weight, height, fatperc, activityfactor
      ) VALUES (?, ?, ?, ?, ?, ?, ?)
       ''', [
      updatedUser.userName,
      updatedUser.gender,
      updatedUser.userAge,
      updatedUser.userWeight,
      updatedUser.userHeight,
      updatedUser.userFatPerc,
      updatedUser.af,
    ]);

    List<User> _loadedUsers = [];
    _loadedUsers.add(updatedUser);
    _users = _loadedUsers;
    notifyListeners();
  }

  Future<void> updateProfileDb(User updatedUser) async {
    final db = await profileDb;

    for (var i = 0; i < _users.length; i++) {
      db.rawDelete(
          '''DELETE FROM users WHERE name = ?''', [_users[i].userName]);
    }
    _users.clear();

    db.rawInsert('''
      INSERT INTO users (
        name, gender, age, weight, height, fatperc, activityfactor
      ) VALUES (?, ?, ?, ?, ?, ?, ?)
       ''', [
      updatedUser.userName,
      updatedUser.gender,
      updatedUser.userAge,
      updatedUser.userWeight,
      updatedUser.userHeight,
      updatedUser.userFatPerc,
      updatedUser.af,
    ]);

    List<User> _loadedUsers = [];
    _loadedUsers.add(updatedUser);
    _users = _loadedUsers;
    notifyListeners();
  }

  Future<void> resetProfileDb() async {
    final db = await profileDb;

    for (var i = 0; i < _users.length; i++) {
      db.rawDelete(
          '''DELETE FROM users WHERE name = ?''', [_users[i].userName]);
    }
    _users.clear();
  }
}
