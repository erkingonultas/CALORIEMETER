import 'package:caloriemeter/backend/constants.dart';
import 'package:flutter/material.dart';

class TextWithLine extends StatelessWidget {
  const TextWithLine({
    Key key,
    this.text,
    this.s,
    this.w,
  }) : super(key: key);

  final String text;
  final double s;
  final FontWeight w;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: s,
            fontFamily: "Montserrat",
            color: basRenk,
            fontWeight: w,
          ),
        ),
        Container(
          height: 1,
          color: Color(0xff878585),
          width: size.width * 0.9,
          margin: EdgeInsets.only(top: 42),
        )
      ],
    );
  }
}
