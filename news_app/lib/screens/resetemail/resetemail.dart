import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResetEmailScreen extends StatelessWidget {
  const ResetEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  launchUrl(Uri.parse('mailto:'));
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed('/auth');
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 60,
                    ),
                    Text('Open Email')
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
