import 'package:caloriemeter/backend/constants.dart';

import '../backend/goals_provider.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../main_components/food3.dart';
import 'package:flutter/material.dart';
import '../main_components/food2.dart';

class LastMeals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final goal = Provider.of<Goals>(context);
    final food = Provider.of<Meals>(context);
    //final day = Provider.of<Days>(context);
    Size size = MediaQuery.of(context).size;
    int mealCount = (food.todayMeal.length).ceil();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recently Added",
          style: TextStyle(
            shadows: [
              Shadow(
                blurRadius: 20.0,
                color: Colors.grey,
                offset: Offset(2, 3),
              ),
            ],
            fontFamily: "Montserrat",
            color: recRenk,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: size.height * 0.012),
        Container(
          width: size.width * 0.45,
          height: size.height * 0.15,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              FoodNameWithBox(
                  index: mealCount - 1,
                  func: () {
                    showMaterialModalBottomSheet(
                      duration: Duration(milliseconds: 250),
                      backgroundColor: Colors.amber.withOpacity(0),
                      barrierColor: Colors.black.withOpacity(0.1),
                      context: context,
                      builder: (context) => Food3(),
                    );
                  }),
              SizedBox(height: size.height * 0.01),
              mealCount > 1
                  ? FoodNameWithBox(
                      index: mealCount - 2,
                      func: () {
                        showMaterialModalBottomSheet(
                          duration: Duration(milliseconds: 250),
                          context: context,
                          builder: (context) => Food2(),
                          backgroundColor: Colors.amber.withOpacity(0),
                          barrierColor: Colors.black.withOpacity(0.1),
                        );
                      })
                  : SizedBox(height: size.height * 0.01),
            ],
          ),
        ),
      ],
    );
  }
}

class FoodNameWithBox extends StatelessWidget {
  const FoodNameWithBox({
    Key key,
    this.index,
    this.func,
  }) : super(key: key);

  final int index;
  final Function func;
  @override
  Widget build(BuildContext context) {
    final food = Provider.of<Meals>(context);
    return index > -1
        ? InputChip(
            deleteIcon: Icon(Icons.highlight_remove_rounded,
                size: 26, color: Colors.black54),
            onDeleted: () {
              showDialog(
                barrierColor: Colors.black.withOpacity(0.1),
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Are you sure?", style: TextStyle(fontSize: 21)),
                  content: Text(
                      "Do you want to remove the food from your list?",
                      style: TextStyle(fontSize: 18)),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("No", style: TextStyle(fontSize: 21)),
                    ),
                    TextButton(
                      onPressed: () {
                        food.removeMeal(food.todayMeal[index].id);
                        food.getStreak().then((value) => {
                              Navigator.of(context).pop(),
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      duration: Duration(seconds: 3),
                                      content: Text(
                                        'Your food has been deleted successfully!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Montserrat'),
                                      ))),
                            });
                      },
                      child: Text("Yes", style: TextStyle(fontSize: 21)),
                    ),
                  ],
                ),
              );
            },
            label: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 6,
              ),
              child: index >= 0
                  ? Text(
                      "${food.todayMeal[index].name[0].toUpperCase()}${food.todayMeal[index].name.substring(1).toLowerCase()}",
                      style: TextStyle(
                        color: basRenk,
                        fontSize: 24,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Text(""),
            ),
            backgroundColor: buttonRenk,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            onPressed: func,
          )
        : Text(
            "Save your foods with the button on the right bottom corner!",
            style: TextStyle(
              color: basRenk,
              fontSize: 21,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w400,
            ),
          );
  }
}
