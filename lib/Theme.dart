import 'package:flutter/material.dart';
import 'Constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
  iconTheme: IconThemeData(
    color: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.white,
  tabBarTheme: TabBarTheme(
    labelColor: Colors.black,
  ),
  textTheme: TextTheme(
    headline6: TextStyle(color: Colors.black),
    caption: TextStyle(color: Colors.white54),
    subtitle1: TextStyle(color: Colors.black.withOpacity(0.8)),
    subtitle2: TextStyle(color: Colors.black.withOpacity(0.6)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
      color: Constants.primary_dark,
      fontWeight: FontWeight.bold,
    ),
    textTheme: TextTheme(
        headline6: TextStyle(
          color: Constants.primary_dark,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        )
    ),
    actionsIconTheme: IconThemeData(
      color: Constants.primary_dark,
    ),
    iconTheme: IconThemeData(
      color: Constants.primary_dark,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Constants.primary_dark,
    backgroundColor: Colors.white,
    unselectedItemColor: Constants.primary_light,
  ),
  brightness: Brightness.light,
  accentColor: Constants.primary_light,
);

ThemeData dark = ThemeData(
  iconTheme: IconThemeData(
  color: Colors.white,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Constants.primary_dark,
    selectedItemColor: Colors.white,
  ),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Constants.primary_dark,
  textTheme: TextTheme(
    headline6: TextStyle(color: Colors.white),
    caption: TextStyle(color: Colors.white54),
    subtitle1: TextStyle(color: Colors.black.withOpacity(0.8)),
    subtitle2: TextStyle(color: Colors.black.withOpacity(0.6)),
  ),
  appBarTheme: AppBarTheme(
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
    titleTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
    color: Constants.primary_dark,
  ),
  tabBarTheme: TabBarTheme(
    labelColor: Colors.white,
  ),
  primaryColor: Constants.primary_light,
  primaryColorDark: Constants.primary_dark,
  accentColor: Constants.accent,
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  late SharedPreferences _prefs;
  late bool _darkTheme;
  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = false;//default condition
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initprefs() async{
    _prefs = await SharedPreferences.getInstance();
  }


  _loadFromPrefs() async{
    await _initprefs();
    _darkTheme = _prefs.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async{
    await _initprefs();
    _prefs.setBool(key, _darkTheme);
  }
}
