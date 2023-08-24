import 'dart:async';

import 'package:appazon/screens/home/home.dart';
import 'package:appazon/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

class AppazonApp extends StatefulWidget {
  @override
  State<AppazonApp> createState() => _AppazonAppState();
}

class _AppazonAppState extends State<AppazonApp> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
