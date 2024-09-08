import 'package:flutter/material.dart';
import 'package:project1/colors.dart';

// Define your custom colors
class AppColors {
  static const Color primary = neonskyblue1;
  static const Color secondary = Colors.blueAccent;
  static const Color background = black1;
  static const Color text = white1;
  static const Color appBarBackground = black1;
  static const Color appBarText = white1;
}

// Define your custom theme
final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: AppColors.background,
  appBarTheme: const AppBarTheme(
    color: AppColors.appBarBackground,
    iconTheme: IconThemeData(color: AppColors.appBarText),
    titleTextStyle: TextStyle(
      color: AppColors.appBarText,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    centerTitle: true,  // 타이틀을 중앙에 정렬
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.text),
    bodyMedium: TextStyle(color: AppColors.text),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(AppColors.primary),
      foregroundColor: MaterialStateProperty.all(AppColors.background),
    ),
  ),
);
