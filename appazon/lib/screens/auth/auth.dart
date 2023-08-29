import "package:appazon/providers/user.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';
import "package:google_sign_in/google_sign_in.dart";
import "package:provider/provider.dart";

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  try {
                    Provider.of<AuthenticatedUser>(context, listen: false)
                        .googleAuth()
                        .then((user) {
                      if (mounted) {
                        Navigator.of(context).pushReplacementNamed('/home');
                      }
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Something went wrong")));
                  }
                },
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(166, 134, 134, 134),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign in with ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 56, 56, 56),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'assets/images/google.png',
                        width: 20,
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  try {
                    Provider.of<AuthenticatedUser>(context, listen: false)
                        .twitterAuth()
                        .then((user) {
                      if (mounted) {
                        Navigator.of(context).pushReplacementNamed('/home');
                      }
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Something went wrong")));
                  }
                },
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(166, 134, 134, 134),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign in with ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 56, 56, 56),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'assets/images/x.png',
                        width: 15,
                        height: 15,
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
