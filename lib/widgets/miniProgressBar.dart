import 'package:flutter/material.dart';
import '../backend/constants.dart';

class MiniProgressBar extends StatelessWidget {
  const MiniProgressBar({
    Key key,
    this.title,
    this.wid,
    this.spend,
    this.goal,
    this.filled,
  }) : super(key: key);

  final String title;
  final double wid;
  final double spend;
  final int filled;
  final String goal;
// default --> fontsize: 28,
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).copyWith(textScaleFactor: 1).size;
    double h = size.height * 0.04;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 26,
              fontFamily: "Montserrat",
              color: basRenk,
              fontStyle: FontStyle.italic,
            ),
          ),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    height: h,
                    width: wid,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        "$filled /$goal",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          color: basRenk,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: basRenk),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.easeOutQuint,
                    height: h,
                    width: spend < wid ? spend : wid,
                    decoration: BoxDecoration(
                      color: fillRenk.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: fillRenk.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
              if (spend >= wid)
                Icon(
                  Icons.check_rounded,
                  size: 30,
                  color: fillRenk.withOpacity(0.6),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
