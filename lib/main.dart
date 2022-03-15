import 'package:caloriemeter/backend/constants.dart';
import 'package:caloriemeter/main_components/changeUnits.dart';
import 'package:caloriemeter/main_components/createGoal.dart';
import 'package:caloriemeter/main_components/resetComplete.dart';
import 'package:caloriemeter/widgets/addManual.dart';
import './backend/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_framework/responsive_framework.dart';
import './main_components/todayDetails.dart';
import './home.dart';
import './main_components/food2.dart';
import './main_components/food3.dart';
import 'backend/goals_provider.dart';
import 'backend/profile_provider.dart';
import 'main_components/addMeal.dart';
import './main_components/createProfile.dart';
import 'main_components/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Meals()),
          ChangeNotifierProvider(create: (ctx) => Days()),
          ChangeNotifierProvider(create: (ctx) => Users()),
          ChangeNotifierProvider(create: (ctx) => ThemeHandler()),
        ],
        child: MaterialApp(
          title: "CALORIMETER",
          theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          builder: (context, widget) => ResponsiveWrapper.builder(
              BouncingScrollWrapper.builder(context, widget),
              mediaQueryData: physicalHeight < 2100
                  ? MediaQuery.of(context).copyWith(textScaleFactor: 0.95)
                  : MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              maxWidth: 1200,
              minWidth: 450,
              defaultScale: true,
              breakpoints: [
                // ResponsiveBreakpoint.resize(600, name: MOBILE),
                // ResponsiveBreakpoint.autoScale(800, name: TABLET),
                // ResponsiveBreakpoint.autoScale(1200, name: TABLET),
                ResponsiveBreakpoint.resize(600, name: MOBILE),
                ResponsiveBreakpoint.autoScale(800, name: TABLET),
                ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
                ResponsiveBreakpoint.resize(450, name: MOBILE),
                ResponsiveBreakpoint.autoScale(800, name: TABLET),
                ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                ResponsiveBreakpoint.autoScale(2460, name: "4K"),
              ]),
          home: HomePage(),
          initialRoute: Splash.routeName,
          routes: {
            HomePage.routeName: (ctx) => HomePage(),
            Splash.routeName: (ctx) => Splash(),
            AddMealPage.routeName: (ctx) => AddMealPage(),
            CreateProfile.routeName: (ctx) => CreateProfile(),
            CreateGoal.routeName: (ctx) => CreateGoal(),
            ResetPage.routeName: (ctx) => ResetPage(),
            UnitsPage.routeName: (ctx) => UnitsPage(),
            AddManual.routeName: (ctx) => AddManual(),
          },
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case Food2.routeName:
                return PageTransition(
                  child: Food2(),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 150),
                  settings: settings,
                );
                break;
              case Food3.routeName:
                return PageTransition(
                  child: Food3(),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 150),
                  settings: settings,
                );
                break;
              case TodayDetails.routeName:
                return PageTransition(
                  child: TodayDetails(),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 150),
                  settings: settings,
                );
                break;
              default:
                return null;
            }
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (ctx) => HomePage());
          },
        ));
  }
}
//10,786