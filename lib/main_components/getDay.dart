import 'dart:async';

import 'package:caloriemeter/backend/constants.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../backend/goals_provider.dart';

import '../widgets/progressBar.dart';

class GetDayPage extends StatefulWidget {
  final homeController;
  //final dayController;

  const GetDayPage(this.homeController);

  @override
  _GetDayPageState createState() => _GetDayPageState();
}

class _GetDayPageState extends State<GetDayPage> {
  DateTime initialDate;
  DateTime picked2;
  String _chosenDate = " ";
  //String _currentDate;
  bool isDateChosen = false;
  //double max = dayController.position.maxScrollExtent;
  final dayController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      isDateChosen = false;
      _chosenDate = " ";
    });
  }

  void setChosenDate(index) {
    setState(() {
      _chosenDate = "${DateFormat.MMMMd().format(index)}";
    });
  }

  datePick() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year, DateTime.now().month - 1),
      lastDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
    );
    if (picked != null) {
      setState(() {
        initialDate = picked;
        _chosenDate = "${DateFormat.MMMMd().format(initialDate)}";
        isDateChosen = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final food = Provider.of<Meals>(context);
    final _daysFilled = food.daysFilled;
    Timer(Duration(milliseconds: 250), () {
      try {
        dayController.animateTo(
          dayController.position.maxScrollExtent,
          duration: Duration(milliseconds: 1000),
          curve: Curves.decelerate,
        );
      } catch (e) {}
    });
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xff707070)),
            color: contRenk,
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 36, color: basRenk),
                Container(
                  width: size.width * 0.72,
                  //alignment: Alignment.centerRight,
                  child: _daysFilled.length > 0
                      ? ListView.separated(
                          controller: dayController,
                          scrollDirection: Axis.horizontal,
                          itemCount: _daysFilled.length,
                          reverse: false,
                          shrinkWrap: false,
                          primary: false,
                          separatorBuilder: (context, ind) => VerticalDivider(
                            thickness: 2,
                            color: basRenk,
                          ),
                          itemBuilder: (
                            BuildContext context,
                            int ind,
                          ) =>
                              TextButton(
                            onPressed: () {
                              setChosenDate(_daysFilled[ind]);
                              food.getMacros(_daysFilled[ind].toString());
                              // setState(() {
                              //   _currentDate = _daysFilled[ind].toString();
                              // });
                              setState(() {
                                isDateChosen = true;
                              });
                              Timer(Duration(milliseconds: 200), () {
                                try {
                                  widget.homeController.animateTo(
                                      widget.homeController.position
                                          .maxScrollExtent,
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.decelerate);
                                } catch (e) {
                                  //print(e.toString());
                                }
                              });
                            },
                            child: Text(
                              "${DateFormat.MMM().format(_daysFilled[ind])} ${_daysFilled[ind].day.toString()}",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Montserrat',
                                color: basRenk,
                              ),
                            ),
                          ),
                        )
                      : FittedBox(
                          child: Text("Your summary info will be shown here",
                              textAlign: TextAlign.center,
                              style: style3.copyWith(color: basRenk)),
                        ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: size.height * 0.025),
        AnimatedContainer(
          duration: Duration(milliseconds: 350),
          curve: Curves.decelerate,
          height: (isDateChosen == true) ? size.height * 0.56 : size.height * 0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color(0xff707070)),
            color: contRenk,
          ),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20,
                  ),
                  child: (isDateChosen == false)
                      ? Center(
                          child: Text(
                            "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat',
                              color: basRenk,
                            ),
                          ),
                        )
                      : DaySum(
                          date: _chosenDate,
                          food: food,
                          goal: food,
                          size: size,
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DaySum extends StatelessWidget {
  const DaySum({
    this.date,
    this.size,
    this.goal,
    @required this.food,
  });
  final date;
  final goal;
  final size;
  final Meals food;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$date",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
            color: basRenk,
          ),
        ),
        Divider(thickness: 2, color: basRenk),
        ProgressBar(
          title: "Calories",
          wid: size.width * 0.62,
          spend: (size.width * 0.62) *
              (food.getCal / goal.recentGoals[goal.currentGoal].calGoal),
          filled: (food.getCal).ceil(),
          goal:
              "${(goal.recentGoals[goal.currentGoal].calGoal).ceil()}$energyUnit",
        ),
        ProgressBar(
          title: "Carbs",
          wid: size.width * 0.45,
          spend: (size.width * 0.45) *
              (food.getCarb / goal.recentGoals[goal.currentGoal].carbGoal),
          filled: (food.getCarb).ceil(),
          goal:
              "${(goal.recentGoals[goal.currentGoal].carbGoal).ceil()}$portionUnit",
        ),
        ProgressBar(
          title: "Proteins",
          wid: size.width * 0.45,
          spend: (size.width * 0.45) *
              (food.getProtein /
                  goal.recentGoals[goal.currentGoal].proteinGoal),
          filled: (food.getProtein).ceil(),
          goal:
              "${(goal.recentGoals[goal.currentGoal].proteinGoal).ceil()}$portionUnit",
        ),
        ProgressBar(
          title: "Fats",
          wid: size.width * 0.45,
          spend: (size.width * 0.45) *
              (food.getFat / goal.recentGoals[goal.currentGoal].fatGoal),
          filled: (food.getFat).ceil(),
          goal:
              "${(goal.recentGoals[goal.currentGoal].fatGoal).ceil()}$portionUnit",
        ),
      ],
    );
  }
}
