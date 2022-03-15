import 'dart:async';

import 'package:caloriemeter/backend/goals_provider.dart';
import 'package:caloriemeter/backend/tdee_calc.dart';

import 'package:caloriemeter/main_components/resetComplete.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../main_components/createProfile.dart';
import '../backend/constants.dart';
import '../backend/profile_provider.dart';
import '../home.dart';
import '../widgets/appBarTitle.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  bool _isProfileVisible = false;
  bool _isGoalsVisible = false;
  bool _isSettingsVisible = false;
  bool _isSwitched = true;
  bool _isbodyfatVis = false;
  TabController _controller;
  final _profileCustController = ScrollController();
  final _profileOpenController = ScrollController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 4, vsync: this);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _profileCustController.dispose();
    _profileOpenController.dispose();
    super.dispose();
  }

  void _toggleProfile() {
    setState(() {
      _isProfileVisible = !_isProfileVisible;
      _isGoalsVisible = false;
      _isSettingsVisible = false;
    });
  }

  void _toggleSettings() {
    setState(() {
      _isSettingsVisible = !_isSettingsVisible;
      _isGoalsVisible = false;
      _isProfileVisible = false;
    });
  }

  void _toggleGoals() {
    setState(() {
      _isGoalsVisible = !_isGoalsVisible;
      _isProfileVisible = false;
      _isSettingsVisible = false;
      Timer(Duration(milliseconds: 200), () {
        try {
          _profileOpenController.animateTo(
              _profileOpenController.position.maxScrollExtent,
              duration: Duration(milliseconds: 200),
              curve: Curves.decelerate);
        } catch (e) {
          //print(e.toString());
        }
      });
    });
  }

  void _showBodyFat() {
    if (_isbodyfatVis == false) {
      Timer(Duration(milliseconds: 200), () {
        try {
          _profileCustController.animateTo(
              _profileCustController.position.maxScrollExtent,
              duration: Duration(milliseconds: 200),
              curve: Curves.decelerate);
        } catch (e) {
          //print(e.toString());
        }
      });
    }

    setState(() {
      _isbodyfatVis = true;
    });
  }

  void _hideBodyFat() {
    setState(() {
      _isbodyfatVis = false;
    });
  }

  final _customizeProfileController = GlobalKey<FormState>();
  final _customizeGoalController = GlobalKey<FormState>();

  var _updatedProfile = User(
    gender: " ",
    userAge: 0,
    userFatPerc: 0,
    userHeight: 0,
    userName: " ",
    userWeight: 0,
    af: "None",
  );
  var _updatedGoal = Goal(
    id: "0",
    calGoal: 0,
    carbGoal: 0,
    proteinGoal: 0,
    fatGoal: 0,
  );

  void _updateProfile() {
    final isValid = _customizeProfileController.currentState.validate();
    if (!isValid) {
      return;
    }
    _customizeProfileController.currentState.save();

    Provider.of<Users>(context, listen: false)
        .updateProfileDb(_updatedProfile)
        .then((value) => {
              _toggleProfile(),
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 5),
                  content: Text(
                    'Your profile has been updated successfully!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
                  ))),
            })
        .catchError((error) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: Text("There is something wrong."),
                  content: Text("Your profile couldn't updated."),
                  actions: [
                    TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ]));
    });
  }

  void _resetProfile() {
    Provider.of<Users>(context, listen: false)
        .resetProfileDb()
        .then((value) => {_resetMeals()})
        .catchError((error) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: Text("There is something wrong."),
                  content: Text("Your profile couldn't reset."),
                  actions: [
                    TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ]));
    });
  }

  void _resetMeals() {
    Provider.of<Meals>(context, listen: false)
        .resetMealsDb()
        .then((value) => {_resetGoals()})
        .catchError((error) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: Text("There is something wrong."),
                  content: Text("Your meals couldn't reset."),
                  actions: [
                    TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ]));
    });
  }

  void _resetGoals() {
    Provider.of<Meals>(context, listen: false)
        .resetGoalsDb()
        .then((value) => {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => ResetPage()),
                (Route<dynamic> route) => false,
              ),
            })
        .catchError((error) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: Text("There is something wrong."),
                  content: Text("Your goals couldn't reset."),
                  actions: [
                    TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ]));
    });
  }

  void _updateGoal() {
    final isValid = _customizeGoalController.currentState.validate();
    if (!isValid) {
      return;
    }
    _customizeGoalController.currentState.save();
    Provider.of<Meals>(context, listen: false)
        .updateGoalDb(_updatedGoal)
        .then((value) => {
              _toggleGoals(),
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 5),
                  content: Text(
                    'Your diet goal has been updated successfully!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
                  ))),
            })
        .catchError((error) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: Text("There is something wrong."),
                  content: Text("Your goals couldn't updated."),
                  actions: [
                    TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ]));
    });
  }

  void _autoGoalUp(tdee, diet) {
    setState(() {
      _updatedGoal = Goal(
        id: _updatedGoal.id,
        calGoal: tdee,
        carbGoal: diet[0],
        proteinGoal: diet[1],
        fatGoal: diet[2],
      );
    });
    Provider.of<Meals>(context, listen: false)
        .updateGoalDb(_updatedGoal)
        .then((value) => {
              _toggleGoals(),
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 5),
                  content: Text(
                    'Your diet goal has been updated successfully!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
                  ))),
            })
        .catchError((error) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: Text("There is something wrong."),
                  content: Text("Your goals couldn't updated."),
                  actions: [
                    TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ]));
    });
  }

  List<bool> isSelected = [false, true];
  String _dropdownValue;
  String _dropafValue;
  String _dietGoal;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<Users>(context);
    final theme = Provider.of<ThemeHandler>(context);
    final dummy = user.users[0];
    Calculator calc = Calculator();
    final double tdee = calc.tdeeCalc(
      dummy.gender,
      dummy.userWeight,
      dummy.userHeight,
      dummy.userAge,
      dummy.af,
      dummy.userFatPerc,
    );
    final double dietTdee = calc.calcDietCal(_dietGoal, tdee);
    final balancedDiet = calc.balancedCalc(dietTdee);
    final lowFatDiet = calc.lowFatCalc(dietTdee);
    final lowCarbDiet = calc.lowCarbCalc(dietTdee);
    final highProtDiet = calc.highProteinCalc(dietTdee);

    return Scaffold(
      backgroundColor: scafRenk,
      appBar: AppBar(
        leading: BackButton(color: basRenk),
        toolbarHeight: 75,
        backgroundColor: setBac,
        title: AppBarTitle(),
      ),
      body: SingleChildScrollView(
        controller: _profileOpenController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.03),
              InkWell(
                onTap: _toggleProfile,
                child: Column(
                  children: [
                    Text(
                      "Customize your profile",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 30,
                        color: basRenk,
                      ),
                    ),
                    Divider(color: basRenk, height: size.height * 0.02),
                  ],
                ),
              ),
              AnimatedContainer(
                curve: Curves.decelerate,
                duration: Duration(milliseconds: 250),
                height: _isProfileVisible ? 650 : 0.0,
                width: size.width * 0.9,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[600],
                        blurRadius: 40.0,
                        offset: Offset(0, 15),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xff707070)),
                    color: contRenk,
                  ),
                  child: SingleChildScrollView(
                    controller: _profileCustController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15),
                      child: Form(
                        key: _customizeProfileController,
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: "${dummy.userName}",
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: errorRenk),
                                helperStyle: TextStyle(color: basRenk),
                                hintText: 'Name',
                                hintStyle: hintStyle3,
                                focusColor: basRenk,
                              ),
                              style: style3.copyWith(color: basRenk),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Name cannot be empty.';
                                }
                                if (value.length > 12 || value.length < 2) {
                                  return 'Length of the name must be in the range of 2-12.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _updatedProfile = User(
                                  gender: _updatedProfile.gender,
                                  userAge: _updatedProfile.userAge,
                                  userFatPerc: _updatedProfile.userFatPerc,
                                  userHeight: _updatedProfile.userHeight,
                                  userName: value.toString(),
                                  userWeight: _updatedProfile.userWeight,
                                  af: _updatedProfile.af,
                                );
                              },
                            ),
                            SizedBox(height: 15),
                            Container(
                              width: size.width * 0.8,
                              child: DropdownButtonFormField<String>(
                                hint: Text(
                                  'Gender',
                                  style: hintStyle3.copyWith(color: basRenk),
                                ),
                                value: _dropdownValue,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: errorRenk),
                                  helperStyle: TextStyle(color: basRenk),
                                  hintStyle: hintStyle3,
                                  focusColor: basRenk,
                                ),
                                icon: const Icon(
                                  Icons.arrow_downward,
                                  color: Colors.grey,
                                ),
                                iconSize: 24,
                                elevation: 16,
                                dropdownColor: contRenk,
                                style: style3,
                                validator: (value) =>
                                    value == null ? 'Field required' : null,
                                onChanged: (String value) {
                                  setState(() {
                                    _dropdownValue = value;
                                    _updatedProfile = User(
                                      gender: value.toString(),
                                      userAge: _updatedProfile.userAge,
                                      userFatPerc: _updatedProfile.userFatPerc,
                                      userHeight: _updatedProfile.userHeight,
                                      userName: _updatedProfile.userName,
                                      userWeight: _updatedProfile.userWeight,
                                      af: _updatedProfile.af,
                                    );
                                  });
                                },
                                items: <String>[
                                  'Male',
                                  'Female',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: SingleChildScrollView(
                                      physics: NeverScrollableScrollPhysics(),
                                      child: Column(
                                        children: [
                                          Text(value,
                                              style: style2.copyWith(
                                                  color: basRenk)),
                                          Divider(color: Colors.grey[800]),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: size.width * 0.8,
                              child: DropdownButtonFormField<String>(
                                hint: Text('Activity Factor',
                                    style: hintStyle3.copyWith(color: basRenk)),
                                value: _dropafValue,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: errorRenk),
                                  helperStyle: TextStyle(color: basRenk),
                                  hintStyle: hintStyle3,
                                  focusColor: basRenk,
                                ),
                                icon: const Icon(
                                  Icons.arrow_downward,
                                  color: Colors.grey,
                                ),
                                dropdownColor: contRenk,
                                iconSize: 24,
                                // decoration:
                                //     InputDecoration(border: InputBorder.none),
                                elevation: 16,
                                style: style3,
                                isExpanded: true,
                                //isDense: true,
                                validator: (value) =>
                                    value == null ? 'Field required' : null,
                                onChanged: (String value) {
                                  setState(() {
                                    _dropafValue = value;
                                    _updatedProfile = User(
                                      gender: _updatedProfile.gender,
                                      userAge: _updatedProfile.userAge,
                                      userFatPerc: _updatedProfile.userFatPerc,
                                      userHeight: _updatedProfile.userHeight,
                                      userName: _updatedProfile.userName,
                                      userWeight: _updatedProfile.userWeight,
                                      af: value.toString(),
                                    );
                                  });
                                },
                                items: <String>[
                                  'Sedentary',
                                  'Exercise 1-3 times/week',
                                  'Exercise 4-5 times/week',
                                  'Daily exercise or intense exercise 3-4 times/week',
                                  'Intense exercise 6-7 times/week',
                                  'Very intense exercise daily, or physical job',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: SingleChildScrollView(
                                      physics: NeverScrollableScrollPhysics(),
                                      child: Column(
                                        children: [
                                          Text(value,
                                              style: style2.copyWith(
                                                  color: basRenk)),
                                          Divider(color: Colors.grey[800]),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              initialValue: "${dummy.userAge}",
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: errorRenk),
                                helperStyle: TextStyle(color: basRenk),
                                hintText: 'Age',
                                hintStyle: hintStyle3,
                                focusColor: Color(0xff444444),
                              ),
                              maxLength: 2,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    new RegExp('[0-9]')),
                              ],
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              style: style3.copyWith(color: basRenk),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Age cannot be empty.';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                if (double.parse(value) < 15) {
                                  return 'Age must be a valid number.';
                                }
                                if (double.parse(value) > 99) {
                                  return 'Age must be a valid number.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _updatedProfile = User(
                                  gender: _updatedProfile.gender,
                                  userAge: int.parse(value),
                                  userFatPerc: _updatedProfile.userFatPerc,
                                  userHeight: _updatedProfile.userHeight,
                                  userName: _updatedProfile.userName,
                                  userWeight: _updatedProfile.userWeight,
                                  af: _updatedProfile.af,
                                );
                              },
                            ),
                            TextFormField(
                              initialValue: "${dummy.userWeight}",
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: errorRenk),
                                helperStyle: TextStyle(color: basRenk),
                                hintText: 'Weight (kg)',
                                hintStyle: hintStyle3,
                                focusColor: Color(0xff444444),
                              ),
                              maxLength: 3,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    new RegExp('[0-9]')),
                              ],
                              keyboardType: TextInputType.number,
                              style: style3.copyWith(color: basRenk),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Weight cannot be empty.';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                if (double.parse(value) < 35) {
                                  return 'Weight must be a valid number.';
                                }
                                if (double.parse(value) > 200) {
                                  return 'Weight must be a valid number.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _updatedProfile = User(
                                  gender: _updatedProfile.gender,
                                  userAge: _updatedProfile.userAge,
                                  userFatPerc: _updatedProfile.userFatPerc,
                                  userHeight: _updatedProfile.userHeight,
                                  userName: _updatedProfile.userName,
                                  userWeight: int.parse(value),
                                  af: _updatedProfile.af,
                                );
                              },
                            ),
                            TextFormField(
                              initialValue: "${dummy.userHeight}",
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: errorRenk),
                                helperStyle: TextStyle(color: basRenk),
                                hintText: 'Height (cm)',
                                hintStyle: hintStyle3,
                                focusColor: Color(0xff444444),
                              ),
                              maxLength: 3,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    new RegExp('[0-9]')),
                              ],
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              style: style3.copyWith(color: basRenk),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Height cannot be empty.';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                if (double.parse(value) < 140) {
                                  return 'Height must be a valid number.';
                                }
                                if (double.parse(value) > 230) {
                                  return 'Height must be a valid number.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _updatedProfile = User(
                                  gender: _updatedProfile.gender,
                                  userAge: _updatedProfile.userAge,
                                  userFatPerc: _updatedProfile.userFatPerc,
                                  userHeight: int.parse(value),
                                  userName: _updatedProfile.userName,
                                  userWeight: _updatedProfile.userWeight,
                                  af: _updatedProfile.af,
                                );
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: size.width * .7,
                                  child: TextFormField(
                                    initialValue: dummy.userFatPerc == 0
                                        ? null
                                        : "${dummy.userFatPerc.toInt()}",
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(color: errorRenk),
                                      helperStyle: TextStyle(color: basRenk),
                                      hintText:
                                          'Body Fat Percentage (optional)',
                                      hintStyle: hintStyle2.copyWith(
                                        color: basRenk,
                                        fontSize: 20,
                                      ),
                                      focusColor: Color(0xff444444),
                                    ),
                                    maxLength: 2,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          new RegExp('[0-9]')),
                                    ],
                                    keyboardType: TextInputType.number,
                                    style: style3.copyWith(color: basRenk),
                                    validator: (value) {
                                      if (value.isNotEmpty) {
                                        if (double.parse(value) <= 0) {
                                          return 'Please enter a valid number';
                                        }
                                        if (double.parse(value) > 40) {
                                          return 'Body fat is too high.';
                                        }
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      if (value.isEmpty) {
                                        _updatedProfile = User(
                                          gender: _updatedProfile.gender,
                                          userAge: _updatedProfile.userAge,
                                          userFatPerc: 0.0,
                                          userHeight:
                                              _updatedProfile.userHeight,
                                          userName: _updatedProfile.userName,
                                          userWeight:
                                              _updatedProfile.userWeight,
                                          af: _updatedProfile.af,
                                        );
                                      } else {
                                        _updatedProfile = User(
                                          gender: _updatedProfile.gender,
                                          userAge: _updatedProfile.userAge,
                                          userFatPerc: double.parse(value),
                                          userHeight:
                                              _updatedProfile.userHeight,
                                          userName: _updatedProfile.userName,
                                          userWeight:
                                              _updatedProfile.userWeight,
                                          af: _updatedProfile.af,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Tooltip(
                                  message:
                                      'Don\'t know your body fat amount? Press this button to calcute!',
                                  textStyle: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Montserrat',
                                    color: Colors.white60,
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Shimmer.fromColors(
                                    period: Duration(milliseconds: 750),
                                    baseColor: basRenk,
                                    highlightColor: primaryMavi,
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.info_outline_rounded,
                                          size: 40,
                                          color: Colors.grey[600],
                                        ),
                                        onPressed: () {
                                          _showBodyFat();
                                        }),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 30),
                            AnimatedOpacity(
                              opacity: _isbodyfatVis ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 150),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                height: _isbodyfatVis ? size.height * 0.65 : 0,
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[500],
                                      blurRadius: 10.0,
                                      offset: Offset(0, 15),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey[500]),
                                  color: contRenk.withAlpha(250),
                                ),
                                child: SingleChildScrollView(
                                  physics: NeverScrollableScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, top: 15),
                                        child: ClipOval(
                                          child: Material(
                                            color: basRenk,
                                            child: InkWell(
                                              onTap: () => _hideBodyFat(),
                                              child: Icon(
                                                Icons.close_rounded,
                                                color: contRenk,
                                                size: 34,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      BodyFatCalculator(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            TextButton(
                              onPressed: () {
                                _updateProfile();
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              child: Container(
                                child: Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Montserrat',
                                    color: basRenk,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              InkWell(
                onTap: _toggleGoals,
                child: Column(
                  children: [
                    Text(
                      "Customize your goals",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 30,
                        color: basRenk,
                      ),
                    ),
                    Divider(color: basRenk, height: 25),
                  ],
                ),
              ),
              AnimatedContainer(
                curve: Curves.decelerate,
                duration: Duration(milliseconds: 250),
                height: _isGoalsVisible
                    ? (_isSwitched == false
                        ? 500
                        : _dietGoal == null
                            ? 200
                            : 750)
                    : 0.0,
                width: size.width * 0.9,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[600],
                        blurRadius: 40.0,
                        offset: Offset(0, 15),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xff707070)),
                    color: contRenk,
                  ),
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //     left: 15,
                        //     right: 15,
                        //     top: 10,
                        //   ),
                        //   child: Container(
                        //     color: Colors.grey[100],
                        //     child: ToggleButtons(
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsets.all(12.0),
                        //           child: Text(
                        //             "Manually",
                        //             style: TextStyle(
                        //               fontFamily: "Montserrat",
                        //               fontSize: 24,
                        //               color: Color(0xff878585),
                        //               fontWeight: FontWeight.w500,
                        //             ),
                        //           ),
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.all(12.0),
                        //           child: Text(
                        //             "Automatic",
                        //             style: TextStyle(
                        //               fontFamily: "Montserrat",
                        //               fontSize: 24,
                        //               color: Color(0xff878585),
                        //               fontWeight: FontWeight.w500,
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //       isSelected: isSelected,
                        //       onPressed: (int index) {
                        //         setState(() {
                        //           if (index == 0) {
                        //             _isSwitched = false;
                        //           }
                        //           if (index == 1) {
                        //             _isSwitched = true;
                        //           }
                        //           for (int indexBtn = 0;
                        //               indexBtn < isSelected.length;
                        //               indexBtn++) {
                        //             if (indexBtn == index) {
                        //               isSelected[indexBtn] = true;
                        //             } else {
                        //               isSelected[indexBtn] = false;
                        //             }
                        //           }
                        //         });
                        //       },
                        //     ),
                        //   ),
                        // ),
                        //SizedBox(height: 15),
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              child: Visibility(
                                visible: _isSwitched == false ? false : true,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: size.width * 0.8,
                                      child: DropdownButtonFormField<String>(
                                        hint: Text('Select Your Target',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Montserrat',
                                              color: basRenk,
                                            )),
                                        value: _dietGoal,
                                        icon: const Icon(
                                          Icons.arrow_downward,
                                          color: Colors.grey,
                                        ),
                                        dropdownColor: contRenk,
                                        iconSize: 24,
                                        elevation: 16,
                                        isDense: false,
                                        style: style3.copyWith(color: basRenk),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        isExpanded: true,
                                        validator: (value) => value == null
                                            ? 'Field required'
                                            : null,
                                        onChanged: (String value) {
                                          setState(() {
                                            _dietGoal = value;
                                          });
                                        },
                                        items: <String>[
                                          'Weight Loss (-0.5kg/week)',
                                          'Slight Weight Loss (-0.25kg/week)',
                                          'Maintain Weight',
                                          'Slight Weight Gain (+0.25kg/week)',
                                          'Weight Gain (+0.5kg/week)',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: SingleChildScrollView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    value,
                                                    style: TextStyle(
                                                      fontSize: 23,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Montserrat',
                                                      color: basRenk,
                                                    ),
                                                  ),
                                                  Divider(
                                                      color: Colors.grey[800]),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    _dietGoal == null
                                        ? SizedBox()
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Container(
                                                  width: size.width * 1.4,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[400],
                                                  ),
                                                  child: TabBar(
                                                    controller: _controller,
                                                    labelStyle: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      fontSize: 21,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    unselectedLabelStyle:
                                                        TextStyle(
                                                      fontFamily: "Montserrat",
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    enableFeedback: true,
                                                    tabs: [
                                                      Tab(
                                                        text: 'Balanced',
                                                      ),
                                                      Tab(
                                                        text: 'Low Fat',
                                                      ),
                                                      Tab(
                                                        text: 'Low Carb',
                                                      ),
                                                      FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Tab(
                                                          text: 'High Protein',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              PastaBar(
                                                bal: _selectedIndex == 0
                                                    ? balancedDiet
                                                    : _selectedIndex == 1
                                                        ? lowFatDiet
                                                        : _selectedIndex == 2
                                                            ? lowCarbDiet
                                                            : highProtDiet,
                                                dietTdee: dietTdee,
                                              ),
                                              SizedBox(height: 20),
                                              Container(
                                                height: 250,
                                                child: TabBarView(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  controller: _controller,
                                                  children: <Widget>[
                                                    GoalsList(
                                                      cal: dietTdee,
                                                      carb: balancedDiet[0],
                                                      protein: balancedDiet[1],
                                                      fat: balancedDiet[2],
                                                    ),
                                                    GoalsList(
                                                      cal: dietTdee,
                                                      carb: lowFatDiet[0],
                                                      protein: lowFatDiet[1],
                                                      fat: lowFatDiet[2],
                                                    ),
                                                    GoalsList(
                                                      cal: dietTdee,
                                                      carb: lowCarbDiet[0],
                                                      protein: lowCarbDiet[1],
                                                      fat: lowCarbDiet[2],
                                                    ),
                                                    GoalsList(
                                                      cal: dietTdee,
                                                      carb: highProtDiet[0],
                                                      protein: highProtDiet[1],
                                                      fat: highProtDiet[2],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 15,
                                                ),
                                                child: Text(
                                                  "This app only estimates the optimal amount for a person. Consulting to a dietician is always the best way to diet.",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontSize: 18,
                                                    color: basRenk,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: TextButton(
                                                  onPressed: () {
                                                    switch (_controller.index) {
                                                      case 0:
                                                        _autoGoalUp(dietTdee,
                                                            balancedDiet);
                                                        break;
                                                      case 1:
                                                        _autoGoalUp(dietTdee,
                                                            lowFatDiet);
                                                        break;
                                                      case 2:
                                                        _autoGoalUp(dietTdee,
                                                            lowCarbDiet);
                                                        break;
                                                      case 3:
                                                        _autoGoalUp(dietTdee,
                                                            highProtDiet);
                                                        break;
                                                      default:
                                                        showDialog(
                                                            context: context,
                                                            builder: (ctx) =>
                                                                AlertDialog(
                                                                    title: Text(
                                                                        "There is something wrong."),
                                                                    content: Text(
                                                                        "Your goals couldn't updated.\n You have not selected any diet yet."),
                                                                    actions: [
                                                                      TextButton(
                                                                          child: Text(
                                                                              'OK'),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          }),
                                                                    ]));
                                                    }
                                                  },
                                                  style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        side: BorderSide(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    child: Text(
                                                      'Save',
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily:
                                                            'Montserrat',
                                                        color: basRenk,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: size.height * 0.05),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _isSwitched == false ? true : false,
                              child: Container(
                                height: 415,
                                width: size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: contRenk,
                                  borderRadius: BorderRadius.circular(20),
                                  //border: Border.all(color: Color(0xffffffff)),
                                ),
                                child: SingleChildScrollView(
                                  physics: NeverScrollableScrollPhysics(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 15),
                                    child: Form(
                                      key: _customizeGoalController,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            decoration: InputDecoration(
                                              errorStyle:
                                                  TextStyle(color: errorRenk),
                                              helperStyle:
                                                  TextStyle(color: basRenk),
                                              hintText:
                                                  'Calorie Goal ($energyUnit)',
                                              hintStyle: hintStyle3.copyWith(
                                                  color: basRenk),
                                              focusColor: basRenk,
                                            ),
                                            maxLength: 4,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  new RegExp('[0-9]')),
                                            ],
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            style:
                                                style3.copyWith(color: basRenk),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Calorie cannot be empty.';
                                              }
                                              if (double.tryParse(value) ==
                                                  null) {
                                                return 'Please enter a valid number';
                                              }
                                              if (double.parse(value) < 0) {
                                                return 'Calorie must be a valid number.';
                                              }
                                              if (double.parse(value) > 9999) {
                                                return 'Calorie must be a valid number.';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _updatedGoal = Goal(
                                                id: _updatedGoal.id,
                                                calGoal: double.parse(value),
                                                carbGoal: _updatedGoal.carbGoal,
                                                proteinGoal:
                                                    _updatedGoal.proteinGoal,
                                                fatGoal: _updatedGoal.fatGoal,
                                              );
                                            },
                                          ),
                                          TextFormField(
                                            decoration: InputDecoration(
                                              errorStyle:
                                                  TextStyle(color: errorRenk),
                                              helperStyle:
                                                  TextStyle(color: basRenk),
                                              hintText:
                                                  'Carbonhydrate Goal (g)',
                                              hintStyle: hintStyle3.copyWith(
                                                  color: basRenk),
                                              focusColor: Color(0xff444444),
                                            ),
                                            maxLength: 3,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  new RegExp('[0-9]')),
                                            ],
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            style:
                                                style3.copyWith(color: basRenk),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Carbonhydrate cannot be empty.';
                                              }
                                              if (double.tryParse(value) ==
                                                  null) {
                                                return 'Please enter a valid number';
                                              }
                                              if (double.parse(value) < 0) {
                                                return 'Carbonhydrate must be a valid number.';
                                              }
                                              if (double.parse(value) > 1000) {
                                                return 'Carbonhydrate must be a valid number.';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _updatedGoal = Goal(
                                                id: _updatedGoal.id,
                                                calGoal: _updatedGoal.calGoal,
                                                carbGoal: double.parse(value),
                                                proteinGoal:
                                                    _updatedGoal.proteinGoal,
                                                fatGoal: _updatedGoal.fatGoal,
                                              );
                                            },
                                          ),
                                          TextFormField(
                                            decoration: InputDecoration(
                                              errorStyle:
                                                  TextStyle(color: errorRenk),
                                              helperStyle:
                                                  TextStyle(color: basRenk),
                                              hintText: 'Protein Goal (g)',
                                              hintStyle: hintStyle3.copyWith(
                                                  color: basRenk),
                                              focusColor: Color(0xff444444),
                                            ),
                                            maxLength: 3,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  new RegExp('[0-9]')),
                                            ],
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            style:
                                                style3.copyWith(color: basRenk),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Height cannot be empty.';
                                              }
                                              if (double.tryParse(value) ==
                                                  null) {
                                                return 'Please enter a valid number';
                                              }
                                              if (double.parse(value) < 0) {
                                                return 'Protein must be a valid number.';
                                              }
                                              if (double.parse(value) > 500) {
                                                return 'Protein must be a valid number.';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _updatedGoal = Goal(
                                                id: _updatedGoal.id,
                                                calGoal: _updatedGoal.calGoal,
                                                carbGoal: _updatedGoal.carbGoal,
                                                proteinGoal:
                                                    double.parse(value),
                                                fatGoal: _updatedGoal.fatGoal,
                                              );
                                            },
                                          ),
                                          TextFormField(
                                            decoration: InputDecoration(
                                              errorStyle:
                                                  TextStyle(color: errorRenk),
                                              helperStyle:
                                                  TextStyle(color: basRenk),
                                              hintText: 'Fat Goal (g)',
                                              hintStyle: hintStyle3.copyWith(
                                                  color: basRenk),
                                              focusColor: Color(0xff444444),
                                            ),
                                            maxLength: 3,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  new RegExp('[0-9]')),
                                            ],
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            style:
                                                style3.copyWith(color: basRenk),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Fat cannot be empty.';
                                              }
                                              if (double.tryParse(value) ==
                                                  null) {
                                                return 'Please enter a valid number';
                                              }
                                              if (double.parse(value) < 0) {
                                                return 'Fat must be a valid number.';
                                              }
                                              if (double.parse(value) > 500) {
                                                return 'Fat must be a valid number.';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _updatedGoal = Goal(
                                                id: _updatedGoal.id,
                                                calGoal: _updatedGoal.calGoal,
                                                carbGoal: _updatedGoal.carbGoal,
                                                proteinGoal:
                                                    _updatedGoal.proteinGoal,
                                                fatGoal: double.parse(value),
                                              );
                                            },
                                          ),
                                          SizedBox(height: size.height * 0.01),
                                          TextButton(
                                            onPressed: () {
                                              _updateGoal();
                                            },
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  side: BorderSide(
                                                    color: basRenk,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            child: Container(
                                              child: Text(
                                                'Save Changes',
                                                style: TextStyle(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Montserrat',
                                                  color: basRenk,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Center(
                          heightFactor: 2,
                          //padding: const EdgeInsets.only(bottom: 18.0),
                          child: Visibility(
                            visible: _isSwitched == true ? true : false,
                            replacement: TextButton(
                              child: Text(
                                'go back',
                                style: style.copyWith(
                                    color: txtButRenk,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isSwitched = true;
                                });
                              },
                            ),
                            child: TextButton(
                              child: Text(
                                'let me set my macros',
                                style: style.copyWith(
                                  color: txtButRenk,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isSwitched = false;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              InkWell(
                onTap: _toggleSettings,
                child: Column(
                  children: [
                    Text(
                      "More Settings",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 30,
                        color: basRenk,
                      ),
                    ),
                    Divider(color: basRenk, height: size.height * 0.03),
                  ],
                ),
              ),
              AnimatedContainer(
                curve: Curves.decelerate,
                duration: Duration(milliseconds: 250),
                height: _isSettingsVisible ? size.height * 0.35 : 0.0,
                width: size.width * 0.9,
                child: AnimatedOpacity(
                  opacity: _isSettingsVisible ? 1.0 : 0.3,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[600],
                          blurRadius: 40.0,
                          offset: Offset(0, 15),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(0xff707070)),
                      color: contRenk,
                    ),
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: basRenk),
                              color: contRenk,
                            ),
                            child: TextButton(
                                child: Text(
                                  "reset your profile",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 26,
                                    color: basRenk,
                                  ),
                                ),
                                onPressed: () => {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text("Are you sure?",
                                              style: TextStyle(fontSize: 21)),
                                          content: Text(
                                              "Do you want to reset your profile?",
                                              style: TextStyle(fontSize: 18)),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                              child: Text("No",
                                                  style:
                                                      TextStyle(fontSize: 21)),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _resetProfile();
                                              },
                                              child: Text("Yes",
                                                  style:
                                                      TextStyle(fontSize: 21)),
                                            ),
                                          ],
                                        ),
                                      )
                                    }),
                          ),
                        ),
                        Divider(height: 15, color: basRenk),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: basRenk),
                              color: contRenk,
                            ),
                            child: TextButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "change theme",
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 26,
                                      color: basRenk,
                                    ),
                                  ),
                                  theme.isDark == true
                                      ? Icon(Icons.wb_sunny,
                                          color: basRenk, size: 34)
                                      : Icon(Icons.nightlight_round,
                                          color: basRenk, size: 34)
                                ],
                              ),
                              onPressed: () {
                                if (theme.isDark == false) {
                                  setState(() {
                                    Color deg = Colors.grey[900];
                                    primaryMavi = deg;
                                    scafRenk = Colors.black87;
                                    contRenk = Colors.grey[600];
                                    basRenk = Colors.white60;
                                    buttonRenk = Colors.grey[800];
                                    recRenk = basRenk;
                                    setBac = primaryMavi;
                                    fillRenk = Colors.white60;
                                    errorRenk = Colors.white;
                                    txtButRenk = Color(0xff80a8d1);
                                    Theme.of(context).copyWith(
                                      primaryColor: deg,
                                      highlightColor: deg,
                                      splashColor: deg,
                                      hoverColor: deg,
                                      buttonColor: deg,
                                      focusColor: deg,
                                    );
                                  });
                                } else {
                                  primaryMavi = Color(0xff7BBDFF);
                                  errorRenk = Colors.redAccent[700];
                                  setBac = Colors.white;
                                  basRenk = Color(0xff737373);
                                  buttonRenk = Colors.grey[100];
                                  recRenk = Colors.black54;
                                  scafRenk = Colors.grey[300];
                                  contRenk = Color(0xffffffff);
                                  fillRenk = primaryMavi;
                                  txtButRenk = primaryMavi;
                                  Theme.of(context).copyWith(
                                    primaryColor: Color(0xff7BBDFF),
                                    highlightColor: Color(0xff7BBDFF),
                                    splashColor: Color(0xff7BBDFF),
                                    hoverColor: Color(0xff7BBDFF),
                                    buttonColor: Color(0xff7BBDFF),
                                    focusColor: Color(0xff7BBDFF),
                                  );
                                }
                                theme.changeTheme();

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  duration: Duration(seconds: 3),
                                  content: Text(
                                    'theme has changed',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, fontFamily: 'Montserrat'),
                                  ),
                                  backgroundColor: Colors.black54,
                                ));
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                  (Route<dynamic> route) => false,
                                );
                              },
                            ),
                          ),
                        ),
                        Divider(height: 15, color: basRenk),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: basRenk),
                              color: contRenk,
                            ),
                            child: TextButton(
                              child: Text(
                                theme.perm2Not == true
                                    ? "notifications: enabled"
                                    : "notifications: disabled",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 26,
                                  color: basRenk,
                                ),
                              ),
                              onPressed: () => {
                                theme.changePerm(),
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  duration: Duration(seconds: 3),
                                  content: Text(
                                    'notification settings has changed',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, fontFamily: 'Montserrat'),
                                  ),
                                  backgroundColor: Colors.black54,
                                )),
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                  (Route<dynamic> route) => false,
                                ),
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoalsList extends StatelessWidget {
  const GoalsList({
    this.cal,
    this.carb,
    this.protein,
    this.fat,
    Key key,
  }) : super(key: key);

  final cal;
  final carb;
  final protein;
  final fat;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Calorie: ${cal.toInt()} kcal",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 24,
            color: basRenk,
            fontWeight: FontWeight.w500,
          ),
        ),
        Divider(height: 25, color: Colors.grey),
        Text(
          "Carbonhydrate: ${carb.ceil()} g",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 24,
            color: basRenk,
            fontWeight: FontWeight.w500,
          ),
        ),
        Divider(height: 25, color: Colors.grey),
        Text(
          "Protein: ${protein.ceil()} g",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 24,
            color: basRenk,
            fontWeight: FontWeight.w500,
          ),
        ),
        Divider(height: 25, color: Colors.grey),
        Text(
          "Fat: ${fat.ceil()} g",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 24,
            color: basRenk,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class PastaBar extends StatelessWidget {
  PastaBar({
    Key key,
    this.dietTdee,
    this.bal,
  }) : super(key: key);

  final double dietTdee;
  final bal;

// default --> fontsize: 28,
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double wid = size.width * 0.82;
    return Container(
      height: 40,
      width: wid,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Color(0xff707070)),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 550),
            curve: Curves.decelerate,
            height: 40,
            width: wid * (bal[0] * 4 / dietTdee),
            decoration: BoxDecoration(
              color: Colors.blue[300],
              borderRadius: BorderRadius.circular(1),
              border: Border.all(color: Color(0xff707070).withOpacity(0.5)),
            ),
            child: Center(child: Text("C", style: style)),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 550),
            curve: Curves.decelerate,
            height: 40,
            width: wid * (bal[1] * 4 / dietTdee),
            decoration: BoxDecoration(
              color: Colors.blue[200],
              borderRadius: BorderRadius.circular(1),
              border: Border.all(color: Color(0xff707070).withOpacity(0.5)),
            ),
            child: Center(child: Text("P", style: style)),
          ),
          SizedBox(width: wid * (bal[1] * 4 / dietTdee) / 4),
          Text("F", style: style),
        ],
      ),
    );
  }
}
