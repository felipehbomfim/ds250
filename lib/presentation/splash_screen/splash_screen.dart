import 'dart:convert';
import 'dart:ui';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ds250/presentation/task_screen/task_creen.dart';
import 'package:flutter/material.dart';
import 'package:ds250/core/app_export.dart';
import 'package:ds250/presentation/home_screen/home_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');

    if (userDataString != null) {
      Map<String, dynamic> userDataMap = json.decode(userDataString);
      UserModel user = UserModel.fromJson(userDataMap);
      Provider.of<UserProvider>(context, listen: false).setUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
     return FutureBuilder(
       future: getUserData(),
       builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
         if (snapshot.connectionState == ConnectionState.done) {
           UserModel? user = Provider.of<UserProvider>(context).user;
           bool isLoggedIn = user?.manter_logado ?? false;
           return AnimatedSplashScreen(
             duration: 3000,
             splash: Lottie.asset(LottieConstant.lottieSplashScreen, repeat: false),
             splashIconSize: MediaQuery.of(context).size.height * 0.40,
             nextScreen: const HomeScreen(),
             backgroundColor: Colors.white,
             splashTransition: SplashTransition.decoratedBoxTransition,
             pageTransitionType: PageTransitionType.leftToRight,
           );
         } else {
           return const CircularProgressIndicator();
         }
       },
     );
  }
}