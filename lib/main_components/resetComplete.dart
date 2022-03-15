import 'package:caloriemeter/backend/constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';

import 'createProfile.dart';

class ResetPage extends StatefulWidget {
  static const String routeName = "/resetPage";
  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> with TickerProviderStateMixin {
  AnimationController _animController;
  AnimationController _animController2;
  Animation<Offset> _animOffSet;
  Animation<Offset> _animOffSet2;
  bool animated = false;
  final int delay = 500;

  @override
  void initState() {
    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _animController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffSet =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, -0.05))
            .animate(curve);
    final curve2 =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController2);
    _animOffSet2 =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, 0.7))
            .animate(curve2);

    if (delay == null) {
      _animController.forward();
      _animController2.forward();
    } else {
      Timer(Duration(milliseconds: delay), () {
        _animController.forward();
      });
      Timer(Duration(milliseconds: 1500), () {
        _animController2.forward();
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animController.dispose();
    _animController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
              child: CreateProfile()),
          (Route<dynamic> route) => false,
        );
      },
      child: Scaffold(
        backgroundColor: primaryMavi,
        body: FadeTransition(
          opacity: _animController,
          child: SlideTransition(
            position: _animOffSet,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: [
                      Text(
                        'Your Profile',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 4
                            ..color = Color(0xff707070),
                        ),
                      ),
                      Text(
                        'Your Profile',
                        style: TextStyle(
                          color: Color(0xffFBFCFE),
                          fontFamily: 'Montserrat',
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Text(
                        "Has Been",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 4
                            ..color = Color(0xff707070),
                        ),
                      ),
                      Text(
                        "Has Been",
                        style: TextStyle(
                          color: Color(0xffFBFCFE),
                          fontFamily: 'Montserrat',
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Text(
                        "Successfully Reset",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 4
                            ..color = Color(0xff707070),
                        ),
                      ),
                      Text(
                        "Successfully Reset",
                        style: TextStyle(
                          color: Color(0xffFBFCFE),
                          fontFamily: 'Montserrat',
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.07),
                  FadeTransition(
                    opacity: _animController2,
                    child: SlideTransition(
                      position: _animOffSet2,
                      child: Stack(
                        children: [
                          Text(
                            'Tap to Proceed',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 4
                                ..color = Color(0xff707070),
                            ),
                          ),
                          Text(
                            'Tap to Proceed',
                            style: TextStyle(
                              color: Color(0xffFBFCFE),
                              fontFamily: 'Montserrat',
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
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
        ),
      ),
    );
  }
}
