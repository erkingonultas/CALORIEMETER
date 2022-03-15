import 'dart:async';

import '../backend/goals_provider.dart';
import '../widgets/miniProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../backend/constants.dart';
import '../widgets/menuBtn.dart';
import '../widgets/appBarTitle.dart';

class TodayDetails extends StatefulWidget {
  static const routeName = '/todayDetails';

  @override
  _TodayDetailsState createState() => _TodayDetailsState();
}

class _TodayDetailsState extends State<TodayDetails> {
  @override
  void initState() {
    _choose1();
    Provider.of<Meals>(context, listen: false).getMeals(day1.toString());
    Timer(Duration(milliseconds: 200), () {
      try {
        _listController.animateTo(_listController.position.maxScrollExtent,
            duration: Duration(milliseconds: 550), curve: Curves.easeOut);
      } catch (e) {
        //print(e.toString());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    Provider.of<Meals>(context, listen: false).getMeals(currentDate.toString());

    super.didChangeDependencies();
  }

  final _listController = ScrollController();
  DateTime initialDate = DateTime.now();
  String _chosenDate;
  String currentDate;
  bool isDateChosen = false;
  bool is7Chosen = false;
  bool is6Chosen = false;
  bool is5Chosen = false;
  bool is4Chosen = false;
  bool is3Chosen = false;
  bool is2Chosen = false;
  bool is1Chosen = false;

  void _unChoose() {
    setState(() {
      is1Chosen = false;
      is4Chosen = false;
      is3Chosen = false;
      is2Chosen = false;
      is7Chosen = false;
      is6Chosen = false;
      is5Chosen = false;
    });
  }

  void _choose1() {
    setState(() {
      _chosenDate = "${DateFormat.MMMMd().format(day1)}";
      currentDate = "${day1.toString()}";
      isDateChosen = false;
      is1Chosen = true;
      is4Chosen = false;
      is3Chosen = false;
      is2Chosen = false;
      is7Chosen = false;
      is6Chosen = false;
      is5Chosen = false;
    });
  }

  void _choose2() {
    setState(() {
      _chosenDate = "${DateFormat.MMMMd().format(day2)}";
      currentDate = day2.toString();
      is2Chosen = true;
      isDateChosen = false;
      is1Chosen = false;
      is3Chosen = false;
      is4Chosen = false;
      is7Chosen = false;
      is6Chosen = false;
      is5Chosen = false;
    });
  }

  void _choose3() {
    setState(() {
      _chosenDate = "${DateFormat.MMMMd().format(day3)}";
      currentDate = day3.toString();
      is3Chosen = true;
      isDateChosen = false;
      is1Chosen = false;
      is2Chosen = false;
      is4Chosen = false;
      is7Chosen = false;
      is6Chosen = false;
      is5Chosen = false;
    });
  }

  void _choose4() {
    setState(() {
      _chosenDate = "${DateFormat.MMMMd().format(day4)}";
      currentDate = day4.toString();
      is4Chosen = true;
      isDateChosen = false;
      is7Chosen = false;
      is6Chosen = false;
      is5Chosen = false;
      is1Chosen = false;
      is3Chosen = false;
      is2Chosen = false;
    });
  }

  void _choose5() {
    setState(() {
      _chosenDate = "${DateFormat.MMMMd().format(day5)}";
      currentDate = day5.toString();
      is5Chosen = true;
      isDateChosen = false;
      is7Chosen = false;
      is6Chosen = false;
      is4Chosen = false;
      is1Chosen = false;
      is3Chosen = false;
      is2Chosen = false;
    });
  }

  void _choose6() {
    setState(() {
      _chosenDate = "${DateFormat.MMMMd().format(day6)}";
      currentDate = day6.toString();
      is6Chosen = true;
      isDateChosen = false;
      is7Chosen = false;
      is5Chosen = false;
      is4Chosen = false;
      is1Chosen = false;
      is3Chosen = false;
      is2Chosen = false;
    });
  }

  void _choose7() {
    setState(() {
      _chosenDate = "${DateFormat.MMMMd().format(day7)}";
      currentDate = day7.toString();
      is7Chosen = true;
      isDateChosen = false;
      is6Chosen = false;
      is5Chosen = false;
      is4Chosen = false;
      is1Chosen = false;
      is3Chosen = false;
      is2Chosen = false;
    });
  }

  datePick() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year, DateTime.now().month - 2),
      lastDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
    );
    if (picked != null) {
      setState(() {
        initialDate = picked;
        _chosenDate = "${DateFormat.MMMMd().format(initialDate)}";
        currentDate = initialDate.toString();
        isDateChosen = true;
      });
    }
    //print(initialDate);
    //print("day7: ${day7.toString()}");
  }

