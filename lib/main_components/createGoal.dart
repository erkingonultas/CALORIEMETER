import 'package:caloriemeter/backend/profile_provider.dart';
import 'package:caloriemeter/backend/tdee_calc.dart';
import 'package:caloriemeter/main_components/settings_page.dart';
import 'package:flutter/services.dart';

import '../backend/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../backend/goals_provider.dart';

import '../home.dart';
import '../widgets/appBarTitle.dart';

class CreateGoal extends StatefulWidget {
  static const String routeName = "/createGoal";
  @override
  _CreateGoalState createState() => _CreateGoalState();
}

class _CreateGoalState extends State<CreateGoal>
    with SingleTickerProviderStateMixin {
  final _customizeGoalController = GlobalKey<FormState>();
  TabController _controller;
  double energyUnitFactor = 1;
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
    setState(() {
      if (energyUnit == 'kJ') {
        energyUnitFactor = 4.184;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isSwitched = true;

  var _updatedGoal = Goal(
    id: "0",
    calGoal: 0,
    carbGoal: 0,
    proteinGoal: 0,
    fatGoal: 0,
  );

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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              ),
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 5),
                  content: Text(
                    'Your diet goal has been created successfully!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
                  ))),
            })
        .catchError((error) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: Text("There is something wrong."),
                  content: Text("Your goals cannot be created."),
                  actions: [
                    TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ]));
    });
  }

  void _updateGoal() {
    final isValid = _customizeGoalController.currentState.validate();
    if (!isValid) {
      return;
    }
    _customizeGoalController.currentState.save();
    showDialog(
      barrierColor: Colors.black.withOpacity(0.1),
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Please confirm", style: TextStyle(fontSize: 24)),
        content: Text("You can change your diet goal from the settings later.",
            style: TextStyle(fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("No", style: TextStyle(fontSize: 21)),
          ),
          TextButton(
            onPressed: () {
              Provider.of<Meals>(context, listen: false)
                  .updateGoalDb(_updatedGoal)
                  .then((value) => {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        ),
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text(
                              'Your diet goal has been created successfully!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Montserrat'),
                            ))),
                      })
                  .catchError((error) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("There is something wrong."),
                    content: Text("Your goals cannot be created."),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              });
            },
            child: Text("Yes", style: TextStyle(fontSize: 21)),
          ),
        ],
      ),
    );
  }

  List<bool> isSelected = [false, true];
  String _dietGoal;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<Users>(context);
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

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: scafRenk,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 75,
          backgroundColor: setBac,
          title: Center(child: AppBarTitle()),
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.01),
              Text(
                "Set Your Goals",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 34,
                  color: basRenk,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              AnimatedContainer(
                curve: Curves.decelerate,
                duration: Duration(milliseconds: 250),
                height: _isSwitched == false
                    ? size.height * 0.6
                    : _dietGoal == null
                        ? 250
                        : size.height * 0.65,
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
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
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
                        // SizedBox(height: 15),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                        style: style3,
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
                                                  vertical: 10,
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
                                              SizedBox(
                                                  height: size.height * 0.012),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _isSwitched == false ? true : false,
                              child: Container(
                                height: size.height * .5,
                                width: size.width * 0.9,
                                // decoration: BoxDecoration(
                                //   color: contRenk,
                                //   borderRadius: BorderRadius.circular(20),
                                //   border: Border.all(color: Color(0xffffffff)),
                                // ),
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
                                                return 'Protein cannot be empty.';
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              _isSwitched == false
                  ? Center(
                      child: TextButton(
                        onPressed: () {
                          _updateGoal();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(contRenk),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(
                                color: basRenk,
                              ),
                            ),
                          ),
                        ),
                        child: Container(
                          width: size.width * .25,
                          child: Text(
                            'Save',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat',
                              color: basRenk,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: TextButton(
                        onPressed: () {
                          switch (_controller.index) {
                            case 0:
                              _autoGoalUp(dietTdee, balancedDiet);
                              break;
                            case 1:
                              _autoGoalUp(dietTdee, lowFatDiet);
                              break;
                            case 2:
                              _autoGoalUp(dietTdee, lowCarbDiet);
                              break;
                            case 3:
                              _autoGoalUp(dietTdee, highProtDiet);
                              break;
                            default:
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                          title:
                                              Text("There is something wrong."),
                                          content: Text(
                                              "Your goals couldn't updated.\n You have not selected any diet yet."),
                                          actions: [
                                            TextButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                }),
                                          ]));
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(contRenk),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        child: Container(
                          width: size.width * .25,
                          child: Text(
                            'Save',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat',
                              color: basRenk,
                            ),
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
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Calorie: ${cal.ceil()}kcal",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 22,
            color: basRenk,
            fontWeight: FontWeight.w500,
          ),
        ),
        Divider(height: size.height * 0.01, color: basRenk),
        Text(
          "Carbonhydrate: ${carb.ceil()}g",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 22,
            color: basRenk,
            fontWeight: FontWeight.w500,
          ),
        ),
        Divider(height: size.height * 0.01, color: basRenk),
        Text(
          "Protein: ${protein.ceil()}g",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 22,
            color: basRenk,
            fontWeight: FontWeight.w500,
          ),
        ),
        Divider(height: size.height * 0.01, color: basRenk),
        Text(
          "Fat: ${fat.ceil()}g",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 22,
            color: basRenk,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Container(
//   color: contRenk,
//   child: ToggleButtons(
//     children: [
//       Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Text(
//           "Manually",
//           style: TextStyle(
//             fontFamily: "Montserrat",
//             fontSize: 22,
//             color: basRenk,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Text(
//           "Automatic",
//           style: TextStyle(
//             fontFamily: "Montserrat",
//             fontSize: 22,
//             color: basRenk,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     ],
//     isSelected: isSelected,
//     onPressed: (int index) {
//       setState(() {
//         if (index == 0) {
//           _isSwitched = false;
//         }
//         if (index == 1) {
//           _isSwitched = true;
//         }
//         for (int indexBtn = 0;
//             indexBtn < isSelected.length;
//             indexBtn++) {
//           if (indexBtn == index) {
//             isSelected[indexBtn] = true;
//           } else {
//             isSelected[indexBtn] = false;
//           }
//         }
//       });
//     },
//   ),
// ),
// SizedBox(height: size.height * 0.02),
// AnimatedContainer(
//   curve: Curves.decelerate,
//   duration: Duration(milliseconds: 250),
//   height: _isSwitched == false
//       ? size.height * 0.565
//       : size.height * 0.65,
//   width: size.width * 0.9,
//   child: Container(
//     decoration: BoxDecoration(
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey[600],
//           blurRadius: 40.0,
//           offset: Offset(0, 15),
//         ),
//       ],
//       borderRadius: BorderRadius.circular(20),
//       border: Border.all(color: basRenk),
//       color: contRenk,
//     ),
//     child: SingleChildScrollView(
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20.0,
//                 ),
//                 child: Visibility(
//                   visible: _isSwitched == false ? false : true,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment:
//                         MainAxisAlignment.spaceAround,
//                     children: [
//                       Container(
//                         width: size.width * 0.8,
//                         child: DropdownButtonFormField<String>(
//                           hint: Text(
//                             'Select your plan',
//                             style: hintStyle2.copyWith(
//                                 color: basRenk),
//                           ),
//                           value: _dietGoal,
//                           decoration: InputDecoration(
//                             errorStyle:
//                                 TextStyle(color: errorRenk),
//                             helperStyle:
//                                 TextStyle(color: basRenk),
//                             hintStyle: hintStyle3,
//                             focusColor: basRenk,
//                             border: InputBorder.none,
//                           ),
//                           icon: const Icon(
//                             Icons.arrow_downward,
//                             color: Colors.grey,
//                           ),
//                           iconSize: 24,
//                           elevation: 16,
//                           isDense: false,
//                           style: style2,
//                           isExpanded: true,
//                           validator: (value) => value == null
//                               ? 'Field required'
//                               : null,
//                           onChanged: (String value) {
//                             setState(() {
//                               _dietGoal = value;
//                             });
//                           },
//                           items: <String>[
//                             'Weight Loss (-0.5kg/week)',
//                             'Slight Weight Loss (-0.25kg/week)',
//                             'Maintain Weight',
//                             'Slight Weight Gain (+0.25kg/week)',
//                             'Weight Gain (+0.5kg/week)',
//                           ].map<DropdownMenuItem<String>>(
//                               (String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: SingleChildScrollView(
//                                 physics:
//                                     NeverScrollableScrollPhysics(),
//                                 child: Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       value,
//                                       style: TextStyle(
//                                         fontSize: 23,
//                                         fontWeight:
//                                             FontWeight.w600,
//                                         fontFamily: 'Montserrat',
//                                         color: Colors.black54,
//                                       ),
//                                     ),
//                                     Divider(
//                                         color: Colors.grey[800]),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Container(
//                           width: size.width * 1.4,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[400],
//                           ),
//                           child: TabBar(
//                             controller: _controller,
//                             labelStyle: TextStyle(
//                               fontFamily: "Montserrat",
//                               fontSize: 22,
//                               color: Colors.black,
//                               fontWeight: FontWeight.w700,
//                             ),
//                             unselectedLabelStyle: TextStyle(
//                               fontFamily: "Montserrat",
//                               fontSize: 20,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600,
//                             ),
//                             enableFeedback: true,
//                             tabs: [
//                               Tab(
//                                 text: 'Balanced',
//                               ),
//                               Tab(
//                                 text: 'Low Fat',
//                               ),
//                               Tab(
//                                 text: 'Low Carb',
//                               ),
//                               FittedBox(
//                                 fit: BoxFit.contain,
//                                 child: Tab(
//                                   text: 'High Protein',
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Container(
//                         height: 250,
//                         child: TabBarView(
//                           physics: NeverScrollableScrollPhysics(),
//                           controller: _controller,
//                           children: <Widget>[
//                             GoalsList(
//                               cal: dietTdee,
//                               carb: balancedDiet[0],
//                               protein: balancedDiet[1],
//                               fat: balancedDiet[2],
//                             ),
//                             GoalsList(
//                               cal: dietTdee,
//                               carb: lowFatDiet[0],
//                               protein: lowFatDiet[1],
//                               fat: lowFatDiet[2],
//                             ),
//                             GoalsList(
//                               cal: dietTdee,
//                               carb: lowCarbDiet[0],
//                               protein: lowCarbDiet[1],
//                               fat: lowCarbDiet[2],
//                             ),
//                             GoalsList(
//                               cal: dietTdee,
//                               carb: highProtDiet[0],
//                               protein: highProtDiet[1],
//                               fat: highProtDiet[2],
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 15,
//                         ),
//                         child: Text(
//                           "This app only estimates the optimal amounts for a person. Consulting to a dietician is always the best way to diet.",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontFamily: "Montserrat",
//                             fontSize: 16,
//                             color: basRenk,
//                             fontStyle: FontStyle.italic,
//                           ),
//                         ),
//                       ),
//                       Center(
//                         child: TextButton(
//                           onPressed: () {
//                             switch (_controller.index) {
//                               case 0:
//                                 _autoGoalUp(
//                                     dietTdee, balancedDiet);
//                                 break;
//                               case 1:
//                                 _autoGoalUp(dietTdee, lowFatDiet);
//                                 break;
//                               case 2:
//                                 _autoGoalUp(
//                                     dietTdee, lowCarbDiet);
//                                 break;
//                               case 3:
//                                 _autoGoalUp(
//                                     dietTdee, highProtDiet);
//                                 break;
//                               default:
//                                 showDialog(
//                                     context: context,
//                                     builder: (ctx) => AlertDialog(
//                                             title: Text(
//                                                 "There is something wrong."),
//                                             content: Text(
//                                                 "Your goals couldn't updated.\n You have not selected any diet yet."),
//                                             actions: [
//                                               TextButton(
//                                                   child:
//                                                       Text('OK'),
//                                                   onPressed: () {
//                                                     Navigator.of(
//                                                             context)
//                                                         .pop();
//                                                   }),
//                                             ]));
//                             }
//                           },
//                           style: ButtonStyle(
//                             shape: MaterialStateProperty.all<
//                                 RoundedRectangleBorder>(
//                               RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(5),
//                                 side: BorderSide(
//                                   color: basRenk,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           child: Text(
//                             'Save',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.w700,
//                               fontFamily: 'Montserrat',
//                               color: basRenk,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Visibility(
//                 visible: _isSwitched == false ? true : false,
//                 child: Container(
//                   height: 415,
//                   width: size.width * 0.9,
//                   decoration: BoxDecoration(
//                     color: contRenk,
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: contRenk),
//                   ),
//                   child: SingleChildScrollView(
//                     physics: NeverScrollableScrollPhysics(),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20.0, vertical: 15),
//                       child: Form(
//                         key: _customizeGoalController,
//                         child: Column(
//                           children: [
//                             TextFormField(
//                               decoration: InputDecoration(
//                                 errorStyle:
//                                     TextStyle(color: errorRenk),
//                                 helperStyle:
//                                     TextStyle(color: basRenk),
//                                 hintText:
//                                     'Calorie Goal ($energyUnit)',
//                                 hintStyle: hintStyle2.copyWith(
//                                     color: basRenk),
//                                 focusColor: Color(0xff444444),
//                               ),
//                               maxLength: 4,
//                               inputFormatters: [
//                                 FilteringTextInputFormatter.allow(
//                                     new RegExp('[0-9]')),
//                               ],
//                               keyboardType: TextInputType.number,
//                               textInputAction:
//                                   TextInputAction.next,
//                               style:
//                                   style2.copyWith(color: basRenk),
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Calorie cannot be empty.';
//                                 }
//                                 if (double.tryParse(value) ==
//                                     null) {
//                                   return 'Please enter a valid number';
//                                 }
//                                 if (double.parse(value) < 0) {
//                                   return 'Calorie must be a valid number.';
//                                 }
//                                 if (double.parse(value) > 9999) {
//                                   return 'Calorie must be a valid number.';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 _updatedGoal = Goal(
//                                   id: _updatedGoal.id,
//                                   calGoal: double.parse(value),
//                                   carbGoal: _updatedGoal.carbGoal,
//                                   proteinGoal:
//                                       _updatedGoal.proteinGoal,
//                                   fatGoal: _updatedGoal.fatGoal,
//                                 );
//                               },
//                             ),
//                             TextFormField(
//                               decoration: InputDecoration(
//                                 errorStyle:
//                                     TextStyle(color: errorRenk),
//                                 helperStyle:
//                                     TextStyle(color: basRenk),
//                                 hintText:
//                                     'Carbonhydrate Goal (g)',
//                                 hintStyle: hintStyle2.copyWith(
//                                     color: basRenk),
//                                 focusColor: Color(0xff444444),
//                               ),
//                               maxLength: 3,
//                               inputFormatters: [
//                                 FilteringTextInputFormatter.allow(
//                                     new RegExp('[0-9]')),
//                               ],
//                               keyboardType: TextInputType.number,
//                               textInputAction:
//                                   TextInputAction.next,
//                               style:
//                                   style2.copyWith(color: basRenk),
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Carbonhydrate cannot be empty.';
//                                 }
//                                 if (double.tryParse(value) ==
//                                     null) {
//                                   return 'Please enter a valid number';
//                                 }
//                                 if (double.parse(value) < 0) {
//                                   return 'Carbonhydrate must be a valid number.';
//                                 }
//                                 if (double.parse(value) > 1000) {
//                                   return 'Carbonhydrate must be a valid number.';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 _updatedGoal = Goal(
//                                   id: _updatedGoal.id,
//                                   calGoal: _updatedGoal.calGoal,
//                                   carbGoal: double.parse(value),
//                                   proteinGoal:
//                                       _updatedGoal.proteinGoal,
//                                   fatGoal: _updatedGoal.fatGoal,
//                                 );
//                               },
//                             ),
//                             TextFormField(
//                               decoration: InputDecoration(
//                                 errorStyle:
//                                     TextStyle(color: errorRenk),
//                                 helperStyle:
//                                     TextStyle(color: basRenk),
//                                 hintText: 'Protein Goal (g)',
//                                 hintStyle: hintStyle2.copyWith(
//                                     color: basRenk),
//                                 focusColor: Color(0xff444444),
//                               ),
//                               maxLength: 3,
//                               inputFormatters: [
//                                 FilteringTextInputFormatter.allow(
//                                     new RegExp('[0-9]')),
//                               ],
//                               keyboardType: TextInputType.number,
//                               textInputAction:
//                                   TextInputAction.next,
//                               style:
//                                   style2.copyWith(color: basRenk),
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Height cannot be empty.';
//                                 }
//                                 if (double.tryParse(value) ==
//                                     null) {
//                                   return 'Please enter a valid number';
//                                 }
//                                 if (double.parse(value) < 0) {
//                                   return 'Protein must be a valid number.';
//                                 }
//                                 if (double.parse(value) > 500) {
//                                   return 'Protein must be a valid number.';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 _updatedGoal = Goal(
//                                   id: _updatedGoal.id,
//                                   calGoal: _updatedGoal.calGoal,
//                                   carbGoal: _updatedGoal.carbGoal,
//                                   proteinGoal:
//                                       double.parse(value),
//                                   fatGoal: _updatedGoal.fatGoal,
//                                 );
//                               },
//                             ),
//                             TextFormField(
//                               decoration: InputDecoration(
//                                 errorStyle:
//                                     TextStyle(color: errorRenk),
//                                 helperStyle:
//                                     TextStyle(color: basRenk),
//                                 hintText: 'Fat Goal (g)',
//                                 hintStyle: hintStyle2.copyWith(
//                                     color: basRenk),
//                                 focusColor: Color(0xff444444),
//                               ),
//                               maxLength: 3,
//                               inputFormatters: [
//                                 FilteringTextInputFormatter.allow(
//                                     new RegExp('[0-9]')),
//                               ],
//                               keyboardType: TextInputType.number,
//                               textInputAction:
//                                   TextInputAction.next,
//                               style:
//                                   style2.copyWith(color: basRenk),
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Fat cannot be empty.';
//                                 }
//                                 if (double.tryParse(value) ==
//                                     null) {
//                                   return 'Please enter a valid number';
//                                 }
//                                 if (double.parse(value) < 0) {
//                                   return 'Fat must be a valid number.';
//                                 }
//                                 if (double.parse(value) > 500) {
//                                   return 'Fat must be a valid number.';
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 _updatedGoal = Goal(
//                                   id: _updatedGoal.id,
//                                   calGoal: _updatedGoal.calGoal,
//                                   carbGoal: _updatedGoal.carbGoal,
//                                   proteinGoal:
//                                       _updatedGoal.proteinGoal,
//                                   fatGoal: double.parse(value),
//                                 );
//                               },
//                             ),
//                             SizedBox(height: size.height * 0.01),
//                             TextButton(
//                               onPressed: () {
//                                 _updateGoal();
//                               },
//                               style: ButtonStyle(
//                                 shape: MaterialStateProperty.all<
//                                     RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(5),
//                                     side: BorderSide(
//                                       color: basRenk,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               child: Container(
//                                 child: Text(
//                                   'Save Changes',
//                                   style: TextStyle(
//                                     fontSize: 26,
//                                     fontWeight: FontWeight.w700,
//                                     fontFamily: 'Montserrat',
//                                     color: basRenk,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   ),
// ),
