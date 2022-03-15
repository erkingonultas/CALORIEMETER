import 'package:caloriemeter/backend/constants.dart';

import '../main_components/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../main_components/credits.dart';

class MyMenuBtn extends StatelessWidget {
  const MyMenuBtn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.only(right: 40, left: 15),
      color: Colors.grey[300],
      icon: Hero(
          tag: "menubtn",
          child: Icon(
            Icons.menu,
            size: 50,
            color: basRenk,
          )),
      itemBuilder: (BuildContext ctx) => [
        PopupMenuItem(
          child: const Text(
            "Settings",
            style: TextStyle(
              fontSize: 26,
              fontFamily: "Montserrat",
              color: Color(0xff878585),
            ),
          ),
          value: SettingsPage(),
        ),
        PopupMenuItem(
          child: const Text(
            "About",
            style: TextStyle(
              fontSize: 26,
              fontFamily: "Montserrat",
              color: Color(0xff878585),
            ),
          ),
          value: Credit(),
        ),
      ],
      onSelected: (route) {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight,
                duration: Duration(milliseconds: 200),
                child: route));
      },
    );
  }
}
