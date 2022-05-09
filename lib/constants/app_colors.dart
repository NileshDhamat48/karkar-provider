import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xff34c2a8);

  static const Color scaffoldbgcolor = Color(0xff1b1f28);
  static const Color whiteColor = Colors.white;
  static const Color tranparentColor = Colors.transparent;
  static const Color primaryBlueColor = Color(0xff00B2EE);
  static const Color greyBoxColor = Color(0xffEEEEEE);
  static Color greyText = Colors.grey.shade700;
  static Color redColor = Colors.red.shade600;
  static const Color greyColor = Colors.grey;
  static Color greyBorder = Colors.grey.shade400;
  static const Color blackColor = Colors.black;
  static Color lightGreyColor = Colors.grey.shade200;
  static const Color blackTextColor = Colors.black87;
  static const Color blacklightColor = Colors.black54;
  static const Color greenColor = Colors.green;
  static const Color appbarBgColor = Color(0xff1b1f28);
  static const Color languageBgcolor = Color(0xff232732);
  static const Color bottonNavigationColor = Color(0xff36c8ab);
  static const Color glassEffact = Color(0xff2e2c3a);
  static const Color bookingDetailscolor = Color(0xff2ab472);
  static const Color bookingDetailsIconcolor = Color(0xff34c2a8);
  static const Color bodybgcolor = Color(0xff242633);
  static const Color userbgcolor = Color(0xff2b2b37);
  static const Color red = Colors.red;
  static const Color lightGreen = Colors.lightGreen;
  static const Color reviewwIconColor = Colors.deepOrange;
  static Color commonButtonSplashColor = Colors.white.withOpacity(.1);

  static MaterialColor primaryMaterialColor = Colors.blue;

  // static Color blueColor = Colors.blue;

  static const Color gradientOne = Color(0xff00f282);

  static const Color gradiant1 = Colors.green;
  static const Color gradiant2 = Color(0xff34c2a8);
  static const Color gradentTwo = Color(0xff00a4da);

  static const Gradient appGradient = LinearGradient(
    colors: [
      // Color(0xff00f282),
      gradientOne,
      gradentTwo,
    ],
  );
  static const Gradient greyGradient = LinearGradient(
    colors: [
      // Color(0xff00f282),
      greyBoxColor,
      greyColor,
    ],
  );

  // static Color blueColor = Colors.blue;

  static const Gradient lineargradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.topRight,
    colors: [
      AppColors.gradentTwo,
      AppColors.gradientOne,
    ],
  );

  static const Gradient lineargradientGreenfirst = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.topRight,
    colors: [
      AppColors.gradientOne,
      AppColors.gradentTwo,
    ],
  );
  static const Gradient yellowLineargradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.topRight,
    colors: [
      Colors.yellowAccent,
      greyBoxColor,
    ],
  );
  static const Gradient redLineargradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.topRight,
    colors: [
      Colors.redAccent,
      greyBoxColor,
    ],
  );
  static const Gradient deepOrandeLineargradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.topRight,
    colors: [
      gradentTwo,
      greyBoxColor,
    ],
  );
}
