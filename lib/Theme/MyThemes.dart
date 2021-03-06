import 'package:flutter/material.dart';

enum MyThemeKeys { LIGHT, DARK }

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.white,
    accentColor: Colors.black,
    brightness: Brightness.light,
    iconTheme: new IconThemeData(color: Colors.black),
    splashColor: Colors.white,
    backgroundColor: Colors.black


  );

  static final ThemeData darkTheme = ThemeData(

    primaryColor: Colors.grey,
    accentColor: Colors.white,
    brightness: Brightness.dark,
    iconTheme: new IconThemeData(color: Colors.white),
      splashColor: Colors.black,
      backgroundColor: Colors.white
  );



  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      default:
        return lightTheme;
    }
  }
}