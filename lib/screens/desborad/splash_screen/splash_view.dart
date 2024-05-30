import 'dart:async';

import 'package:firebase_todo/screens/desborad/account/login_view.dart';
import 'package:firebase_todo/screens/pages/home_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => SplashViewState();
}

class SplashViewState extends State<SplashView> {
  static const String LOGIN_KEY = "LoggedIn";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    whereToGo();
  }

  // void SherPref()async{
  //  final SharedPreferences pref = await SharedPreferences.getInstance();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Colors.indigo,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/to-do.png",
            scale: 3,
          ),
          const Center(
            child: Text(
              "To-do List",
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// sherPref
  void whereToGo() async {
    var pref = await SharedPreferences.getInstance();

    var isLogin = pref.getBool(LOGIN_KEY);
    Timer(const Duration(seconds: 2), () async {
      // Widget navigateToPage = LoginScreen();

      if (isLogin != null) {
        if (isLogin) {
          //when true
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeView(),
              ));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginView(),
              ));
          // navigateToPage = SignUpScreen();
        }
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginView(),
            ));
        // navigateToPage = SignUpScreen();
      }
    });
  }
}
