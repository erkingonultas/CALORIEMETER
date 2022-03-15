import 'package:flutter/material.dart';

import '../main_components/getDay.dart';

import 'textWithLine.dart';

class Summary extends StatelessWidget {
  final controller;
  //final dayController;

  const Summary(
    this.controller,
  );

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: GetDayPage(controller),
        ),
      ],
    );
  }
}
