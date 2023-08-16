import 'package:flutter/material.dart';
import 'package:news_app/screens/auth/auth.dart';
import 'package:news_app/screens/welcome/welcome.dart';
import 'package:provider/provider.dart';

import "firebase_options.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:news_app/news.dart';
import 'package:news_app/screens/splash_screen.dart';

import 'package:news_app/providers/news_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => NewsProvider(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Poppins'),
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SplashScreen(loading: true);
                } else if (snapshot.hasData) {
                  return News();
                } else {
                  return WelcomeScreen();
                }
              }),
          initialRoute: '/',
          routes: {
            "/auth": (context) => WelcomeScreen(again: true),
            "/home": (context) => News(),
            "/favourites": (context) => News(
                  index: 1,
                ),
            "/profile": (context) => News(
                  index: 2,
                ),
          },
        ));
  }
}
