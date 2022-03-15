import 'package:flutter/material.dart';

class VerticalBar extends StatelessWidget {
  const VerticalBar({
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
  final double filled;
  final String goal;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.bounceOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    height: wid,
                    width: size.width * 0.2,
                    // child: Padding(
                    //   padding: const EdgeInsets.only(right: 8.0),
                    //   child: Text(
                    //     "$filled /$goal",
                    //     style: TextStyle(
                    //         fontSize: 18,
                    //         fontFamily: "Montserrat",
                    //         color: Color(0xff878585),
                    //         fontWeight: FontWeight.w400),
                    //   ),
                    // ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Color(0xff707070)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: (spend >= wid) ? 0 : (spend - wid).abs()),
                    child: Container(
                      height: spend < wid ? (spend) : wid,
                      width: size.width * 0.2,
                      decoration: BoxDecoration(
                        color: Color(0xff7BBDFF).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: Color(0xff707070).withOpacity(0.5)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
