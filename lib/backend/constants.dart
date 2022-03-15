import 'package:flutter/material.dart';

import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

final String version = 'v1.03';

var pixelRatio = window.devicePixelRatio;
//Size in physical pixels
var physicalScreenSize = window.physicalSize;
var physicalWidth = physicalScreenSize.width;
var physicalHeight = physicalScreenSize.height;

//Size in logical pixels
var logicalScreenSize = window.physicalSize / pixelRatio;
var logicalWidth = logicalScreenSize.width;
var logicalHeight = logicalScreenSize.height;

Color primaryMavi = Color(0xff7BBDFF);
Color errorRenk = Colors.redAccent[700];
Color setBac = Colors.white;
Color basRenk = Color(0xff737373);
Color buttonRenk = Colors.grey[100];
Color recRenk = Colors.black54;
Color scafRenk = Colors.grey[300];
Color contRenk = Color(0xffffffff);
Color txtButRenk = primaryMavi;
Color fillRenk = primaryMavi;
final String foodReference =
    'U.S. Department of Agriculture, Agricultural Research Service. FoodData Central, 2021. fdc.nal.usda.gov.';

final weightUnit = 'kg'; // kg, lbs
final lengthUnit = 'cm'; // cm, inch
final energyUnit = 'kcal'; // kcal = 4.184 kJ
final portionUnit = 'g'; // g, oz

final TextStyle hintStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.w500,
  fontFamily: 'Montserrat',
  color: Color(0xff979797),
);

final TextStyle style = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.w500,
  fontFamily: 'Montserrat',
  color: Color(0xff444444),
);
final TextStyle autoStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.w500,
  fontFamily: 'Montserrat',
  color: Color(0xff979797),
);
final TextStyle topStyle = TextStyle(
  decoration: TextDecoration.none,
  fontSize: 30,
  fontFamily: "Montserrat",
  color: Color(0xff878585),
  fontWeight: FontWeight.w700,
);

final TextStyle hintStyle2 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w500,
  fontFamily: 'Montserrat',
  color: Color(0xff979797),
);
final TextStyle style2 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w500,
  fontFamily: 'Montserrat',
  color: Color(0xff444444),
);
final TextStyle hintStyle3 = TextStyle(
  fontSize: 23,
  fontWeight: FontWeight.w500,
  fontFamily: 'Montserrat',
  color: Color(0xff979797),
);
final TextStyle style3 = TextStyle(
  fontSize: 23,
  fontWeight: FontWeight.w500,
  fontFamily: 'Montserrat',
  color: Color(0xff444444),
);

final List<DateTime> daysList = [
  (DateTime.now()),
  DateTime.now().subtract(const Duration(days: 1)),
  DateTime.now().subtract(const Duration(days: 2)),
  DateTime.now().subtract(const Duration(days: 3)),
  DateTime.now().subtract(const Duration(days: 4)),
  DateTime.now().subtract(const Duration(days: 5)),
  DateTime.now().subtract(const Duration(days: 6)),
];

class User {
  final String userName;
  final String gender;
  final int userAge;
  final int userWeight;
  final int userHeight;
  final double userFatPerc;
  final String af;

  User({
    this.userName,
    this.gender,
    this.userAge,
    this.userWeight,
    this.userHeight,
    this.userFatPerc,
    this.af,
  });
}

class Meal {
  final String id;
  final String name;
  final String date;
  final double carb;
  final double protein;
  final double fat;
  final double cal;

  Meal(
      {this.id,
      this.date,
      this.carb,
      this.protein,
      this.fat,
      this.cal,
      this.name});
}

class Goal {
  final String id;
  final double calGoal;
  final double carbGoal;
  final double proteinGoal;
  final double fatGoal;

  Goal({
    this.id,
    this.calGoal,
    this.carbGoal,
    this.proteinGoal,
    this.fatGoal,
  });
}

class DayStat {
  final String date;
  final double totalCarb;
  final double totalProtein;
  final double totalFat;
  final double totalCal;

  DayStat({
    this.date,
    this.totalCarb,
    this.totalProtein,
    this.totalFat,
    this.totalCal,
  });
}

class ThemeHandler extends ChangeNotifier {
  bool isDark = false;
  bool perm2Not = false;

  getDark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isDark') == null) {
      prefs.setBool('isDark', false);
    }
    isDark = prefs.getBool('isDark');

    if (prefs.getBool('perm2Not') == null) {
      prefs.setBool('perm2Not', true);
    }
    perm2Not = prefs.getBool('perm2Not');
  }

  Future<void> changeTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isDark == true) {
      isDark = false;
      prefs.setBool('isDark', false);
    } else {
      isDark = true;
      prefs.setBool('isDark', true);
    }
    notifyListeners();
  }

  Future<void> changePerm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (perm2Not == true) {
      perm2Not = false;
      prefs.setBool('perm2Not', false);
    } else {
      perm2Not = true;
      prefs.setBool('perm2Not', true);
    }
    notifyListeners();
  }
}
