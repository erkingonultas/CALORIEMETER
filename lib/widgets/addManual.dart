import 'dart:async';

import 'package:caloriemeter/backend/constants.dart';
import 'package:caloriemeter/backend/goals_provider.dart';
import 'package:caloriemeter/home.dart';

import 'package:flutter/material.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'appBarTitle.dart';
import 'foodInfoModal.dart';
import 'menuBtn.dart';

class AddManual extends StatefulWidget {
  static const routeName = '/addManual';
  @override
  _AddManualState createState() => _AddManualState();
}

class _AddManualState extends State<AddManual> {
  final _manualAddFoodKey = GlobalKey<FormState>();
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var _editedMeal = Meal(
    id: null,
    name: '',
    date: DateTime.now().toString().substring(0, 19),
    carb: 0,
    protein: 0,
    fat: 0,
    cal: 0,
  );

  void _saveForm() {
    final isValid = _manualAddFoodKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _manualAddFoodKey.currentState.save();
    Provider.of<Meals>(context, listen: false)
        .addMeal2DB(_editedMeal, 1, 1)
        .catchError((error) {
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 5),
            content: Text(
              'Your food has been added successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
            ))),
        Navigator.of(context).pushNamed(HomePage.routeName),
      },
    );
  }

  BoxDecoration boxD1 = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    border: Border.all(color: Colors.grey[500]),
  );
  BoxDecoration boxD2 = BoxDecoration(
    borderRadius: BorderRadius.circular(50),
    border: Border.all(color: Colors.grey[500]),
  );

  bool _isRecVisible = false;

  void _showRec() {
    if (_isRecVisible == false) {
      Timer(Duration(milliseconds: 250), () {
        try {
          _controller.animateTo(_controller.position.maxScrollExtent,
              duration: Duration(milliseconds: 200), curve: Curves.decelerate);
        } catch (e) {
          //print(e.toString());
        }
      });
    }
    setState(() {
      _isRecVisible = !_isRecVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //final food = Provider.of<Meals>(context);
    return Scaffold(
      backgroundColor: scafRenk,
      appBar: AppBar(
        leading: BackButton(color: basRenk),
        toolbarHeight: 75,
        backgroundColor: primaryMavi,
        title: AppBarTitle(),
        actions: [MyMenuBtn()],
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          height: size.height * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: basRenk),
            color: contRenk,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 20,
            ),
            child: SingleChildScrollView(
              controller: _controller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'addManual',
                    child: Text('Add Your Food Manually',
                        style: topStyle.copyWith(color: basRenk)),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    height: size.height * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: basRenk),
                      color: contRenk,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Form(
                        key: _manualAddFoodKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: errorRenk),
                                  helperStyle: TextStyle(color: basRenk),
                                  hintText: 'Name',
                                  hintStyle: hintStyle.copyWith(color: basRenk),
                                  focusColor: Color(0xff444444),
                                ),
                                style: style.copyWith(color: basRenk),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Name cannot be empty.';
                                  }
                                  if (value.length > 25) {
                                    return 'Name is too long.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedMeal = Meal(
                                      name: value,
                                      cal: _editedMeal.cal,
                                      carb: _editedMeal.carb,
                                      protein: _editedMeal.protein,
                                      fat: _editedMeal.fat,
                                      date: _editedMeal.date,
                                      id: null);
                                },
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: errorRenk),
                                  helperStyle: TextStyle(color: basRenk),
                                  hintText: 'Calorie',
                                  hintStyle: hintStyle.copyWith(color: basRenk),
                                  focusColor: Color(0xff444444),
                                ),
                                maxLength: 4,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                style: style.copyWith(color: basRenk),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Calorie cannot be empty.';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (double.parse(value) <= 0) {
                                    return 'Calorie must be bigger than zero.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedMeal = Meal(
                                      name: _editedMeal.name,
                                      cal: double.parse(value),
                                      carb: _editedMeal.carb,
                                      protein: _editedMeal.protein,
                                      fat: _editedMeal.fat,
                                      date: _editedMeal.date,
                                      id: null);
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: errorRenk),
                                  helperStyle: TextStyle(color: basRenk),
                                  hintText: 'Carbs',
                                  hintStyle: hintStyle.copyWith(color: basRenk),
                                  focusColor: Color(0xff444444),
                                ),
                                maxLength: 4,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                style: style.copyWith(color: basRenk),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Carbs cannot be empty.';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (double.parse(value) <= 0) {
                                    return 'Carbs must be bigger than zero.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedMeal = Meal(
                                      name: _editedMeal.name,
                                      cal: _editedMeal.cal,
                                      carb: double.parse(value),
                                      protein: _editedMeal.protein,
                                      fat: _editedMeal.fat,
                                      date: _editedMeal.date,
                                      id: null);
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: errorRenk),
                                  helperStyle: TextStyle(color: basRenk),
                                  hintText: 'Proteins',
                                  hintStyle: hintStyle.copyWith(color: basRenk),
                                  focusColor: Color(0xff444444),
                                ),
                                maxLength: 4,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                style: style.copyWith(color: basRenk),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Protein cannot be empty.';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (double.parse(value) <= 0) {
                                    return 'Protein must be bigger than zero.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedMeal = Meal(
                                      name: _editedMeal.name,
                                      cal: _editedMeal.cal,
                                      carb: _editedMeal.carb,
                                      protein: double.parse(value),
                                      fat: _editedMeal.fat,
                                      date: _editedMeal.date,
                                      id: null);
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: errorRenk),
                                  helperStyle: TextStyle(color: basRenk),
                                  hintText: 'Fats',
                                  hintStyle: hintStyle.copyWith(color: basRenk),
                                  focusColor: Color(0xff444444),
                                ),
                                maxLength: 4,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                style: style.copyWith(color: basRenk),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Fat cannot be empty.';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (double.parse(value) <= 0) {
                                    return 'Fat must be bigger than zero.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedMeal = Meal(
                                    name: _editedMeal.name,
                                    cal: _editedMeal.cal,
                                    carb: _editedMeal.carb,
                                    protein: _editedMeal.protein,
                                    fat: double.parse(value),
                                    date: _editedMeal.date,
                                    id: null,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  TextButton(
                    onPressed: () {
                      _saveForm();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            color: basRenk,
                          ),
                        ),
                      ),
                    ),
                    child: Text(
                      'Tap to Add',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        color: basRenk,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  TextButton(
                      onPressed: () => _showRec(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Recently Added",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                              color: basRenk,
                            ),
                          ),
                          _isRecVisible
                              ? Icon(
                                  Icons.expand_more_rounded,
                                  size: size.height * 0.05,
                                  color: basRenk,
                                )
                              : Icon(
                                  Icons.expand_less_outlined,
                                  size: size.height * 0.05,
                                  color: basRenk,
                                )
                        ],
                      )),
                  AnimatedOpacity(
                    opacity: _isRecVisible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 150),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height: _isRecVisible ? size.height * 0.45 : 0,
                      width: size.width * 0.8,
                      child: RecentMeals(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RecentMeals extends StatefulWidget {
  @override
  _RecentMealsState createState() => _RecentMealsState();
}

class _RecentMealsState extends State<RecentMeals> {
  @override
  Widget build(BuildContext context) {
    final food = Provider.of<Meals>(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(top: 15, right: 25, left: 15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500],
            blurRadius: 10.0,
            offset: Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: basRenk),
        color: contRenk,
      ),
      child: SingleChildScrollView(
        child: Container(
          height: size.height * 0.45,
          child: food.foodNames.length > 0
              ? ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  itemCount: food.foodNames.length,
                  itemBuilder: (_, index) => FoodNames(
                    food: food,
                    index: index,
                    size: size,
                  ),
                )
              : Text(
                  "There are no saved meals",
                  textAlign: TextAlign.center,
                  style: style2.copyWith(color: basRenk),
                ),
        ),
      ),
    );
  }
}

class FoodNames extends StatelessWidget {
  FoodNames({
    this.index,
    this.size,
    @required this.food,
  });
  final int index;

  final size;
  final Meals food;

  @override
  Widget build(BuildContext context) {
    final Meal _editedFood = Meal(
      id: null,
      name: food.foodNames[index].name,
      date: DateTime.now().toString().substring(0, 19),
      carb: food.foodNames[index].carb,
      protein: food.foodNames[index].protein,
      fat: food.foodNames[index].fat,
      cal: food.foodNames[index].cal,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: size.height * 0.05,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: basRenk),
            color: contRenk,
          ),
          padding: const EdgeInsets.only(right: 10),
          child: TextButton(
            onPressed: () {
              showMaterialModalBottomSheet(
                duration: Duration(milliseconds: 250),
                context: context,
                builder: (context) => FoodInfo(
                  _editedFood,
                ),
                backgroundColor: Colors.amber.withOpacity(0),
                barrierColor: Colors.black.withOpacity(0.1),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      "${food.foodNames[index].name[0].toUpperCase()}${food.foodNames[index].name.substring(1).toLowerCase()}",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
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
        Divider(height: size.height * 0.03, color: basRenk),
      ],
    );
  }
}
