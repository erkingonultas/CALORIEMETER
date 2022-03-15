import 'profile_provider.dart';

class Calculator {
  double bmr = 0;
  double _tde = 0;
  double _dietCal = 0;
  double _carb = 0;
  double _protein = 0;
  double _fat = 0;
  final dummy = Users().users[0];

  // ignore: missing_return
  double tdeeCalc(gender, weight, height, age, af, bf) {
    switch (gender) {
      case "Female":
        bmr = (10 * weight + 6.25 * height - age * 5 - 161);
        switch (af) {
          case "Sedentary":
            _tde = bmr * 1.2;
            return _tde.roundToDouble();
            break;
          case "Exercise 1-3 times/week":
            _tde = bmr * 1.375;
            return _tde.roundToDouble();
            break;
          case "Exercise 4-5 times/week":
            _tde = bmr * 1.465;
            return _tde.roundToDouble();
            break;
          case "Daily exercise or intense exercise 3-4 times/week":
            _tde = bmr * 1.55;
            return _tde.roundToDouble();
            break;
          case "Intense exercise 6-7 times/week":
            _tde = bmr * 1.725;
            return _tde.roundToDouble();
          case "Very intense exercise daily, or physical job":
            _tde = bmr * 1.9;
            return _tde.roundToDouble();
            break;
          default:
        }
        break;
      case "Male":
        bmr = (10 * weight + 6.25 * height - age * 5 + 5);
        switch (af) {
          case "Sedentary":
            _tde = bmr * 1.2;
            return _tde.roundToDouble();
            break;
          case "Exercise 1-3 times/week":
            _tde = bmr * 1.375;
            return _tde.roundToDouble();
            break;
          case "Exercise 4-5 times/week":
            _tde = bmr * 1.465;
            return _tde.roundToDouble();
            break;
          case "Daily exercise or intense exercise 3-4 times/week":
            _tde = bmr * 1.55;
            return _tde.roundToDouble();
            break;
          case "Intense exercise 6-7 times/week":
            _tde = bmr * 1.725;
            return _tde.roundToDouble();
          case "Very intense exercise daily, or physical job":
            _tde = bmr * 1.9;
            return _tde.roundToDouble();
            break;
          default:
        }
        break;
      default:
    }
  }

  // ignore: missing_return
  double calcDietCal(goal, cal) {
    if (goal != null) {
      switch (goal) {
        case "Slight Weight Loss (-0.25kg/week)":
          _dietCal = cal * 0.9;
          return _dietCal.roundToDouble();
          break;
        case "Weight Loss (-0.5kg/week)":
          _dietCal = cal * 0.79;
          return _dietCal.roundToDouble();
          break;
        case "Maintain Weight":
          _dietCal = cal;
          return _dietCal.roundToDouble();
          break;
        case "Slight Weight Gain (+0.25kg/week)":
          _dietCal = cal * 1.1;
          return _dietCal.roundToDouble();
          break;
        case "Weight Gain (+0.5kg/week)":
          _dietCal = cal * 1.21;
          return _dietCal.roundToDouble();
          break;
        default:
      }
    } else {
      _dietCal = cal * 1;
      return _dietCal.roundToDouble();
    }
  }

  List balancedCalc(cal) {
    final List diet = [];
    _carb = cal * 0.53 / 4;
    _protein = cal * 0.24 / 4;
    _fat = cal * 0.23 / 9;
    diet.add(_carb);
    diet.add(_protein);
    diet.add(_fat);
    return diet;
  }

  List highProteinCalc(cal) {
    final List diet = [];
    _carb = cal * 0.45 / 4;
    _protein = cal * 0.34 / 4;
    _fat = cal * 0.21 / 9;
    diet.add(_carb);
    diet.add(_protein);
    diet.add(_fat);
    return diet;
  }

  List lowFatCalc(cal) {
    final List diet = [];
    _carb = cal * 0.55 / 4;
    _protein = cal * 0.265 / 4;
    _fat = cal * 0.185 / 9;
    diet.add(_carb);
    diet.add(_protein);
    diet.add(_fat);
    return diet;
  }

  List lowCarbCalc(cal) {
    final List diet = [];
    _carb = cal * 0.43 / 4;
    _protein = cal * 0.30 / 4;
    _fat = cal * 0.27 / 9;
    diet.add(_carb);
    diet.add(_protein);
    diet.add(_fat);
    return diet;
  }
}
