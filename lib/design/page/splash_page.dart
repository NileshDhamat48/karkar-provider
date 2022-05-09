import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_colors.dart';
import 'package:karkar_provider_app/main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _initTimer();
    super.initState();
  }

  void _initTimer() async {
    Timer(
      const Duration(seconds: 3),
      checkUserData,
    );
  }

  Future checkUserData() async {
    final userResponse = await Utility.getUserPref();
    log("PREF USER DATA::::: ${userResponse?.toJson()}");
    if (userResponse != null && userResponse.token != null) {
      gotoHome();
    } else {
      gotoSignInPage();
    }
  }

  void gotoSignInPage() {
    navigatorKey.currentState?.pushAndRemoveUntil<Route>(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void gotoHome() {
    navigatorKey.currentState?.pushAndRemoveUntil<Route>(
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appbarBgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 2,
            child: Image.asset(
              'assets/images/logo.png',
            ),
          ),
        ],
      ),
    );
  }
}
