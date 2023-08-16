import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news_app/screens/auth/auth.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key, this.again = false});

  bool again;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/welcome.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                decoration: const BoxDecoration(
                  // color: Colors.white.withOpacity(0.0),
                  gradient: LinearGradient(colors: [
                    Colors.transparent,
                    Color.fromARGB(90, 0, 0, 0),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Hero(
                tag: "assets/images/logo.png",
                child: Image.asset(
                  color: Colors.transparent,
                  "assets/images/logo.png",
                  width: 200,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 15, bottom: 10),
                child: Text(
                  "Welcome${again ? " back." : "."}",
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => AuthScreen(
                        login: false,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin:
                      const EdgeInsets.only(left: 10, bottom: 10, right: 10),
                  padding: const EdgeInsets.only(left: 20),
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(176, 0, 0, 0),
                    border: Border.all(
                      width: 1,
                      color: Color.fromARGB(99, 248, 248, 248),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        "Register here",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    "Already a user? ",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 233, 233, 233),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => AuthScreen(
                                login: true,
                              )));
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ],
      ),
    );
  }
}
