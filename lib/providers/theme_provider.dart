import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool? _isDarkTheme; //the default for light mode

  ThemeProvider() {
    getSavedTheme();
  }

  final lightTheme = ThemeData(
      primaryColor: const Color(0xFF085e55),
      appBarTheme: const AppBarTheme(
        color: Colors.white,
      ),
      textTheme: const TextTheme(
          headline1: TextStyle(
              color: Color(0xFF085e55),
              fontSize: 19,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold),
          bodyText1: TextStyle(
            fontFamily: "Poppins",
            color: Color(0xFF1DB06F),
          ),
          bodyText2: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              color: Colors.black)));

  final darkTheme = ThemeData(
      backgroundColor: Colors.black,
      primaryColor: Colors.black,
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        // backgroundColor: Colors.black,
        // foregroundColor: Colors.black,
        color: Colors.black,
      ),
      textTheme: const TextTheme(
          headline1: TextStyle(
              color: Color(0xFF085e55),
              fontSize: 19,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold),
          bodyText1: TextStyle(
            fontFamily: "Poppins",
            color: Color(0xFF1DB06F),
          ),
          bodyText2: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              color: Colors.black)));

  void getSavedTheme() async {
    var _sharedPreferences = await SharedPreferences.getInstance();
    _isDarkTheme = _sharedPreferences.getBool("themeType");
    // print("The theme mode is $_isLightTheme");
  }

  bool? get themeMode {
    getSavedTheme();
    if (_isDarkTheme == null) {
      return false;
    } else {
      return _isDarkTheme;
    }
  }

  ThemeData get currentTheme {
    if (_isDarkTheme == null) {
      return lightTheme;
    } else {
      if (_isDarkTheme!) {
        return darkTheme;
      } else {
        return lightTheme;
      }
    }
  }

  void saveTheme(bool value) async {
    var _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.setBool("themeType", value);
    notifyListeners();
  }
}
