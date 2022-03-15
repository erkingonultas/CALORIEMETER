import 'dart:math';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import './backend/profile_provider.dart';
import './main_components/todayDetails.dart';
import './widgets/textWithButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:shimmer/shimmer.dart';
import './backend/constants.dart';
import './backend/goals_provider.dart';
import 'backend/tdee_calc.dart';
import 'main_components/addMeal.dart';
import 'widgets/appBarTitle.dart';
import 'widgets/lastMeals.dart';
import 'widgets/menuBtn.dart';
import 'widgets/progressBar.dart';
import 'widgets/summary.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isProfileVisible = false;
  bool _isTodayVisible = false;
  bool _isInit = true;
  bool _isLoading = false;
  final homeController = ScrollController();
  //final dayController = ScrollController();
  FlutterLocalNotificationsPlugin localNotification;

  int rng = Random().nextInt(101);
  @override
  void initState() {
    var androidInitialize =
        new AndroidInitializationSettings('ic_launcher_foreground');
    var initializationSettings =
        new InitializationSettings(android: androidInitialize);
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    tz.initializeTimeZones();

    super.initState();
  }

  Future showNotif(mes) async {
    final food = Provider.of<Meals>(context, listen: false);
    var androidDetails = new AndroidNotificationDetails(
      'channelId',
      'Reminders of Calorimeter',
      'The notifications for remind you to track your diet and not to lose your streak',
      importance: Importance.defaultImportance,
      channelShowBadge: true,
      priority: Priority.defaultPriority,
      playSound: true,
      enableLights: true,
      ongoing: false,
      visibility: NotificationVisibility.public,
      icon: 'ic_launcher_foreground',
    );
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails);
    final notifTime = tz.TZDateTime.parse(tz.local, food.scheduledEndTime);

    localNotification.zonedSchedule(
      0,
      'CALORIMETER',
      mes,
      //tz.TZDateTime.now(tz.local).add(Duration(seconds: 2)),
      notifTime,
      generalNotificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: 'add',
    );
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => AddMealPage()),
    );
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final food = Provider.of<Meals>(context, listen: false);
      final theme = Provider.of<ThemeHandler>(context, listen: false);
      Future.delayed(Duration(milliseconds: 400), () {
        Provider.of<Users>(context, listen: false)
            .fetchAndSetUserDB()
            .then((value) => {
                  Provider.of<Meals>(context, listen: false)
                      .fetchAndSetDB()
                      .then((value) {
                    Provider.of<Meals>(context, listen: false)
                        .fetchAndSetGoals()
                        .then((value) {
                      Provider.of<Meals>(context, listen: false)
                          .getStreak()
                          .then((value) async {
                        setState(() {
                          _isLoading = false;
                        });

                        print(rng.toString());
                        if (theme.perm2Not == true) {
                          if (food.recentMeals.length > 0) {
                            if (DateTime.now()
                                    .difference(DateTime.parse(food
                                        .recentMeals[
                                            food.recentMeals.length - 1]
                                        .date))
                                    .inHours <
                                22) {
                              showNotif(
                                  'Your streak will be lost in 1 hour.\nDon\'t forget to add your meals!');
                            } else {
                              showNotif('Don\'t lose your streak today!');
                            }
                          } else {
                            if (rng.remainder(3) == 0) {
                              print("bildirim var");
                            }
                            showNotif('Let\'s start a streak today!');
                          }
                        } else {
                          await localNotification.cancelAll();
                        }
                      }).catchError((e) {
                        //print("There was an error: ${e.toString()}");
                        setState(() {
                          _isLoading = false;
                        });
                      });
                    });
                  })
                });
      });
    }
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await localNotification.pendingNotificationRequests();
    print('notifications: ${pendingNotificationRequests.length}');
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    homeController.dispose();
    super.dispose();
  }

  void _toggleVisibilty() {
    setState(() {
      _isProfileVisible = !_isProfileVisible;
    });
  }

  void _toggleToday() {
    setState(() {
      _isTodayVisible = !_isTodayVisible;
    });
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          'Tap back button to exit',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
        ),
      ));
      return Future.value(false);
    }

    return Future.value(true);
  }

  DateTime currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    final food = Provider.of<Meals>(context);
    final user = Provider.of<Users>(context);
    final dummy = user.users[0];

    Size size = MediaQuery.of(context).copyWith(textScaleFactor: 1).size;
    Calculator calc = Calculator();

    return WillPopScope(
      //onWillPop: () async => false,
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: scafRenk,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 75,
          backgroundColor: primaryMavi,
          title: FittedBox(fit: BoxFit.contain, child: AppBarTitle()),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(50, 30),
                  alignment: Alignment.center),
              onPressed: () {
                food.getStreak();
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            side:
                                BorderSide(color: Color(0xff707070), width: 2),
                            borderRadius: BorderRadius.circular(40)),
                        backgroundColor: buttonRenk,
                        elevation: 1,
                        child: Container(
                          height: size.height * 0.4,
                          width: size.height * 0.4,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                food.streak > 20
                                    ? 'Fantastic!\nYou have ${food.streak} days streak!'
                                    : food.streak == 0
                                        ? 'You have no streak.\n\nSave meals\nto keep your streak going!'
                                        : food.streak > 1
                                            ? 'You are doing great!\nYou have ${food.streak} days streak!'
                                            : 'You have ${food.streak} day streak!\nKeep going!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                  color: basRenk,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              },
              child: Row(
                children: [
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(food.streakIcon, size: 32, color: basRenk),
                  ),
                  SizedBox(width: 5),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "${food.streak}",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: basRenk,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: MyMenuBtn(),
            )
          ],
        ),
        floatingActionButton: Container(
          height: size.height * 0.11,
          width: size.width * 0.18,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AddMealPage.routeName),
              elevation: 10,
              child: Center(
                child: Icon(
                  Icons.add,
                  size: size.height * 0.05,
                ),
              ),
              backgroundColor: primaryMavi,
              tooltip: 'You can add your foods with this button!',
            ),
          ),
        ),
        body: SingleChildScrollView(
          controller: homeController,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: HelloDummy(
                      func: _toggleVisibilty,
                      isim:
                          "${dummy.userName[0].toUpperCase()}${dummy.userName.substring(1).toLowerCase()}",
                      opac: _isLoading),
                ),
                SizedBox(height: size.height * 0.02),
                Stack(
                  children: [
                    AnimatedContainer(
                      height: _isTodayVisible
                          ? size.height * 0.83
                          : size.height * 0.48,
                      duration: Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xff707070)),
                        color: contRenk,
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: _toggleToday,
                              child: TextWithButton(
                                text: "Today",
                                s: 34,
                                w: FontWeight.w600,
                                ico: _isTodayVisible
                                    ? Icon(
                                        Icons.expand_more_rounded,
                                        size: size.height * 0.05,
                                        color: basRenk,
                                      )
                                    : Icon(
                                        Icons.expand_less_outlined,
                                        size: size.height * 0.05,
                                        color: basRenk,
                                      ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            AnimatedContainer(
                              height: _isTodayVisible
                                  ? size.height * 0.5
                                  : size.height * 0.10,
                              duration: Duration(milliseconds: 150),
                              child: SingleChildScrollView(
                                physics: NeverScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _isLoading
                                        ? ProgressBar(
                                            title: "Calories",
                                            wid: size.width * 0.65,
                                            spend: 0.0,
                                            filled: (food.dailyCal).ceil(),
                                            goal:
                                                "${(food.recentGoals[food.currentGoal].calGoal).ceil()}$energyUnit",
                                          )
                                        : ProgressBar(
                                            title: "Calories",
                                            wid: size.width * 0.65,
                                            spend: (size.width * 0.65) *
                                                (food.dailyCal /
                                                    food
                                                        .recentGoals[
                                                            food.currentGoal]
                                                        .calGoal),
                                            filled: (food.dailyCal).ceil(),
                                            goal:
                                                "${(food.recentGoals[food.currentGoal].calGoal).ceil()}$energyUnit",
                                          ),
                                    ProgressBar(
                                      title: "Carbs",
                                      wid: size.width * 0.5,
                                      spend: (size.width * 0.5) *
                                          (food.dailyCarb /
                                              food.recentGoals[food.currentGoal]
                                                  .carbGoal),
                                      filled: (food.dailyCarb).ceil(),
                                      goal:
                                          "${(food.recentGoals[food.currentGoal].carbGoal).ceil()}$portionUnit",
                                    ),
                                    ProgressBar(
                                      title: "Proteins",
                                      wid: size.width * 0.5,
                                      spend: (size.width * 0.5) *
                                          (food.dailyProtein /
                                              food.recentGoals[food.currentGoal]
                                                  .proteinGoal),
                                      filled: (food.dailyProtein).ceil(),
                                      goal:
                                          "${(food.recentGoals[food.currentGoal].proteinGoal).ceil()}$portionUnit",
                                    ),
                                    ProgressBar(
                                      title: "Fats",
                                      wid: size.width * 0.5,
                                      spend: (size.width * 0.5) *
                                          (food.dailyFat /
                                              food.recentGoals[food.currentGoal]
                                                  .fatGoal),
                                      filled: (food.dailyFat).ceil(),
                                      goal:
                                          "${(food.recentGoals[food.currentGoal].fatGoal).ceil()}$portionUnit",
                                    ),
                                    SizedBox(height: size.height * 0.012),
                                    InputChip(
                                      backgroundColor: buttonRenk,
                                      label: Text(
                                        'more details',
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontFamily: "Montserrat",
                                          color: basRenk,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      shape: BeveledRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(TodayDetails.routeName);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.015),
                            _isLoading ? LoadingFoodWidget() : LastMeals(),
                            SizedBox(height: size.height * 0.01),
                          ],
                        ),
                      ),
                    ),
                    ProfileScreen(
                      vis: _isProfileVisible,

                      toggle: _toggleVisibilty,
                      calGoal: calc.tdeeCalc(
                        dummy.gender,
                        dummy.userWeight,
                        dummy.userHeight,
                        dummy.userAge,
                        dummy.af,
                        dummy.userFatPerc,
                      ),
                      //calGoal: goal.recentGoals[goal.currentGoal].calGoal.round(),
                      userFatPerc: dummy.userFatPerc,
                      userHeight: dummy.userHeight,
                      userWeight: dummy.userWeight,
                      userAF: dummy.af,
                      userGender: dummy.gender,
                      userAge: dummy.userAge,
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.022),
                Summary(homeController),
                //NewSum(),
                References(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class References extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: size.height * 0.13,
        width: size.width,
        child: Text(
          'Food database is provided from \n$foodReference',
          style: TextStyle(
            fontSize: 16,
            fontFamily: "Montserrat",
            color: basRenk,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// HELLO TEXT
class HelloDummy extends StatelessWidget {
  HelloDummy({
    this.isim,
    this.func,
    this.opac,
  });
  final String isim;
  final opac;
  final Function func;
  final int saat = DateTime.now().hour;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedOpacity(
          opacity: opac ? 0.0 : 1.0,
          duration: Duration(milliseconds: 250),
          child: InkWell(
            enableFeedback: true,
            onTap: func,
            child: Text(
              ((0 <= saat && saat < 6) || saat > 21)
                  ? "Good night, $isim"
                  : (12 < saat && saat < 19)
                      ? "Good afternoon, $isim"
                      : (18 < saat && saat < 22)
                          ? "Good evening, $isim"
                          : "Good morning, $isim",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 34,
                color: basRenk,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// PROFILE SCREEN
class ProfileScreen extends StatelessWidget {
  final vis;
  final userAge;
  final toggle;
  final calGoal;
  final userHeight;
  final userWeight;
  final userFatPerc;
  final userAF;
  final userGender;

  const ProfileScreen(
      {this.vis,
      this.calGoal,
      this.toggle,
      this.userHeight,
      this.userWeight,
      this.userFatPerc,
      this.userAge,
      this.userAF,
      this.userGender});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      curve: Curves.decelerate,
      duration: Duration(milliseconds: 250),
      height: vis ? size.height * 0.6 : 0.0,
      width: size.width,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 80.0,
              offset: Offset(0, 15),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: basRenk),
          color: contRenk,
        ),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: size.height * .025,
                  right: size.width * .07,
                  left: size.width * .07,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                        color: basRenk,
                      ),
                    ),
                    ClipOval(
                      child: Material(
                        child: InkWell(
                          onTap: () => toggle(),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.grey[600],
                            size: 38,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: size.height * .025,
                  right: size.width * .06,
                  left: size.width * .06,
                ),
                width: size.width * .90,
                height: size.height * 0.45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: basRenk),
                  color: contRenk,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Height: $userHeight$lengthUnit',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                          color: basRenk,
                        ),
                      ),
                      Divider(
                        color: basRenk,
                        endIndent: 20,
                        height: 20,
                      ),
                      Text(
                        'Weight: $userWeight$weightUnit',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                          color: basRenk,
                        ),
                      ),
                      Divider(
                        color: basRenk,
                        endIndent: 20,
                        height: 20,
                      ),
                      userFatPerc == 0.0
                          ? SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Body Fat: $userFatPerc%',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Montserrat',
                                    color: basRenk,
                                  ),
                                ),
                                Divider(
                                  color: basRenk,
                                  endIndent: 20,
                                  height: 20,
                                ),
                              ],
                            ),
                      Text(
                        'Age: $userAge',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                          color: basRenk,
                        ),
                      ),
                      Divider(
                        color: basRenk,
                        endIndent: 20,
                        height: 20,
                      ),
                      Text(
                        'Gender: $userGender',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                          color: basRenk,
                        ),
                      ),
                      Divider(
                        color: basRenk,
                        endIndent: 20,
                        height: 20,
                      ),
                      Text(
                        'Activity Factor: $userAF',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                          color: basRenk,
                        ),
                      ),
                    ],
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

class LoadingFoodWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            color: Colors.black54,
            fontSize: 23,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: size.height * 0.001),
        Container(
          width: size.width * 0.45,
          height: size.height * 0.15,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: Column(
              children: [
                InputChip(
                  label: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 6,
                      ),
                      child: Text(
                        "Loading",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                InputChip(
                  label: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 6,
                      ),
                      child: Text(
                        "Loading",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
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
