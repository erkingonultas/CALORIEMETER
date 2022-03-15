import 'package:caloriemeter/backend/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../backend/goals_provider.dart';
import '../widgets/miniProgressBar.dart';

class Food2 extends StatefulWidget {
  static const routeName = '/food2';

  @override
  _Food2State createState() => _Food2State();
}

class _Food2State extends State<Food2> {
  @override
  Widget build(BuildContext context) {
    final food = Provider.of<Meals>(context, listen: false);
    Size size = MediaQuery.of(context).size;

    int mealCount = (food.todayMeal.length).ceil();
    return Padding(
      padding: const EdgeInsets.all(15.0),
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
                    food.todayMeal[mealCount - 2].name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "Montserrat",
                      color: basRenk,
                      fontStyle: FontStyle.italic,
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
                    (food.todayMeal[mealCount - 2].cal /
                        food.recentGoals[food.currentGoal].calGoal),
                filled: (food.todayMeal[mealCount - 2].cal).ceil(),
                goal:
                    "${(food.recentGoals[food.currentGoal].calGoal).ceil()}$energyUnit",
              ),
              MiniProgressBar(
                title: "Carbs",
                wid: size.width * 0.45,
                spend: (size.width * 0.45) *
                    (food.todayMeal[mealCount - 2].carb /
                        food.recentGoals[food.currentGoal].carbGoal),
                filled: (food.todayMeal[mealCount - 2].carb).ceil(),
                goal:
                    "${(food.recentGoals[food.currentGoal].carbGoal).ceil()}$portionUnit",
              ),
              MiniProgressBar(
                title: "Proteins",
                wid: size.width * 0.45,
                spend: (size.width * 0.45) *
                    (food.todayMeal[mealCount - 2].protein /
                        food.recentGoals[food.currentGoal].proteinGoal),
                filled: (food.todayMeal[mealCount - 2].protein).ceil(),
                goal:
                    "${(food.recentGoals[food.currentGoal].proteinGoal).ceil()}$portionUnit",
              ),
              MiniProgressBar(
                title: "Fats",
                wid: size.width * 0.45,
                spend: (size.width * 0.45) *
                    (food.todayMeal[mealCount - 2].fat /
                        food.recentGoals[food.currentGoal].fatGoal),
                filled: (food.todayMeal[mealCount - 2].fat).ceil(),
                goal:
                    "${(food.recentGoals[food.currentGoal].fatGoal).ceil()}$portionUnit",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
