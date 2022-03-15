import 'package:caloriemeter/backend/constants.dart';
import 'package:caloriemeter/widgets/appBarTitle.dart';

import 'package:flutter/material.dart';

import '../home.dart';

class UnitsPage extends StatefulWidget {
  static const routeName = '/unitspage';
  @override
  _UnitsPageState createState() => _UnitsPageState();
}

class _UnitsPageState extends State<UnitsPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: scafRenk,
      appBar: AppBar(
        leading: BackButton(color: Color(0xff737373)),
        toolbarHeight: 75,
        backgroundColor: primaryMavi,
        title: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(HomePage.routeName);
            },
            child: AppBarTitle()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Hero(
          tag: 'notification',
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(15),
              height: size.height * 0.45,
              width: size.width * 0.9,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[600],
                    blurRadius: 40.0,
                    offset: Offset(0, 15),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xff707070)),
                color: contRenk,
              ),
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      'notifications: ',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 26,
                        fontFamily: "Montserrat",
                        color: basRenk,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      child: Text(
                        'enabled',
                        style: TextStyle(
                          decorationStyle: TextDecorationStyle.dotted,
                          decoration: TextDecoration.none,
                          fontSize: 26,
                          fontFamily: "Montserrat",
                          color: basRenk,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UnitLine extends StatelessWidget {
  const UnitLine(
    this.name,
    this.unit,
  );

  final String name;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(
            decoration: TextDecoration.none,
            fontFamily: "Montserrat",
            fontSize: 26,
            color: Color(0xff878585),
            fontWeight: FontWeight.w400,
          ),
        ),
        Row(
          children: [
            Text(
              unit,
              style: TextStyle(
                decoration: TextDecoration.none,
                fontFamily: "Montserrat",
                fontSize: 26,
                color: Color(0xff878585),
                fontWeight: FontWeight.w400,
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              color: Color(0xff878585),
              size: 30,
            ),
          ],
        ),
      ],
    );
  }
}
