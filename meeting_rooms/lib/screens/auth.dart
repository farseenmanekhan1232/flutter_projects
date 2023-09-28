import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meeting_rooms/widgets/text_feild.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            try {
              final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
              final GoogleSignInAuthentication gAuth =
                  await gUser!.authentication;
              final credentials = GoogleAuthProvider.credential(
                accessToken: gAuth.accessToken,
                idToken: gAuth.idToken,
              );
              await FirebaseAuth.instance.signInWithCredential(credentials);
            } catch (e) {
              throw Exception(e);
            }
          },
          child: Wrap(
            children: [
              Image.asset(
                'assets/images/google_logo.png',
                width: 30,
                height: 30,
              ),
              TextFieldReturn.textField('SignIn', Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
