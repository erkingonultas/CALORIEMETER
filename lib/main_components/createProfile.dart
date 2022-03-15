import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'dart:math';
import '../backend/constants.dart';
import '../backend/profile_provider.dart';
import './createGoal.dart';
import '../widgets/appBarTitle.dart';

class CreateProfile extends StatefulWidget {
  static const String routeName = "/createProfile";
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final _customizeProfileController = GlobalKey<FormState>();
  final _profileCustController = ScrollController();
  bool _isbodyfatVis = false;

  void _showBodyFat() {
    if (_isbodyfatVis == false) {
      Timer(Duration(milliseconds: 200), () {
        try {
          _profileCustController.animateTo(
              _profileCustController.position.maxScrollExtent,
              duration: Duration(milliseconds: 200),
              curve: Curves.decelerate);
        } catch (e) {
          //print(e.toString());
        }
      });
    }
    setState(() {
      _isbodyfatVis = true;
    });
  }

  @override
  void dispose() {
    _profileCustController.dispose();
    super.dispose();
  }

  void _hideBodyFat() {
    setState(() {
      _isbodyfatVis = false;
    });
  }

  var _updatedProfile = User(
    gender: " ",
    userAge: 0,
    userFatPerc: 0,
    userHeight: 0,
    userName: " ",
    userWeight: 0,
    af: "None",
  );
  void _updateProfile() {
    final isValid = _customizeProfileController.currentState.validate();
    if (!isValid) {
      return;
    }
    _customizeProfileController.currentState.save();
    showDialog(
      barrierColor: Colors.black.withOpacity(0.1),
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Please confirm", style: TextStyle(fontSize: 24)),
        content: Text("You can change your profile from the settings later.",
            style: TextStyle(fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("No", style: TextStyle(fontSize: 21)),
          ),
          TextButton(
            onPressed: () {
              Provider.of<Users>(context, listen: false)
                  .updateProfileDb(_updatedProfile)
                  .then((value) => {
                        //print("profil oluşturuldu"),
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => CreateGoal()),
                          (Route<dynamic> route) => false,
                        ),
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text(
                              'Your profile has been created successfully!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Montserrat'),
                            ))),
                      })
                  .catchError((error) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("There is something wrong."),
                    content: Text("Your profile couldn't created."),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              });
            },
            child: Text("Yes", style: TextStyle(fontSize: 21)),
          ),
        ],
      ),
    );
  }

  String _dropdownValue;
  String _dropafValue;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: scafRenk,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 75,
          backgroundColor: setBac,
          title: Center(child: AppBarTitle()),
        ),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Text(
                  "Create Your Profile",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 34,
                    color: basRenk,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  height: size.height * 0.75,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[600],
                        blurRadius: 40.0,
                        offset: Offset(0, 25),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: basRenk),
                    color: contRenk,
                  ),
                  child: SingleChildScrollView(
                    controller: _profileCustController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15),
                      child: Form(
                        key: _customizeProfileController,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: errorRenk),
                                helperStyle: TextStyle(color: basRenk),
                                hintText: 'Name',
                                hintStyle: hintStyle2.copyWith(color: basRenk),
                                focusColor: Color(0xff444444),
                              ),
                              style: style2.copyWith(color: basRenk),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Name cannot be empty.';
                                }
                                if (value.length > 12 || value.length < 2) {
                                  return 'Length of the name must be in the range of 2-12.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _updatedProfile = User(
                                  gender: _updatedProfile.gender,
                                  userAge: _updatedProfile.userAge,
                                  userFatPerc: _updatedProfile.userFatPerc,
                                  userHeight: _updatedProfile.userHeight,
                                  userName: value.toString(),
                                  userWeight: _updatedProfile.userWeight,
                                  af: _updatedProfile.af,
                                );
                              },
                            ),
                            SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 150,
                                  child: DropdownButtonFormField<String>(
                                    hint: Text(
                                      'Gender',
                                      style:
                                          hintStyle2.copyWith(color: basRenk),
                                    ),
                                    value: _dropdownValue,
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(color: errorRenk),
                                      helperStyle: TextStyle(color: basRenk),
                                      hintStyle: hintStyle3,
                                      focusColor: basRenk,
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_downward,
                                      color: Colors.grey,
                                    ),
                                    iconSize: 24,
                                    elevation: 16,
                                    dropdownColor: contRenk,
                                    style: style2,
                                    validator: (value) =>
                                        value == null ? 'Field required' : null,
                                    onChanged: (String value) {
                                      setState(() {
                                        _dropdownValue = value;
                                        _updatedProfile = User(
                                          gender: value.toString(),
                                          userAge: _updatedProfile.userAge,
                                          userFatPerc:
                                              _updatedProfile.userFatPerc,
                                          userHeight:
                                              _updatedProfile.userHeight,
                                          userName: _updatedProfile.userName,
                                          userWeight:
                                              _updatedProfile.userWeight,
                                          af: _updatedProfile.af,
                                        );
                                      });
                                    },
                                    items: <String>[
                                      'Male',
                                      'Female',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: SingleChildScrollView(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          child: Column(
                                            children: [
                                              Text(value,
                                                  style: style2.copyWith(
                                                      color: basRenk)),
                                              Divider(color: Colors.grey[800]),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: DropdownButtonFormField<String>(
                                    hint: Text(
                                      'Activity Factor',
                                      style:
                                          hintStyle2.copyWith(color: basRenk),
                                    ),
                                    value: _dropafValue,
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(color: errorRenk),
                                      helperStyle: TextStyle(color: basRenk),
                                      hintStyle: hintStyle3,
                                      focusColor: basRenk,
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_downward,
                                      color: Colors.grey,
                                    ),
                                    dropdownColor: contRenk,
                                    iconSize: 27,
                                    itemHeight: 105,
                                    elevation: 16,
                                    style: style2,
                                    isExpanded: true,
                                    validator: (value) =>
                                        value == null ? 'Field required' : null,
                                    onChanged: (String value) {
                                      setState(() {
                                        _dropafValue = value;
                                        _updatedProfile = User(
                                          gender: _updatedProfile.gender,
                                          userAge: _updatedProfile.userAge,
                                          userFatPerc:
                                              _updatedProfile.userFatPerc,
                                          userHeight:
                                              _updatedProfile.userHeight,
                                          userName: _updatedProfile.userName,
                                          userWeight:
                                              _updatedProfile.userWeight,
                                          af: value.toString(),
                                        );
                                      });
                                    },
                                    items: <String>[
                                      'Sedentary',
                                      'Exercise 1-3 times/week',
                                      'Exercise 4-5 times/week',
                                      'Daily exercise or intense exercise 3-4 times/week',
                                      'Intense exercise 6-7 times/week',
                                      'Very intense exercise daily, or physical job',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: SingleChildScrollView(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          child: Column(
                                            children: [
                                              Text(value,
                                                  style: style2.copyWith(
                                                      color: basRenk)),
                                              Divider(color: Colors.grey[800]),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: errorRenk),
                                helperStyle: TextStyle(color: basRenk),
                                hintText: 'Age',
                                hintStyle: hintStyle2.copyWith(color: basRenk),
                                focusColor: Color(0xff444444),
                              ),
                              maxLength: 2,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    new RegExp('[0-9]')),
                              ],
                              keyboardType: TextInputType.number,
                              style: style2.copyWith(color: basRenk),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Age cannot be empty.';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                if (double.parse(value) < 15) {
                                  return 'Age must be a valid number.';
                                }
                                if (double.parse(value) > 99) {
                                  return 'Age must be a valid number.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _updatedProfile = User(
                                  gender: _updatedProfile.gender,
                                  userAge: int.parse(value),
                                  userFatPerc: _updatedProfile.userFatPerc,
                                  userHeight: _updatedProfile.userHeight,
                                  userName: _updatedProfile.userName,
                                  userWeight: _updatedProfile.userWeight,
                                  af: _updatedProfile.af,
                                );
                              },
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: errorRenk),
                                helperStyle: TextStyle(color: basRenk),
                                hintText: 'Weight (kg)',
                                hintStyle: hintStyle2.copyWith(color: basRenk),
                                focusColor: Color(0xff444444),
                              ),
                              maxLength: 3,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    new RegExp('[0-9]')),
                              ],
                              keyboardType: TextInputType.number,
                              style: style2.copyWith(color: basRenk),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Weight cannot be empty.';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                if (double.parse(value) < 35) {
                                  return 'Weight must be a valid number.';
                                }
                                if (double.parse(value) > 200) {
                                  return 'Weight must be a valid number.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _updatedProfile = User(
                                  gender: _updatedProfile.gender,
                                  userAge: _updatedProfile.userAge,
                                  userFatPerc: _updatedProfile.userFatPerc,
                                  userHeight: _updatedProfile.userHeight,
                                  userName: _updatedProfile.userName,
                                  userWeight: int.parse(value),
                                  af: _updatedProfile.af,
                                );
                              },
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: errorRenk),
                                helperStyle: TextStyle(color: basRenk),
                                hintText: 'Height (cm)',
                                hintStyle: hintStyle2.copyWith(color: basRenk),
                                focusColor: Color(0xff444444),
                              ),
                              maxLength: 3,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    new RegExp('[0-9]')),
                              ],
                              keyboardType: TextInputType.number,
                              style: style2.copyWith(color: basRenk),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Height cannot be empty.';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                if (double.parse(value) < 140) {
                                  return 'Height must be a valid number.';
                                }
                                if (double.parse(value) > 230) {
                                  return 'Height must be a valid number.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _updatedProfile = User(
                                  gender: _updatedProfile.gender,
                                  userAge: _updatedProfile.userAge,
                                  userFatPerc: _updatedProfile.userFatPerc,
                                  userHeight: int.parse(value),
                                  userName: _updatedProfile.userName,
                                  userWeight: _updatedProfile.userWeight,
                                  af: _updatedProfile.af,
                                );
                              },
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: size.width * .7,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(color: errorRenk),
                                      helperStyle: TextStyle(color: basRenk),
                                      hintText:
                                          'Body Fat Percentage (optional)',
                                      hintStyle: hintStyle2.copyWith(
                                        color: basRenk,
                                        fontSize: 18,
                                      ),
                                      focusColor: Color(0xff444444),
                                    ),
                                    maxLength: 2,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          new RegExp('[0-9]')),
                                    ],
                                    keyboardType: TextInputType.number,
                                    style: style2.copyWith(color: basRenk),
                                    validator: (value) {
                                      if (value.isNotEmpty) {
                                        if (double.parse(value) <= 0) {
                                          return 'Please enter a valid number';
                                        }
                                        if (double.parse(value) > 40) {
                                          return 'Body fat is too high.';
                                        }
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      if (value.isEmpty) {
                                        _updatedProfile = User(
                                          gender: _updatedProfile.gender,
                                          userAge: _updatedProfile.userAge,
                                          userFatPerc: 0.0,
                                          userHeight:
                                              _updatedProfile.userHeight,
                                          userName: _updatedProfile.userName,
                                          userWeight:
                                              _updatedProfile.userWeight,
                                          af: _updatedProfile.af,
                                        );
                                      } else {
                                        _updatedProfile = User(
                                          gender: _updatedProfile.gender,
                                          userAge: _updatedProfile.userAge,
                                          userFatPerc: double.parse(value),
                                          userHeight:
                                              _updatedProfile.userHeight,
                                          userName: _updatedProfile.userName,
                                          userWeight:
                                              _updatedProfile.userWeight,
                                          af: _updatedProfile.af,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Tooltip(
                                  message:
                                      'Don\'t know your body fat amount? Press this button to calcute!',
                                  textStyle: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Montserrat',
                                    color: Colors.white60,
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Shimmer.fromColors(
                                    period: Duration(milliseconds: 750),
                                    baseColor: basRenk,
                                    highlightColor: primaryMavi,
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.info_outline_rounded,
                                          size: 40,
                                          //color: Colors.grey[600],
                                        ),
                                        onPressed: () {
                                          _showBodyFat();
                                        }),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 30),
                            AnimatedOpacity(
                              opacity: _isbodyfatVis ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 150),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                height: _isbodyfatVis ? size.height * 0.65 : 0,
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[500],
                                      blurRadius: 10.0,
                                      offset: Offset(0, 15),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: basRenk),
                                  color: contRenk,
                                ),
                                child: SingleChildScrollView(
                                  physics: NeverScrollableScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, top: 15),
                                        child: ClipOval(
                                          child: Material(
                                            color: basRenk,
                                            child: InkWell(
                                              onTap: () => _hideBodyFat(),
                                              child: Icon(
                                                Icons.close_rounded,
                                                color: contRenk,
                                                size: 34,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      BodyFatCalculator(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.025),
                            TextButton(
                              onPressed: () {
                                _updateProfile();
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(
                                      color: basRenk,
                                    ),
                                  ),
                                ),
                              ),
                              child: Container(
                                child: Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Montserrat',
                                    color: basRenk,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BodyFatCalculator extends StatefulWidget {
  @override
  _BodyFatCalculatorState createState() => _BodyFatCalculatorState();
}

class _BodyFatCalculatorState extends State<BodyFatCalculator> {
  final _bodyfatController = GlobalKey<FormState>();
  bool _isCalculated = false;

  void _calculated() {
    setState(() {
      _isCalculated = true;
    });
  }

  final TextStyle hintStyle = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.w600,
    fontFamily: 'Montserrat',
    color: basRenk,
  );

  final TextStyle style = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    fontFamily: 'Montserrat',
    color: basRenk,
  );

  final TextStyle style2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    fontFamily: 'Montserrat',
    color: basRenk,
  );

  String dropdownValue;
  String gender = 'Male';

  double waist = 0;
  double height = 0;
  double neck = 0;
  double hip = 0;
  double bodyFat = 0;

  void _calculateBodyFat() {
    final isValid = _bodyfatController.currentState.validate();
    if (!isValid) {
      return;
    }
    _bodyfatController.currentState.save();
    //print('$waist, $neck, $height');
    if (dropdownValue == 'Male') {
      double logwn = log(waist - neck) / log(10);
      double logh = log(height) / log(10);
      double asagi1 = 1.0324 - (0.19077 * logwn);
      double asagi2 = 0.15456 * logh;
      //print('$logwn, $logh, $asagi1, $asagi2');
      setState(() {
        bodyFat = (495.0 / (asagi1 + asagi2)) - 450.0;
      });
    } else if (dropdownValue == 'Female') {
      double logwn = log(waist + hip - neck) / log(10);
      double logh = log(height) / log(10);
      double asagi1 = 1.29579 - (0.35004 * logwn);
      double asagi2 = 0.22100 * logh;
      setState(() {
        bodyFat = (495.0 / (asagi1 + asagi2)) - 450.0;
      });
    }
    _calculated();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isCalculated
          ? Column(
              children: [
                ((bodyFat < 45 && bodyFat > 4) && !bodyFat.isNaN)
                    ? Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Body Fat Calculator\n\nYour body fat is ${bodyFat.ceil()}%\n\nPlease keep in mind that this result is an accurate estimation.',
                            style: style2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Body Fat Calculator\n\nPlease enter consistent values.',
                            style: style2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                Container(
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    child: Container(
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                          color: basRenk,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isCalculated = false;
                        waist = 0;
                        height = 0;
                        neck = 0;
                        hip = 0;
                        bodyFat = 0;
                      });
                    },
                  ),
                )
              ],
            )
          : Form(
              key: _bodyfatController,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text('Body Fat Calculator', style: style2),
                    Divider(
                      height: 15,
                      color: Colors.grey[400],
                      thickness: 2,
                      endIndent: 15,
                      indent: 15,
                    ),
                    Container(
                      width: 250,
                      child: DropdownButtonFormField<String>(
                        hint: Text('Gender',
                            style: hintStyle2.copyWith(color: basRenk)),
                        value: dropdownValue,
                        icon: const Icon(
                          Icons.arrow_downward,
                          color: Colors.grey,
                        ),
                        dropdownColor: contRenk,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(color: errorRenk),
                          helperStyle: TextStyle(color: basRenk),
                          hintStyle: hintStyle3,
                          focusColor: basRenk,
                        ),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                          color: Color(0xff444444),
                        ),
                        validator: (value) =>
                            value == null ? 'Field required' : null,
                        onChanged: (String value) {
                          setState(() {
                            dropdownValue = value;
                            gender = value;
                          });
                        },
                        items: <String>[
                          'Male',
                          'Female',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  Text(value,
                                      style: style.copyWith(color: basRenk)),
                                  Divider(color: Colors.grey[800]),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: errorRenk),
                        helperStyle: TextStyle(color: basRenk),
                        hintText: 'Waist Circumference (cm)',
                        focusColor: Color(0xff444444),
                        hintStyle: hintStyle,
                      ),
                      maxLength: 3,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(new RegExp('[0-9]')),
                      ],
                      keyboardType: TextInputType.number,
                      style: style,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This area cannot be empty.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) < 40) {
                          return 'This must be a valid number.';
                        }
                        if (double.parse(value) > 150) {
                          return 'This must be a valid number.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          waist = double.parse(value);
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: errorRenk),
                        helperStyle: TextStyle(color: basRenk),
                        hintText: 'Neck Circumference (cm)',
                        focusColor: Color(0xff444444),
                        hintStyle: hintStyle,
                      ),
                      maxLength: 3,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(new RegExp('[0-9]')),
                      ],
                      keyboardType: TextInputType.number,
                      style: style,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This area cannot be empty.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) < 10) {
                          return 'This must be a valid number.';
                        }
                        if (double.parse(value) > 95) {
                          return 'This must be a valid number.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          neck = double.parse(value);
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: errorRenk),
                        helperStyle: TextStyle(color: basRenk),
                        hintText: 'Height (cm)',
                        focusColor: Color(0xff444444),
                        hintStyle: hintStyle,
                      ),
                      maxLength: 3,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(new RegExp('[0-9]')),
                      ],
                      keyboardType: TextInputType.number,
                      style: style,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Height cannot be empty.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) < 140) {
                          return 'Height must be a valid number.';
                        }
                        if (double.parse(value) > 230) {
                          return 'Height must be a valid number.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          height = double.parse(value);
                        });
                      },
                    ),
                    (gender == 'Female')
                        ? TextFormField(
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: errorRenk),
                              helperStyle: TextStyle(color: basRenk),
                              hintText: 'Hip Circumference (cm)',
                              focusColor: Color(0xff444444),
                              hintStyle: hintStyle,
                            ),
                            maxLength: 3,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  new RegExp('[0-9]')),
                            ],
                            keyboardType: TextInputType.number,
                            style: style,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'This area cannot be empty.';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              if (double.parse(value) < 10) {
                                return 'This must be a valid number.';
                              }
                              if (double.parse(value) > 95) {
                                return 'This must be a valid number.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                hip = double.parse(value);
                              });
                            },
                          )
                        : SizedBox(height: 25),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        _calculateBodyFat();
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                        child: Text(
                          'Calculate',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Montserrat',
                            color: basRenk,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
