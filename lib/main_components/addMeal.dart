import 'package:caloriemeter/widgets/addManual.dart';
import 'package:caloriemeter/widgets/foodInfoModal.dart';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../backend/constants.dart';
import 'package:provider/provider.dart';
import '../widgets/appBarTitle.dart';
import '../widgets/menuBtn.dart';
import '../backend/goals_provider.dart';

class AddMealPage extends StatefulWidget {
  static const routeName = '/addMeal';
  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;

  TabController _controller;

  final _autoAddFoodKey = GlobalKey<FormState>();
  final _myAutoController = TextEditingController();
  FocusNode autoTextFocusNode;

  @override
  void initState() {
    autoTextFocusNode = FocusNode();
    _controller = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myAutoController.dispose();
    autoTextFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _searchFood(name) {
    setState(() {
      _isSearching = true;
    });
    Provider.of<Meals>(context, listen: false)
        .searchFood(name)
        .catchError((error) {
      //print(error.toString());
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Something went wrong."),
          content: Text(
            "The food you're looking for could not be found. \n Please, check your internet connection. \n Otherwise, no worries! You can add manually!",
          ),
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
      (value) {
        setState(() {
          _isSearching = false;
        });
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final food = Provider.of<Meals>(context);

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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          //direction: Axis.vertical,
          children: [
            Expanded(
              flex: 17,
              child: Container(
                height: size.height * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: basRenk),
                  color: contRenk,
                ),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Search Your Food',
                              style: topStyle.copyWith(color: basRenk)),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 1),
                          height: size.height * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: basRenk),
                            color: contRenk,
                          ),
                          child: Form(
                            key: _autoAddFoodKey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: size.width * 0.6,
                                  child: TextFormField(
                                    focusNode: autoTextFocusNode,
                                    controller: _myAutoController,
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(color: errorRenk),
                                      helperStyle: TextStyle(color: basRenk),
                                      hintText: 'Enter the name',
                                      hintStyle:
                                          autoStyle.copyWith(color: basRenk),
                                      focusColor: Color(0xff444444),
                                    ),
                                    onFieldSubmitted: (value) {
                                      autoTextFocusNode.unfocus();
                                      final isValid = _autoAddFoodKey
                                          .currentState
                                          .validate();
                                      if (!isValid) {
                                        return;
                                      }
                                      _autoAddFoodKey.currentState.save();
                                      _searchFood(_myAutoController.text);
                                    },
                                    style: style.copyWith(color: basRenk),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Name cannot be empty.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline_outlined,
                                    size: 34,
                                    color: basRenk,
                                  ),
                                  onPressed: () {
                                    food.clearSearch();
                                    _myAutoController.clear();
                                    autoTextFocusNode.requestFocus();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.013),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            width: size.width * 0.8,
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
                                fontWeight: FontWeight.w700,
                              ),
                              unselectedLabelStyle: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              enableFeedback: true,
                              tabs: [
                                Tab(
                                  text: 'Common',
                                ),
                                Tab(
                                  text: 'Traditional',
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.012),
                        Container(
                          height: size.height * 0.35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: basRenk),
                            color: contRenk,
                          ),
                          child: TabBarView(
                            controller: _controller,
                            children: <Widget>[
                              _isSearching
                                  ? Center(child: CircularProgressIndicator())
                                  : Container(
                                      child: Padding(
                                        //##################################################COMMON############################
                                        padding: const EdgeInsets.all(5.0),
                                        child: ListView.builder(
                                          itemCount:
                                              food.searchedMeals.length == 0
                                                  ? 1
                                                  : food.searchedMeals.length,
                                          itemBuilder: (_, index) => food
                                                      .searchedMeals.length ==
                                                  0
                                              ? Center(
                                                  child: Text(
                                                    "No results",
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: 'Montserrat',
                                                      color: basRenk,
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      showMaterialModalBottomSheet(
                                                        duration: Duration(
                                                            milliseconds: 250),
                                                        context: context,
                                                        backgroundColor: Colors
                                                            .amber
                                                            .withOpacity(0),
                                                        barrierColor: Colors
                                                            .black
                                                            .withOpacity(0.1),
                                                        builder: (context) =>
                                                            FoodInfo(
                                                          food.searchedMeals[
                                                              index],
                                                        ),
                                                      );
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Text(
                                                              food
                                                                  .searchedMeals[
                                                                      index]
                                                                  .name,
                                                              style: TextStyle(
                                                                fontSize: 26,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontFamily:
                                                                    'Montserrat',
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
                              _isSearching
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ListView.builder(
                                          itemCount: food.searchedSurveyMeals
                                                      .length ==
                                                  0
                                              ? 1
                                              : food.searchedSurveyMeals.length,
                                          itemBuilder: (_, index) => food
                                                      .searchedSurveyMeals
                                                      .length ==
                                                  0
                                              ? Center(
                                                  child: Text(
                                                    "No results",
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: 'Montserrat',
                                                      color: basRenk,
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      showMaterialModalBottomSheet(
                                                        duration: Duration(
                                                            milliseconds: 250),
                                                        context: context,
                                                        builder: (context) =>
                                                            FoodInfo(
                                                          food.searchedSurveyMeals[
                                                              index],
                                                        ),
                                                        backgroundColor: Colors
                                                            .amber
                                                            .withOpacity(0),
                                                        barrierColor: Colors
                                                            .black
                                                            .withOpacity(0.1),
                                                      );
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Text(
                                                              food
                                                                  .searchedSurveyMeals[
                                                                      index]
                                                                  .name,
                                                              style: TextStyle(
                                                                fontSize: 26,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontFamily:
                                                                    'Montserrat',
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
                        ),
                        SizedBox(height: size.height * 0.012),
                        TextButton(
                          onPressed: () {
                            autoTextFocusNode.unfocus();
                            final isValid =
                                _autoAddFoodKey.currentState.validate();
                            if (!isValid) {
                              return;
                            }
                            _autoAddFoodKey.currentState.save();
                            _searchFood(_myAutoController.text);
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
                            'Tap to Search',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat',
                              color: basRenk,
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.012),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Expanded(
              flex: 2,
              child: Container(
                // height: size.height * 0.1,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: basRenk),
                  color: contRenk,
                ),
                child: TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AddManual.routeName),
                  child: Hero(
                      tag: 'addManual',
                      child: Text('Add Your Food Manually',
                          style: topStyle.copyWith(color: basRenk))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
