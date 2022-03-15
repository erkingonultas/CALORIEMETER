import 'package:caloriemeter/backend/constants.dart';
import 'package:caloriemeter/backend/goals_provider.dart';
import 'package:caloriemeter/backend/profile_provider.dart';

import 'package:caloriemeter/main_components/welcome1.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home.dart';

class Splash extends StatefulWidget {
  static const routeName = '/splash';
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    final users = Provider.of<Users>(context, listen: false);
    final theme = Provider.of<ThemeHandler>(context, listen: false);

    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      theme.getDark();

      users.fetchAndSetUserDB().then((value) => {
            Provider.of<Meals>(context, listen: false)
                .fetchAndSetDB()
                .then((value) {
              Provider.of<Meals>(context, listen: false)
                  .fetchAndSetGoals()
                  .then((value) {
                setState(() {
                  _isLoading = false;
                });
                Future.delayed(Duration(milliseconds: 450), () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            users.isProfileExists ? HomePage() : Welcome1()),
                    (Route<dynamic> route) => false,
                  );
                });
              }).catchError((e) {
                //print("There was an error: ${e.toString()}");
                setState(() {
                  _isLoading = false;
                });
              });
            })
          });
    }

    _isInit = false;
    super.initState();
  }

  void enableDarkTheme() {
    setState(() {
      Color deg = Colors.grey[900];
      primaryMavi = deg;
      scafRenk = Colors.black87;
      contRenk = Colors.grey[600];
      basRenk = Colors.white60;
      buttonRenk = Colors.grey[800];
      recRenk = basRenk;
      setBac = primaryMavi;
      fillRenk = Colors.white60;
      errorRenk = Colors.white;
      Theme.of(context).copyWith(
        primaryColor: deg,
        highlightColor: deg,
        splashColor: deg,
        hoverColor: deg,
        buttonColor: deg,
        focusColor: deg,
      );
    });
  }

  void disableDarkTheme() {
    setState(() {
      {
        primaryMavi = Color(0xff7BBDFF);
        errorRenk = Colors.redAccent[700];
        setBac = Colors.white;
        basRenk = Color(0xff737373);
        buttonRenk = Colors.grey[100];
        recRenk = Colors.black54;
        scafRenk = Colors.grey[300];
        contRenk = Color(0xffffffff);
        fillRenk = primaryMavi;
        Theme.of(context).copyWith(
          primaryColor: Color(0xff7BBDFF),
          highlightColor: Color(0xff7BBDFF),
          splashColor: Color(0xff7BBDFF),
          hoverColor: Color(0xff7BBDFF),
          buttonColor: Color(0xff7BBDFF),
          focusColor: Color(0xff7BBDFF),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //final users = Provider.of<Users>(context, listen: false);
    final theme = Provider.of<ThemeHandler>(context, listen: false);
    Size size = MediaQuery.of(context).size;

    theme.isDark ? enableDarkTheme() : disableDarkTheme();
    return Scaffold(
      backgroundColor: primaryMavi,
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: (size.width).toDouble() * 0.05),
        child: Center(
            child: FittedBox(
          fit: BoxFit.contain,
          child: AnimatedOpacity(
            curve: Curves.decelerate,
            duration: Duration(milliseconds: 350),
            opacity: _isLoading ? 0.0 : 1.0,
            child: Stack(
              children: [
                Text(
                  "CALORIMETER",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 55,
                    fontWeight: FontWeight.w900,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 4
                      ..color = Color(0xff707070),
                  ),
                ),
                Text(
                  "CALORIMETER",
                  style: TextStyle(
                    color: Color(0xffFBFCFE),
                    fontFamily: 'Montserrat',
                    fontSize: 55,
                    fontWeight: FontWeight.w900,
                  ),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
