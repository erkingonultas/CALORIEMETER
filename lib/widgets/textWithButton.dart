import 'package:caloriemeter/backend/constants.dart';
import 'package:flutter/material.dart';

class TextWithButton extends StatelessWidget {
  const TextWithButton({
    Key key,
    this.text,
    this.s,
    this.w,
    this.ico,
  }) : super(key: key);

  final String text;
  final double s;
  final FontWeight w;
  final Icon ico;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: s,
                fontFamily: "Montserrat",
                color: basRenk,
                fontWeight: w,
              ),
            ),
            ico,
          ],
        ),
        Container(
          height: 1,
          color: basRenk,
          width: size.width * 0.9,
          margin: EdgeInsets.only(top: 42),
        )
      ],
    );
  }
}
