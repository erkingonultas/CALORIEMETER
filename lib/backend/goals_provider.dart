import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
//import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:math';
import 'constants.dart';

class Meals with ChangeNotifier {
  int _currentGoal = 0;
  List<Goal> _recentGoals = [
    Goal(
      id: "0",
      calGoal: 1650,
      carbGoal: 200,
      proteinGoal: 155,
      fatGoal: 120,
    ),
  ];
  Database _database2;
  Future<Database> get database2 async {
    if (_database2 != null) return _database2;
    _database2 = await initDb2();
    return _database2;
  }

  initDb2() async {
    return await openDatabase(join(await getDatabasesPath(), 'goals.db'),
        onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE goals (
        id TEXT PRIMARY KEY, calGoal REAL, carbGoal REAL, proteinGoal REAL, fatGoal REAL
      )
       ''');
    }, version: 1);
  }

  List<Goal> get recentGoals {
    return [..._recentGoals];
  }

  int get currentGoal {
    return _currentGoal;
  }

  Future<void> fetchAndSetGoals() async {
    final db = await database2;

    final dataList = await db.query('goals').catchError((e) {
      print(e.toString());
    });

    if (dataList.length != 0) {
      _recentGoals = dataList
          .map(
            (item) => Goal(
              id: item['id'],
              calGoal: item['calGoal'],
              carbGoal: item['carbGoal'],
              proteinGoal: item['proteinGoal'],
              fatGoal: item['fatGoal'],
            ),
          )
          .toList();
    }
    notifyListeners();
  }

  Future<void> updateGoalDb(Goal updatedGoal) async {
    final db = await database2;
    for (var i = 0; i < _recentGoals.length; i++) {
      db.rawDelete('''DELETE FROM goals WHERE id = ?''', [_recentGoals[i].id]);
    }
    _recentGoals.clear();

    db.rawInsert('''
      INSERT INTO goals (
        id , calGoal , carbGoal , proteinGoal , fatGoal 
      ) VALUES (?, ?, ?, ?, ?)
       ''', [
      updatedGoal.id,
      updatedGoal.calGoal,
      updatedGoal.carbGoal,
      updatedGoal.proteinGoal,
      updatedGoal.fatGoal,
    ]);
    List<Goal> _loadedGoals = [];
    _loadedGoals.add(updatedGoal);
    _recentGoals = _loadedGoals;
    notifyListeners();
  }

  Future<void> resetGoalsDb() async {
    final db = await database2;
    if (_recentGoals.length != 0) {
      for (var i = 0; i < _recentGoals.length; i++) {
        db.rawDelete(
            '''DELETE FROM goals WHERE id = ?''', [_recentGoals[i].id]);
      }
    }
  }

//####################################                     ###########################################
  List<Meal> _searchedMeals = [];
  List<Meal> _searchedSurveyMeals = [];
  List<Meal> _recentMeals = [];
  List<Meal> _todayMeals = [];
  List<Meal> _getMeals = [];
  List<Meal> _foodNames = [];
  double _getCal = 0;
  double _getCarb = 0;
  double _getProtein = 0;
  double _getFat = 0;
  var _scheduledEndTime;

  String get scheduledEndTime {
    final ln = recentMeals.length;
    if (recentMeals.isNotEmpty) {
      final lastDate = DateTime.parse(recentMeals[ln - 1].date);
      if (DateTime.now().difference(lastDate).inHours < 22) {
        // Streak gidiyo
        _scheduledEndTime = lastDate.add(Duration(hours: 23)).toString();
      } else if (17 > DateTime.now().hour.toInt() &&
          DateTime.now().hour.toInt() > 7) {
        _scheduledEndTime = DateTime.now().add(Duration(hours: 4)).toString();
      } else {
        _scheduledEndTime = DateTime.now()
            .add(Duration(
                hours: DateTime.now().difference(lastDate).inHours ~/ 7))
            .toString();
      }
    } else {
      if (17 > DateTime.now().hour.toInt() && DateTime.now().hour.toInt() > 7) {
        _scheduledEndTime = DateTime.now().add(Duration(hours: 4)).toString();
      } else {
        _scheduledEndTime = DateTime.now().add(Duration(hours: 10)).toString();
      }
    }
    return _scheduledEndTime;
  }

  int _streak;
  IconData _streakIcon;

  Future<void> setStreak() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 0
    if (prefs.getInt('dbstreak') == null) {
      prefs.setInt('dbstreak', _streak);
    } else {
      // 1
      if (_streak == 0) {
        prefs.setInt('dbstreak', _streak);
        _streakIcon = Icons.event_busy_outlined;
      } else if (_streak < prefs.getInt('dbstreak') &&
          DateTime.now().difference(daysFilled[daysFilled.length - 1]).inDays ==
              1) {
        _streak = prefs.getInt('dbstreak');
        _streakIcon = Icons.event_busy_outlined;
      } else if (_streak < prefs.getInt('dbstreak') &&
          DateTime.now().difference(daysFilled[daysFilled.length - 1]).inDays >
              1) {
        prefs.setInt('dbstreak', _streak);
        _streakIcon = Icons.event_busy_outlined;
      } else if (_streak < prefs.getInt('dbstreak') &&
          DateTime.now().difference(daysFilled[daysFilled.length - 1]).inDays ==
              0) {
        prefs.setInt('dbstreak', _streak);
        _streakIcon = Icons.event_available_rounded;
      }
      // 2
      else if (_streak > prefs.getInt('dbstreak')) {
        prefs.setInt('dbstreak', _streak);
        _streakIcon = Icons.event_available_rounded;
      }
      // 3
      else if (streak == prefs.getInt('dbstreak') && streak == 0) {
        prefs.setInt('dbstreak', _streak);
        _streakIcon = Icons.event_busy_outlined;
      } else if (streak == prefs.getInt('dbstreak') &&
          DateTime.now().difference(daysFilled[daysFilled.length - 1]).inDays ==
              0) {
        prefs.setInt('dbstreak', _streak);
        _streakIcon = Icons.event_available_rounded;
      } else if (streak == prefs.getInt('dbstreak') &&
          DateTime.now().difference(daysFilled[daysFilled.length - 1]).inDays !=
              0) {
        prefs.setInt('dbstreak', _streak);
        _streakIcon = Icons.event_busy_outlined;
      }
    }
    print(' dbstreak: ${prefs.getInt('dbstreak')}');

    notifyListeners();
  }

  Future<void> getStreak() async {
    // _streakIcon = Icons.event_busy_outlined;
    _streak = 0;
    // List<DateTime> liste = [
    //   DateTime.now(),
    //   DateTime.now().subtract(const Duration(days: 1)),
    //   DateTime.now().subtract(const Duration(days: 2)),
    //   DateTime.now().subtract(const Duration(days: 3)),
    //   DateTime.now().subtract(const Duration(days: 4)),
    //   DateTime.now().subtract(const Duration(days: 5)),
    //   DateTime.now().subtract(const Duration(days: 6)),
    // ];

    print('uzunluk: ${daysFilled.length}');
    if (daysFilled.length == 0) {
      _streak = 0;
    } else if (daysFilled.length == 1) {
      if (DateTime.now().difference(daysFilled[0]).inDays == 1 ||
          DateTime.now().difference(daysFilled[0]).inDays == 0) {
        _streak = 1;
      }
    } else {
      if (DateTime.now().difference(daysFilled[daysFilled.length - 1]).inDays <=
          1) {
        for (var i = 0; i < daysFilled.length - 1; i++) {
          if (daysFilled[i + 1].difference(daysFilled[i]).inDays <= 1) {
            _streak++;
          }
          //  else if (daysFilled[i + 1].difference(daysFilled[i]).inDays > 1) {
          //   _streak = 0;
          // }
        }
      } else {
        _streak = 0;
      }
    }

    print(' streak: $_streak');
    setStreak();
  }

  int get streak {
    return _streak;
  }

  IconData get streakIcon {
    return _streakIcon;
  }

  Future<void> resetStreak() async {
    _streak = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('dbstreak', 0);
    notifyListeners();
  }

  List<Meal> get recentMeals {
    return [..._recentMeals];
  }

  List<Meal> get searchedMeals {
    return [..._searchedMeals];
  }

  List<Meal> get searchedSurveyMeals {
    return [..._searchedSurveyMeals];
  }

  List<Meal> get recieveMeals {
    return [..._getMeals];
  }

  List<Meal> get foodNames {
    _foodNames = [];
    for (var i = 0; i < recentMeals.length; i++) {
      _foodNames.add(recentMeals[i]);
    }
    final names = _foodNames.map((e) => e.name).toSet();
    _foodNames.retainWhere((element) => names.remove(element.name));
    return _foodNames;
  }

  deleteFoodName(Meal food) {
    _foodNames.remove(food);
    notifyListeners();
  }

  getMeals(day) {
    _getMeals.clear();

    if (recentMeals.length != 0) {
      for (var i = 0; i < recentMeals.length; i++) {
        if ("${day.toString().substring(0, 10)}" ==
            recentMeals[i].date.substring(0, 10)) {
          _getMeals.add(recentMeals[i]);
        }
      }
    }
  }

  getMacros(day) {
    _getCal = 0;
    _getCarb = 0;
    _getProtein = 0;
    _getFat = 0;
    for (Meal m in recentMeals) {
      if (m != null) {
        if ("${day.substring(0, 10)}" == m.date.substring(0, 10)) {
          _getCal += m.cal;
          _getCarb += m.carb;
          _getProtein += m.protein;
          _getFat += m.fat;
        }
      }
    }
  }

  double get getCal {
    return _getCal;
  }

  double get getCarb {
    return _getCarb;
  }

  double get getProtein {
    return _getProtein;
  }

  double get getFat {
    return _getFat;
  }

  List<Meal> get todayMeal {
    _todayMeals.clear();
    if (recentMeals.length != 0) {
      for (var i = 0; i < recentMeals.length; i++) {
        if (DateTime.now().toString().substring(0, 10) ==
            recentMeals[i].date.substring(0, 10)) {
          _todayMeals.add(recentMeals[i]);
        }
      }
    }
    return _todayMeals;
  }

  Meal findById(String id) {
    return _recentMeals.firstWhere((element) => element.id == id);
  }

  var rng = new Random();

  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  initDb() async {
    return await openDatabase(join(await getDatabasesPath(), 'caloriemeter.db'),
        onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE recentMeals (
        id TEXT PRIMARY KEY, name TEXT, date TEXT, carb REAL, protein REAL, fat REAL, cal REAL
      )
       ''');
    }, version: 1);
  }

  Future<void> addMeal2DB(Meal food, servingSize, servingQ) async {
    final db = await database;
    final newMeal = Meal(
      cal: (food.cal.toDouble() * servingSize * servingQ),
      carb: (food.carb.toDouble() * servingSize * servingQ),
      date: food.date,
      fat: (food.fat.toDouble() * servingSize * servingQ),
      id: (rng.nextInt(10000)).toString(),
      name: food.name,
      protein: (food.protein.toDouble() * servingSize * servingQ),
    );
    _recentMeals.add(newMeal);
    db.rawInsert('''
      INSERT INTO recentMeals (
        id, name, date, carb, protein, fat, cal
      ) VALUES (?, ?, ?, ?, ?, ?, ?)
       ''', [
      newMeal.id,
      newMeal.name,
      newMeal.date,
      newMeal.carb,
      newMeal.protein,
      newMeal.fat,
      newMeal.cal
    ]);
    notifyListeners();
  }

  Future<void> removeMeal(String id) async {
    final db = await database;
    final existingMealIndex =
        _recentMeals.indexWhere((element) => element.id == id);
    //var existingMeal = _recentMeals[existingMealIndex];
    _recentMeals.removeAt(existingMealIndex);
    notifyListeners();
    db.rawDelete('DELETE FROM recentMeals WHERE id = ?', [id]);
  }

  Future<void> fetchAndSetDB() async {
    final db = await database;

    final dataList = await db.query('recentMeals').catchError((e) {
      print(e.toString());
    });
    _recentMeals = dataList
        .map(
          (item) => Meal(
            id: item['id'],
            name: item['name'],
            date: item['date'],
            carb: item['carb'],
            protein: item['protein'],
            fat: item['fat'],
            cal: item['cal'],
          ),
        )
        .toList();
    notifyListeners();
  }

  Future searchFood(name) async {
    print('searching');
    const api_key = "SECRET_KEY";

    final url = Uri.https('api.nal.usda.gov', '/fdc/v1/foods/search', {
      'api_key': api_key,
      'query': name,
      'dataType': 'Survey (FNDDS), SR Legacy',
      'pageSize': '50',
    });
    try {
      final response = await http.get(url);

      final decodedResponse = json.decode(response.body);
      final List<Meal> _searchedList = [];
      final List<Meal> _searchedSurveyList = [];
      Meal _dummyMeal = Meal(
        name: "",
        cal: 0.0,
        carb: 0.0,
        fat: 0.0,
        protein: 0.0,
        date: DateTime.now().toString().substring(0, 19),
        id: (rng.nextInt(10000)).toString(),
      );

      for (var i = 0; i < decodedResponse['foods'].length; i++) {
        if (decodedResponse['foods'][i]['dataType'] == 'Survey (FNDDS)') {
          for (var foodNut in decodedResponse['foods'][i]['foodNutrients']) {
            //energy
            if (foodNut['nutrientId'] == 1008) {
              _dummyMeal = Meal(
                name: decodedResponse['foods'][i]['description'],
                cal: foodNut['value'].toDouble(),
                carb: _dummyMeal.carb,
                fat: _dummyMeal.fat,
                protein: _dummyMeal.protein,
                date: _dummyMeal.date,
                id: _dummyMeal.id,
              );
            }
            //carb
            if (foodNut['nutrientId'] == 1005) {
              _dummyMeal = Meal(
                name: decodedResponse['foods'][i]['description'],
                cal: _dummyMeal.cal,
                carb: foodNut['value'].toDouble(),
                fat: _dummyMeal.fat,
                protein: _dummyMeal.protein,
                date: _dummyMeal.date,
                id: _dummyMeal.id,
              );
            }
            //fat
            if (foodNut['nutrientId'] == 1004) {
              _dummyMeal = Meal(
                name: decodedResponse['foods'][i]['description'],
                cal: _dummyMeal.cal,
                carb: _dummyMeal.carb,
                fat: foodNut['value'].toDouble(),
                protein: _dummyMeal.protein,
                date: _dummyMeal.date,
                id: _dummyMeal.id,
              );
            }
            //protein
            if (foodNut['nutrientId'] == 1003) {
              _dummyMeal = Meal(
                name: decodedResponse['foods'][i]['description'],
                cal: _dummyMeal.cal,
                carb: _dummyMeal.carb,
                fat: _dummyMeal.fat,
                protein: foodNut['value'].toDouble(),
                date: _dummyMeal.date,
                id: _dummyMeal.id,
              );
            }
          }
          _searchedSurveyList.add(_dummyMeal);
        } else if (decodedResponse['foods'][i]['dataType'] == 'SR Legacy') {
          for (var foodNut in decodedResponse['foods'][i]['foodNutrients']) {
            //energy
            if (foodNut['nutrientId'] == 1008) {
              _dummyMeal = Meal(
                name: decodedResponse['foods'][i]['description'],
                cal: foodNut['value'].toDouble(),
                carb: _dummyMeal.carb,
                fat: _dummyMeal.fat,
                protein: _dummyMeal.protein,
                date: _dummyMeal.date,
                id: _dummyMeal.id,
              );
            }
            //carb
            if (foodNut['nutrientId'] == 1005) {
              _dummyMeal = Meal(
                name: decodedResponse['foods'][i]['description'],
                cal: _dummyMeal.cal,
                carb: foodNut['value'].toDouble(),
                fat: _dummyMeal.fat,
                protein: _dummyMeal.protein,
                date: _dummyMeal.date,
                id: _dummyMeal.id,
              );
            }
            //fat
            if (foodNut['nutrientId'] == 1004) {
              _dummyMeal = Meal(
                name: decodedResponse['foods'][i]['description'],
                cal: _dummyMeal.cal,
                carb: _dummyMeal.carb,
                fat: foodNut['value'].toDouble(),
                protein: _dummyMeal.protein,
                date: _dummyMeal.date,
                id: _dummyMeal.id,
              );
            }
            //protein
            if (foodNut['nutrientId'] == 1003) {
              _dummyMeal = Meal(
                name: decodedResponse['foods'][i]['description'],
                cal: _dummyMeal.cal,
                carb: _dummyMeal.carb,
                fat: _dummyMeal.fat,
                protein: foodNut['value'].toDouble(),
                date: _dummyMeal.date,
                id: _dummyMeal.id,
              );
            }
          }
          _searchedList.add(_dummyMeal);
        }
      }
      _searchedSurveyMeals = _searchedSurveyList;
      _searchedMeals = _searchedList;
      print("${_searchedSurveyList.length}, ${_searchedList.length}");
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  void clearSearch() {
    _searchedMeals.clear();
    _searchedSurveyMeals.clear();
  }

  Future<void> resetMealsDb() async {
    final db = await database;
    if (_recentMeals.length != 0) {
      for (var i = 0; i < _recentMeals.length; i++) {
        db.rawDelete(
            '''DELETE FROM recentMeals WHERE id = ?''', [_recentMeals[i].id]);
      }
      _recentMeals.clear();
      resetStreak();
    }
  }

  double get dailyCal {
    double _dailyCal = 0;
    for (Meal m in recentMeals) {
      if (m != null) {
        if (DateTime.now().toString().substring(0, 10) ==
            m.date.substring(0, 10)) {
          _dailyCal += m.cal;
        }
      }
    }
    return _dailyCal;
  }

  double get dailyCarb {
    double _dailyCarb = 0;
    for (Meal m in recentMeals) {
      if (m != null) {
        if (DateTime.now().toString().substring(0, 10) ==
            m.date.substring(0, 10)) {
          _dailyCarb += m.carb;
        }
      }
    }
    return _dailyCarb;
  }

  double get dailyProtein {
    double _dailyProtein = 0;
    for (Meal m in recentMeals) {
      if (m != null) {
        if (DateTime.now().toString().substring(0, 10) ==
            m.date.substring(0, 10)) {
          _dailyProtein += m.protein;
        }
      }
    }
    return _dailyProtein;
  }

  double get dailyFat {
    double _dailyFat = 0;
    for (Meal m in recentMeals) {
      if (m != null) {
        if (DateTime.now().toString().substring(0, 10) ==
            m.date.substring(0, 10)) {
          _dailyFat += m.fat;
        }
      }
    }
    return _dailyFat;
  }

  double get carb {
    double _carb = 0.0;
    for (Meal m in recentMeals) {
      if (m != null) {
        _carb += m.carb;
      }
    }
    return _carb;
  }

  double get cal {
    double _cal = 0;
    for (Meal m in recentMeals) {
      if (m != null) {
        _cal += m.cal;
      }
    }
    return _cal;
  }

  double get protein {
    double _prot = 0;
    for (Meal m in recentMeals) {
      if (m != null) {
        _prot += m.protein;
      }
    }
    return _prot;
  }

  double get fat {
    double _fat = 0;
    for (Meal m in recentMeals) {
      if (m != null) {
        _fat += m.fat;
      }
    }
    return _fat;
  }

  List get daysFilled {
    List _daysFilled = [];
    List _dateList = [];
    //double fir = 0;

    for (Meal m in recentMeals) {
      if (m != null) {
        _daysFilled.add(m.date.substring(0, 10));

        // for (var day in daysList) {
        //   fir = 0;
        //   if ("${day.toString().substring(0, 10)}" == m.date.substring(0, 10)) {
        //     fir += m.cal;
        //   }
        //   if (fir > 0 && !(_daysFilled.contains(day))) {
        //     _daysFilled.add(day);
        //   }
        // }
      }
    }
    _daysFilled = [
      ...{..._daysFilled}
    ];
    for (String day in _daysFilled) {
      _dateList.add(DateTime.parse(day));
    }
    return _dateList;
    //return _daysFilled;
  }

  List get getCalStats {
    List _calStats = [];
    double fir = 0;
    for (Meal m in recentMeals) {
      if (m != null) {
        for (var day in daysFilled) {
          if ("${day.toString().substring(0, 10)}" == m.date.substring(0, 10)) {
            fir += m.cal;
          }
          if (fir > 0 && !(_calStats.contains(fir))) {
            _calStats.add(fir);
          }
        }
      }
    }
    return _calStats;
  }
}

class Days with ChangeNotifier {
// (Meals().recentMeals[0].carb +
//           Meals().recentMeals[1].carb +
//           Meals().recentMeals[2].carb)

  List<DayStat> _recentDays = [
    DayStat(
      date: DateTime.now().toString(),
      totalCarb: Meals().carb,
      totalProtein: Meals().fat,
      totalFat: Meals().fat,
      totalCal: Meals().cal,
    ),
  ];
  List<DayStat> get recentDays {
    return [..._recentDays];
  }

  DayStat findById(String date) {
    return _recentDays.firstWhere((element) => element.date == date);
  }
}
