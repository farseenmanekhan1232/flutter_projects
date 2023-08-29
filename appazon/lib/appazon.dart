import 'dart:async';

import 'package:appazon/screens/auth/welcome.dart';
import 'package:appazon/screens/home/home.dart';
import 'package:appazon/screens/loader.dart';
import 'package:appazon/screens/splash_screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppazonApp extends StatefulWidget {
  const AppazonApp({super.key});
  @override
  State<AppazonApp> createState() => _AppazonAppState();
}

class _AppazonAppState extends State<AppazonApp> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SplashScreen();
    } else {
      return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          } else if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const WelcomeScreen();
          }
        },
      );
    }
  }
}