  final DateTime day7 = DateTime.now().subtract(const Duration(days: 6));
  final DateTime day6 = DateTime.now().subtract(const Duration(days: 5));
  final DateTime day5 = DateTime.now().subtract(const Duration(days: 4));
  final DateTime day4 = DateTime.now().subtract(const Duration(days: 3));
  final DateTime day3 = DateTime.now().subtract(const Duration(days: 2));
  final DateTime day2 = DateTime.now().subtract(const Duration(days: 1));
  final DateTime day1 = (DateTime.now());

  @override
  Widget build(BuildContext context) {
    final food = Provider.of<Meals>(context);
    Size size = MediaQuery.of(context).size;

    // Timer(Duration(milliseconds: 200), () {
    //   try {
    //     _listController.animateTo(_listController.position.maxScrollExtent,
    //         duration: Duration(milliseconds: 550), curve: Curves.easeOut);
    //   } catch (e) {
    //     //print(e.toString());
    //   }
    // });
    return Scaffold(
      backgroundColor: scafRenk,
      appBar: AppBar(
        leading: BackButton(color: basRenk),
        toolbarHeight: 75,
        backgroundColor: primaryMavi,
        title: AppBarTitle(),
        actions: [MyMenuBtn()],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              "Recent Meals",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 33,
                fontWeight: FontWeight.w600,
                color: basRenk,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: basRenk),
                color: contRenk,
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 10),
                child: Row(
                  children: [
                    Container(
                      width: size.width * 0.75,
                      child: SingleChildScrollView(
                        reverse: true,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  _choose7();
                                  food.getMeals(day7);
                                },
                                child: Text(
                                  "${day7.day.toString()} ${DateFormat.MMM().format(day7)}",
                                  style: TextStyle(
                                    fontSize: is7Chosen ? 28 : 24,
                                    fontWeight: is7Chosen
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: basRenk,
                                  ),
                                )),
                            TextButton(
                                onPressed: () {
                                  _choose6();
                                  food.getMeals(day6);
                                },
                                child: Text(
                                  "${day6.day.toString()} ${DateFormat.MMM().format(day6)}",
                                  style: TextStyle(
                                    fontSize: is6Chosen ? 28 : 24,
                                    fontWeight: is6Chosen
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: basRenk,
                                  ),
                                )),
                            TextButton(
                                onPressed: () {
                                  _choose5();
                                  food.getMeals(day5);
                                },
                                child: Text(
                                  "${day5.day.toString()} ${DateFormat.MMM().format(day5)}",
                                  style: TextStyle(
                                    fontSize: is5Chosen ? 28 : 24,
                                    fontWeight: is5Chosen
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: basRenk,
                                  ),
                                )),
                            TextButton(
                                onPressed: () {
                                  _choose4();
                                  food.getMeals(day4);
                                },
                                child: Text(
                                  "${day4.day.toString()} ${DateFormat.MMM().format(day4)}",
                                  style: TextStyle(
                                    fontSize: is4Chosen ? 28 : 24,
                                    fontWeight: is4Chosen
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: basRenk,
                                  ),
                                )),
                            TextButton(
                                onPressed: () {
                                  _choose3();
                                  food.getMeals(day3);
                                },
                                child: Text(
                                  "${day3.day.toString()} ${DateFormat.MMM().format(day3)}",
                                  style: TextStyle(
                                    fontSize: is3Chosen ? 28 : 24,
                                    fontWeight: is3Chosen
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: basRenk,
                                  ),
                                )),
                            TextButton(
                                onPressed: () {
                                  _choose2();
                                  food.getMeals(day2);
                                },
                                child: Text(
                                  "${day2.day.toString()} ${DateFormat.MMM().format(day2)}",
                                  style: TextStyle(
                                    fontSize: is2Chosen ? 28 : 24,
                                    fontWeight: is2Chosen
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: basRenk,
                                  ),
                                )),
                            TextButton(
                                onPressed: () {
                                  _choose1();
                                  food.getMeals(day1.toString());
                                },
                                child: Text(
                                  "${day1.day.toString()} ${DateFormat.MMM().format(day1)}",
                                  style: TextStyle(
                                    fontSize: is1Chosen ? 28 : 24,
                                    fontWeight: is1Chosen
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: basRenk,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      splashRadius: 5,
                      icon: Icon(Icons.calendar_today_rounded,
                          size: 36, color: basRenk),
                      onPressed: () async {
                        _unChoose();

                        await datePick();

                        food.getMeals(initialDate.toString());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              height: size.height * 0.65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: basRenk),
                color: contRenk,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      "$_chosenDate",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: basRenk,
                      ),
                    ),
                  ),
                  Divider(
                    color: basRenk,
                    height: size.height * 0.015,
                    thickness: 2,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 5,
                          ),
                          child: Container(
                            height: size.height * 0.55,
                            child: (is1Chosen == false &&
                                    is2Chosen == false &&
                                    is3Chosen == false &&
                                    is4Chosen == false &&
                                    is5Chosen == false &&
                                    is6Chosen == false &&
                                    is7Chosen == false &&
                                    isDateChosen == false)
                                ? Center(
                                    child: Text(
                                      "You can view your daily summary here.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Montserrat',
                                        color: basRenk,
                                      ),
                                    ),
                                  )
                                : food.recieveMeals.length == 0
                                    ? Center(
                                        child: Text(
                                          "Food list is empty.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Montserrat',
                                            color: basRenk,
                                          ),
                                        ),
                                      )
                                    : ListView.separated(
                                        controller: _listController,
                                        itemCount: food.recieveMeals.length,
                                        key: UniqueKey(),
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                                color: basRenk,
                                                height: size.height * 0.1),
                                        itemBuilder: (context, index) => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FoodSum(
                                              food: food,
                                              goal: food,
                                              index: index,
                                              size: size,
                                              date: currentDate,
                                              func: () {},
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.delete_forever,
                                                color: basRenk,
                                                size: 32,
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  barrierColor: Colors.black
                                                      .withOpacity(0.1),
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: Text("Are you sure?",
                                                        style: TextStyle(
                                                            fontSize: 21)),
                                                    content: Text(
                                                        "Do you want to remove the food from your list?",
                                                        style: TextStyle(
                                                            fontSize: 18)),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(ctx)
                                                              .pop();
                                                        },
                                                        child: Text("No",
                                                            style: TextStyle(
                                                                fontSize: 21)),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          food.removeMeal(food
                                                              .recieveMeals[
                                                                  index]
                                                              .id);
                                                          Provider.of<Meals>(
                                                                  context,
                                                                  listen: false)
                                                              .getStreak()
                                                              .then((value) => {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(),
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(SnackBar(
                                                                            duration: Duration(seconds: 5),
                                                                            content: Text(
                                                                              'Your food has been deleted successfully!',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
                                                                            ))),
                                                                  });
                                                        },
                                                        child: Text("Yes",
                                                            style: TextStyle(
                                                                fontSize: 21)),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FoodSum extends StatelessWidget {
  const FoodSum({
    this.index,
    this.size,
    this.goal,
    this.date,
    this.func,
    @required this.food,
  });
  final int index;
  final goal;
  final Function func;
  final date;
  final size;
  final Meals food;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key(food.recieveMeals[index].id),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 300,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              "${food.recieveMeals[index].name[0].toUpperCase()}${food.recieveMeals[index].name.substring(1).toLowerCase()}",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: basRenk,
              ),
            ),
          ),
        ),
        MiniProgressBar(
          title: "Calories",
          wid: size.width * 0.62,
          spend: (size.width * 0.62) *
              (food.recieveMeals[index].cal /
                  goal.recentGoals[goal.currentGoal].calGoal),
          filled: (food.recieveMeals[index].cal).ceil(),
          goal:
              "${(goal.recentGoals[goal.currentGoal].calGoal).ceil()}$energyUnit",
        ),
        MiniProgressBar(
          title: "Carbs",
          wid: size.width * 0.45,
          spend: (size.width * 0.45) *
              (food.recieveMeals[index].carb /
                  goal.recentGoals[goal.currentGoal].carbGoal),
          filled: (food.recieveMeals[index].carb).ceil(),
          goal:
              "${(goal.recentGoals[goal.currentGoal].carbGoal).ceil()}$portionUnit",
        ),
        MiniProgressBar(
          title: "Proteins",
          wid: size.width * 0.45,
          spend: (size.width * 0.45) *
              (food.recieveMeals[index].protein /
                  goal.recentGoals[goal.currentGoal].proteinGoal),
          filled: (food.recieveMeals[index].protein).ceil(),
          goal:
              "${(goal.recentGoals[goal.currentGoal].proteinGoal).ceil()}$portionUnit",
        ),
        MiniProgressBar(
          title: "Fats",
          wid: size.width * 0.45,
          spend: (size.width * 0.45) *
              (food.recieveMeals[index].fat /
                  goal.recentGoals[goal.currentGoal].fatGoal),
          filled: (food.recieveMeals[index].fat).ceil(),
          goal:
              "${(goal.recentGoals[goal.currentGoal].fatGoal).ceil()}$portionUnit",
        ),
      ],
    );
  }
}
