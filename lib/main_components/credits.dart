import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../backend/constants.dart';

class Credit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: setBac,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          HapticFeedback.mediumImpact();
        },
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                Text(
                  "CALORIMETER",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1
                      ..color = basRenk,
                  ),
                ),
                Text(
                  "CALORIMETER",
                  style: TextStyle(
                    color: basRenk,
                    fontFamily: 'Montserrat',
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 14,
                        offset: Offset(9, 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Stack(
              children: [
                Text(
                  version,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1
                      ..color = basRenk,
                  ),
                ),
                Text(
                  version,
                  style: TextStyle(
                    color: basRenk,
                    fontFamily: 'Montserrat',
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 14,
                        offset: Offset(9, 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Stack(
              children: [
                Text(
                  "Designed by",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1
                      ..color = basRenk,
                  ),
                ),
                Text(
                  "Designed by",
                  style: TextStyle(
                    color: basRenk,
                    fontFamily: 'Montserrat',
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 14,
                        offset: Offset(9, 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Stack(
              children: [
                Text(
                  "Erkin GÖNÜLTAŞ",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1
                      ..color = basRenk,
                  ),
                ),
                Text(
                  "Erkin GÖNÜLTAŞ",
                  style: TextStyle(
                    color: basRenk,
                    fontFamily: 'Montserrat',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 14,
                        offset: Offset(9, 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        )),
      ),
    );
  }
}
