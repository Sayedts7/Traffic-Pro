import 'package:flutter/material.dart';

class ThemeColors {
  static const mainColor =               Color(0xff32CCFE);

  static const black1 = Color(0xff000000);
  static const backgroundColor = Color(0xFF2A2828);

  static const grey1 = Color(0xFF999999);
  static const grey2 = Color(0xFF85898C);
  static const grey3 = Color(0xFFF5F5F5);
  static const grey4 = Color(0xFF393640);
  static const grey5 = Color(0xffEFF2F1);
  static const darkGrey = Color(0xFF363340);
  static const yellow = Color(0xFFF0A215);
  static const red = Color(0xFFEA0000);
  static const mainDark = Color(0xFF720404);
  static const fillColor = Color(0xFFF5F5F5);
  static const fill2 = Color(0xff3c4043);

  static const List<Color> myColors = <Color>[
    Color(0xff1f005c),
    Color(0xff5b0060),
    Color(0xff870160),
    Color(0xffac255e),
    Color(0xffca485c),
    Color(0xffe16b5c),
    Color(0xfff39060),
    Color(0xffffb56b),
  ];

  static const Gradient myGradient = LinearGradient(
    colors: myColors,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class Palette {
  static const MaterialColor palette1 = MaterialColor(
    _palette1PrimaryValue,
    <int, Color>{
      50: Color(0xFFF1E0E0),
      100: Color(0xFFDCB3B3),
      200: Color(0xFFC58080),
      300: Color(0xFFAE4D4D),
      400: Color(0xFF9C2626),
      500: Color(_palette1PrimaryValue),
      600: Color(0xFF830000),
      700: Color(0xFF780000),
      800: Color(0xFF6E0000),
      900: Color(0xFF5B0000),
    },
  );




  static const int _palette1PrimaryValue = 0xFF8B0000;
}
