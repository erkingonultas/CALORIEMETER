//import 'package:caloriemeter/widgets/verticalBar.dart';

import '../widgets/miniProgressBar.dart';
import 'package:flutter/material.dart';

import '../backend/constants.dart';
import 'package:provider/provider.dart';

import '../backend/goals_provider.dart';

class FoodInfo extends StatefulWidget {
  final Meal yemek;

  FoodInfo(this.yemek);
  @override
  _FoodInfoState createState() => _FoodInfoState();
}

class _FoodInfoState extends State<FoodInfo> {
  final TextStyle _hintStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    fontFamily: 'Montserrat',
    color: Color(0xff979797),
  );
  final TextStyle _style = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    fontFamily: 'Montserrat',
    color: Color(0xff444444),
  );
  final TextStyle _scrollStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: 'Montserrat',
    color: Color(0xff979797),
  );

  final _servingKey = GlobalKey<FormState>();
  void _autoSaveForm(name) {
    final isValid = _servingKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _servingKey.currentState.save();

    Provider.of<Meals>(context, listen: false)
        .addMeal2DB(name, _type, _servingSize)
        .catchError((error) {
      //print(error.toString());
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("There is something wrong."),
          content: Text("Your food couldn't added."),
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
    }).then(
      (value) => {
        Provider.of<Meals>(context, listen: false).getStreak().then((value) => {
              Navigator.of(context).pop(),
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 5),
                  content: Text(
                    'Your food has been added successfully!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
                  ))),
            }),
      },
    );
  }

  double _type = 1.0;
  String _dropServingValue = 'g';
  double _servingSize = 1.0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final goal = Provider.of<Meals>(context, listen: false);
    return AnimatedPadding(
      duration: Duration(milliseconds: 60),
      curve: Curves.decelerate,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      //padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        height: size.height * 0.6,
        child: Column(
          children: [
            Container(
              height: size.height * 0.59,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xff707070)),
                color: contRenk,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height * 0.03),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.02),
                      Container(
                        height: size.height * 0.05,
                        child: SingleChildScrollView(
                          child: Text(
                            widget.yemek.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 28,
                              fontFamily: "Montserrat",
                              color: basRenk,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Divider(height: size.height * 0.01, color: basRenk),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     VerticalBar(
                      //       filled: (widget.yemek.cal.ceil() *
                      //           _servingSize *
                      //           _type),
                      //       goal:
                      //           "${(goal.recentGoals[goal.currentGoal].calGoal).ceil()}$energyUnit",
                      //       spend: (size.width * 0.70) *
                      //           (widget.yemek.cal *
                      //               _servingSize *
                      //               _type /
                      //               goal.recentGoals[goal.currentGoal].calGoal),
                      //       title: "2516515",
                      //       wid: 140,
                      //     ),
                      //     VerticalBar(
                      //       filled: (widget.yemek.cal.ceil() *
                      //           _servingSize *
                      //           _type),
                      //       goal:
                      //           "${(goal.recentGoals[goal.currentGoal].calGoal).ceil()}$energyUnit",
                      //       spend: (size.width * 0.70) *
                      //           (widget.yemek.cal *
                      //               _servingSize *
                      //               _type /
                      //               goal.recentGoals[goal.currentGoal].calGoal),
                      //       title: "2516515",
                      //       wid: 140,
                      //     ),
                      //   ],
                      // ),
                      Container(
                        height: size.height * 0.33,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            MiniProgressBar(
                              title: "Calories",
                              wid: size.width * 0.70,
                              spend: (size.width * 0.70) *
                                  (widget.yemek.cal *
                                      _servingSize *
                                      _type /
                                      goal.recentGoals[goal.currentGoal]
                                          .calGoal),
                              filled: (widget.yemek.cal.ceil() *
                                      _servingSize *
                                      _type)
                                  .ceil(),
                              goal:
                                  "${(goal.recentGoals[goal.currentGoal].calGoal).ceil()}$energyUnit",
                            ),
                            MiniProgressBar(
                              title: "Carbs",
                              wid: size.width * 0.45,
                              spend: (size.width * 0.45) *
                                  ((widget.yemek.carb * _servingSize * _type) /
                                      goal.recentGoals[goal.currentGoal]
                                          .carbGoal),
                              filled: (widget.yemek.carb.ceil() *
                                      _servingSize *
                                      _type)
                                  .ceil(),
                              goal:
                                  "${(goal.recentGoals[goal.currentGoal].carbGoal).ceil()}g",
                            ),
                            MiniProgressBar(
                              title: "Proteins",
                              wid: size.width * 0.45,
                              spend: (size.width * 0.45) *
                                  ((widget.yemek.protein *
                                          _servingSize *
                                          _type) /
                                      goal.recentGoals[goal.currentGoal]
                                          .proteinGoal),
                              filled: (widget.yemek.protein.ceil() *
                                      _servingSize *
                                      _type)
                                  .ceil(),
                              goal:
                                  "${(goal.recentGoals[goal.currentGoal].proteinGoal).ceil()}g",
                            ),
                            MiniProgressBar(
                              title: "Fats",
                              wid: size.width * 0.45,
                              spend: (size.width * 0.45) *
                                  ((widget.yemek.fat * _servingSize * _type) /
                                      goal.recentGoals[goal.currentGoal]
                                          .fatGoal),
                              filled: (widget.yemek.fat.ceil() *
                                      _servingSize *
                                      _type)
                                  .ceil(),
                              goal:
                                  "${(goal.recentGoals[goal.currentGoal].fatGoal).ceil()}g",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.015),
                      Form(
                        key: _servingKey,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _dropServingValue == 'g'
                                ? Container(
                                    height: size.height * 0.05,
                                    width: size.width * 0.12,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(color: errorRenk),
                                        helperStyle: TextStyle(color: basRenk),
                                        isDense: true,
                                        isCollapsed: true,
                                        hintText: '100',
                                        hintStyle:
                                            _hintStyle.copyWith(color: basRenk),
                                        focusColor: Color(0xff444444),
                                      ),
                                      initialValue: '${100}',
                                      maxLength: 3,
                                      keyboardType: TextInputType.number,
                                      style:
                                          _scrollStyle.copyWith(color: basRenk),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return '';
                                        }
                                        if (double.tryParse(value) == null) {
                                          return '';
                                        }
                                        if (double.parse(value) < 0) {
                                          return '';
                                        }
                                        if (double.parse(value) == 0) {
                                          return '';
                                        }
                                        if (double.parse(value) > 999) {
                                          return '';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          _type = (double.parse(value) / 100);
                                        });
                                      },
                                    ),
                                  )
                                : Container(
                                    height: size.height * 0.08,
                                    width: size.width * 0.08,
                                    child: ListWheelScrollView(
                                      children: [
                                        Text("1",
                                            style: _scrollStyle.copyWith(
                                                color: basRenk)),
                                        Text("2",
                                            style: _scrollStyle.copyWith(
                                                color: basRenk)),
                                        Text("3",
                                            style: _scrollStyle.copyWith(
                                                color: basRenk)),
                                        Text("4",
                                            style: _scrollStyle.copyWith(
                                                color: basRenk)),
                                        Text("5",
                                            style: _scrollStyle.copyWith(
                                                color: basRenk)),
                                      ],
                                      itemExtent: 30,
                                      diameterRatio: 1.5,
                                      useMagnifier: true,
                                      magnification: 1.5,
                                      onSelectedItemChanged: (int i) {
                                        setState(() {
                                          _servingSize = (i + 1).toDouble();
                                        });
                                      },
                                    ),
                                  ),
                            Container(
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(10),
                              //   border: Border.all(color: Color(0xff707070)),
                              //   color: contRenk,
                              // ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: DropdownButton<String>(
                                  hint: Text('Serving Size', style: _hintStyle),
                                  value: _dropServingValue,
                                  icon: const Icon(
                                    Icons.arrow_downward,
                                    color: Colors.grey,
                                  ),
                                  dropdownColor: contRenk,
                                  iconSize: 24,
                                  elevation: 10,
                                  style: _style,
                                  underline: Container(
                                    height: 1,
                                    color: basRenk,
                                  ),
                                  onChanged: (String value) {
                                    setState(() {
                                      _dropServingValue = value;
                                      switch (_dropServingValue) {
                                        case 'cup (234.0g)':
                                          _type = 2.34;
                                          break;
                                        case 'tbsp (14.6g)':
                                          _type = 0.146;
                                          break;
                                        case 'packet (141.0g)':
                                          _type = 1.41;
                                          break;
                                        case 'g':
                                          _type = 1.0;
                                          break;
                                        default:
                                          _type = 1.0;
                                      }
                                    });
                                  },
                                  items: <String>[
                                    'cup (234.0g)',
                                    'tbsp (14.6g)',
                                    'packet (141.0g)',
                                    'g',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style:
                                              style2.copyWith(color: basRenk)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            _autoSaveForm(widget.yemek);
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
                          child: Text(
                            "Add To Your List",
                            style: TextStyle(
                              fontSize: 26,
                              fontFamily: "Montserrat",
                              color: basRenk,
                              fontWeight: FontWeight.w600,
                            ),
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
    );
  }
}
