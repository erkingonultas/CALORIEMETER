import 'package:caloriemeter/backend/constants.dart';
import 'package:caloriemeter/backend/goals_provider.dart';
import 'package:caloriemeter/widgets/textWithLine.dart';
import 'package:caloriemeter/widgets/verticalBar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewSum extends StatefulWidget {
  @override
  _NewSumState createState() => _NewSumState();
}

class _NewSumState extends State<NewSum> {
  bool _toggle = false;
  _togglePress() {
    setState(() {
      _toggle = !_toggle;
    });
  }

  double firstX = 10;
  double firstY = 50;

  @override
  Widget build(BuildContext context) {
    final food = Provider.of<Meals>(context);
    final _daysFilled = food.daysFilled;
    final calStats = food.getCalStats;
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: const TextWithLine(text: "Summary", s: 38, w: FontWeight.w600),
        ),
        SizedBox(height: size.height * 0.013),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
          child: TextButton(
            onPressed: () => _togglePress(),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.decelerate,
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: _toggle ? size.height * 0.4 : size.height * 0.2,
              width: _toggle ? size.width * 0.6 : size.width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xff707070)),
                color: Color(0xffffffff),
              ),
              child: Column(
                children: [
                  Text(
                    "Calories",
                    style: style,
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.decelerate,
                    height: _toggle ? size.height * 0.32 : size.height * 0.13,
                    width: _toggle ? size.width * 0.53 : size.width * 0.24,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _daysFilled.length,
                        itemBuilder: (context, index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 55),
                              child: VerticalBar(
                                wid: _toggle
                                    ? size.width * 0.5
                                    : size.width * 0.25,
                                spend: _toggle
                                    ? (size.width * 0.5) *
                                        (calStats[index] /
                                            food.recentGoals[food.currentGoal]
                                                .calGoal)
                                    : ((size.width * 0.5) *
                                            (calStats[index] /
                                                food
                                                    .recentGoals[
                                                        food.currentGoal]
                                                    .calGoal)) /
                                        2,
                                filled: (calStats[index]),
                                goal:
                                    "${(food.recentGoals[food.currentGoal].calGoal).ceil()}$energyUnit",
                              ),
                            )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
