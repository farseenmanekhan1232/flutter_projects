import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app/screens/resetemail/resetemail.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(30),
              height: 200,
              width: double.infinity,
              child: Container(
                // padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Email : ',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        Text(
                          currentUser!.email!,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 94, 94, 94),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.sendPasswordResetEmail(
                            email: FirebaseAuth.instance.currentUser!.email!);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const ResetEmailScreen(),
                          ),
                        );
                      },
                      child: const Text('Reset Password'),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).popAndPushNamed('/auth');
                } catch (e) {
                  Fluttertoast.showToast(
                      msg: "Error Authenticating",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                width: 200,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    borderRadius: BorderRadius.circular(20)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Logout",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
