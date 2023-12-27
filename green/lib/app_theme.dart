import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'WorkSans';

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle( // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle( // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle( // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle( // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle( // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle( // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle( // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );

 static const Color _darkPrimaryColor = Color(0xFF1F1F1F);
  static const Color _darkSecondaryColor = Color(0xFF373737);
  static const Color _darkOnPrimaryColor = Color(0xFFFFFFFF);

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _darkPrimaryColor,
    hintColor: Colors.tealAccent,
    scaffoldBackgroundColor: _darkPrimaryColor,
    cardColor: _darkSecondaryColor,
    textTheme: TextTheme(
      headline4: display1.copyWith(color: _darkOnPrimaryColor),
      headline5: headline.copyWith(color: _darkOnPrimaryColor),
      headline6: title.copyWith(color: _darkOnPrimaryColor),
      subtitle2: subtitle.copyWith(color: _darkOnPrimaryColor),
      bodyText2: body2.copyWith(color: _darkOnPrimaryColor),
      bodyText1: body1.copyWith(color: _darkOnPrimaryColor),
      caption: caption.copyWith(color: _darkOnPrimaryColor),
    ),
    iconTheme: IconThemeData(color: _darkOnPrimaryColor),
    appBarTheme: AppBarTheme(
      color: _darkSecondaryColor,
      iconTheme: IconThemeData(color: _darkOnPrimaryColor),
    ),
    // Define other theme properties as needed
  );

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: white,
    hintColor: grey,
    scaffoldBackgroundColor: nearlyWhite,
    cardColor: white,
    textTheme: textTheme,
    iconTheme: IconThemeData(color: nearlyBlack),
    appBarTheme: AppBarTheme(
      color: white,
      iconTheme: IconThemeData(color: nearlyBlack),
    ),
    // Define other theme properties as needed
  );


}
