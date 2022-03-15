import 'package:caloriemeter/backend/constants.dart';
import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(
        tag: "title",
        child: Stack(
          children: [
            Text(
              "CALORIMETER",
              style: TextStyle(
                decoration: TextDecoration.none,
                fontFamily: 'Montserrat',
                fontSize: 36,
                fontWeight: FontWeight.w700,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = basRenk,
              ),
            ),
            Text(
              "CALORIMETER",
              style: TextStyle(
                decoration: TextDecoration.none,
                color: basRenk,
                fontFamily: 'Montserrat',
                fontSize: 36,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
  }
}
