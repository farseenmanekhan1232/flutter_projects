import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:news_app/screens/favourites/favourites.dart';
import 'package:news_app/screens/home/home.dart';
import 'package:news_app/screens/profile/profile.dart';
import 'package:news_app/screens/splash_screen.dart';

class News extends StatefulWidget {
  News({super.key, this.index});

  int? index;

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  int _index = 0;
  bool splash = true;
  late StreamSubscription<ConnectivityResult> connectionStatus;

  void _setIndex(int index) {
    setState(() {
      _index = index;
    });
  }

  late bool connectionState = true;

  void checkConnection() async {
    final result =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;
    setState(() {
      connectionState = result;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.index != null) _index = widget.index!;

    Timer(const Duration(milliseconds: 300), () {
      setState(() {
        splash = false;
      });
    });
    checkConnection();
    connectionStatus = Connectivity().onConnectivityChanged.listen((event) {
      setState(() {
        connectionState = ConnectivityResult.none != event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (splash) {
      return Scaffold(
        body: SplashScreen(loading: false),
      );
    }

    late Widget content;

    if (!connectionState) {
      return Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Check your Internet Connection',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      content = HomeScreen();
      if (_index == 1) content = FavouritesScreen();
      if (_index == 2) content = ProfileScreen();
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          currentIndex: _index,
          onTap: _setIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedIconTheme: const IconThemeData(color: Colors.grey),
          selectedIconTheme: const IconThemeData(color: Colors.black),
          items: const [
            BottomNavigationBarItem(
              label: "home",
              activeIcon: Icon(Icons.home_filled, size: 30),
              icon: Icon(
                Icons.home_filled,
              ),
            ),
            BottomNavigationBarItem(
              label: "favourite",
              activeIcon: Icon(
                Icons.bookmark,
                size: 30,
              ),
              icon: Icon(
                Icons.bookmark,
              ),
            ),
            BottomNavigationBarItem(
              label: "profile",
              activeIcon: Icon(
                Icons.account_circle,
                size: 30,
              ),
              icon: Icon(
                Icons.account_circle,
              ),
            ),
          ]),
      body: content,
    );
  }
}
