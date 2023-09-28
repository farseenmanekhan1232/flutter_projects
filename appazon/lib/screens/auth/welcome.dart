import 'dart:ui';

import 'package:appazon/screens/auth/auth.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          OrientationBuilder(builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 15, bottom: 10),
                    child: const Text(
                      "Welcome ",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const AuthScreen(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 10, bottom: 10, right: 10),
                      padding: const EdgeInsets.only(left: 20),
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(75, 0, 0, 0),
                        border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(99, 248, 248, 248),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            "Continue",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 20,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_back_ios,
                            textDirection: TextDirection.rtl,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 15, bottom: 10),
                        child: const Text(
                          "Welcome ",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const AuthScreen(),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 10, bottom: 10, right: 10),
                          padding: const EdgeInsets.only(left: 20),
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(75, 0, 0, 0),
                            border: Border.all(
                              width: 1,
                              color: const Color.fromARGB(99, 248, 248, 248),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                "Continue",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 20,
                                ),
                              ),
                              Icon(
                                Icons.arrow_back_ios,
                                textDirection: TextDirection.rtl,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ],
              );
            }
          }),
        ],
      ),
    );
  }
}
