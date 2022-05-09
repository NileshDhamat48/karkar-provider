import 'package:flutter/material.dart';
import 'package:karkar_provider_app/constants/app_colors.dart';

abstract class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: AppColors.primaryMaterialColor,
    primaryColor: AppColors.primaryColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appbarBgColor,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.blackColor,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      iconTheme: IconThemeData(
        color: AppColors.blackColor,
      ),
    ),
    highlightColor: Colors.transparent,
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      isCollapsed: true,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 0.5,
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primaryColor,
          width: 1.5,
        ),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
      labelStyle: TextStyle(
        color: AppColors.blackColor.withOpacity(.92),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        fontSize: 14,
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.whiteColor,
          width: 1.5,
        ),
      ),
      disabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.whiteColor,
          // width: 0.5,
        ),
      ),
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      ),
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 96,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5,
      ),
      headline2: TextStyle(
        fontSize: 60,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.5,
      ),
      headline3: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w400,
      ),
      headline4: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      headline5: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
      ),
      headline6: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      subtitle1: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      bodyText1: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyText2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      button: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
      ),
      caption: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      overline: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.5,
      ),
    ),
  );
}
