import 'package:caloriemeter/backend/constants.dart';

import '../backend/goals_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/miniProgressBar.dart';

class Food3 extends StatefulWidget {
  static const routeName = '/food3';

  @override
  _Food3State createState() => _Food3State();
}

class _Food3State extends State<Food3> {
  @override
  Widget build(BuildContext context) {
    final food = Provider.of<Meals>(context, listen: false);
    //final day = Provider.of<Days>(context);
    Size size = MediaQuery.of(context).size;
    int mealCount = (food.todayMeal.length).ceil();
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        height: size.height * 0.57,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xff707070)),
          color: contRenk,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.02),
              Container(
                height: size.height * 0.09,
                child: SingleChildScrollView(
                  child: Text(
                    food.todayMeal[mealCount - 1].name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "Montserrat",
                      color: basRenk,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                child: Text(
                  "The bar charts compare the food \nwith your daily needs.",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    color: basRenk,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Divider(height: size.height * 0.012, color: basRenk),

              MiniProgressBar(
                title: "Calories",
                wid: size.width * 0.70,
                spend: (size.width * 0.70) *
                    (food.todayMeal[mealCount - 1].cal /
                        food.recentGoals[food.currentGoal].calGoal),
                filled: (food.todayMeal[mealCount - 1].cal).ceil(),
                goal:
                    "${(food.recentGoals[food.currentGoal].calGoal).ceil()}$energyUnit",
              ),
              MiniProgressBar(
                title: "Carbs",
                wid: size.width * 0.45,
                spend: (size.width * 0.45) *
                    (food.todayMeal[mealCount - 1].carb /
                        food.recentGoals[food.currentGoal].carbGoal),
                filled: (food.todayMeal[mealCount - 1].carb).ceil(),
                goal:
                    "${(food.recentGoals[food.currentGoal].carbGoal).ceil()}$portionUnit",
              ),
              MiniProgressBar(
                title: "Proteins",
                wid: size.width * 0.45,
                spend: (size.width * 0.45) *
                    (food.todayMeal[mealCount - 1].protein /
                        food.recentGoals[food.currentGoal].proteinGoal),
                filled: (food.todayMeal[mealCount - 1].protein).ceil(),
                goal:
                    "${(food.recentGoals[food.currentGoal].proteinGoal).ceil()}$portionUnit",
              ),
              MiniProgressBar(
                title: "Fats",
                wid: size.width * 0.45,
                spend: (size.width * 0.45) *
                    (food.todayMeal[mealCount - 1].fat /
                        food.recentGoals[food.currentGoal].fatGoal),
                filled: (food.todayMeal[mealCount - 1].fat).ceil(),
                goal:
                    "${(food.recentGoals[food.currentGoal].fatGoal).ceil()}$portionUnit",
              ),
              // SizedBox(
              //   child: Text(
              //     "\n For 100g portions.",
              //     style: TextStyle(
              //       fontSize: 16,
              //       fontFamily: "Montserrat",
              //       color: Color(0xff878585),
              //       fontStyle: FontStyle.italic,
              //       fontWeight: FontWeight.w400,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
