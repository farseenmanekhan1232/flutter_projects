import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key, this.loading = true});

  bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 80,
            ),
            if (loading)
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.black),
                ),
              )
          ],
        ),
      ),
    );
  }
}
