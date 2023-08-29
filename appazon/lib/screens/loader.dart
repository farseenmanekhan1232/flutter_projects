import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 150,
            ),
          ),
          const SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
