import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import "package:google_sign_in/google_sign_in.dart";

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String? user;

  facebookLogin() async {
    print("FaceBook");
    try {
      final result =
          await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData();

        setState(() {
          user = userData['name'];
        });
      }
    } catch (error) {
      print(error);
    }
  }

  googleLogin() async {
    try {
      print("googleLogin method Called");
      final googleSignIn = GoogleSignIn();
      var result = await googleSignIn.signIn();
      setState(() {
        user = result?.displayName;
      });
    } catch (e) {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(user ?? "No user"),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: googleLogin,
              child: const Text('Google Signin'),
            ),
            ElevatedButton(
              onPressed: facebookLogin,
              child: const Text('Facebook Signin'),
            )
          ],
        ));
  }
}
