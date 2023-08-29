import 'package:appazon/appazon.dart';
import 'package:appazon/firebase_options.dart';
import 'package:appazon/providers/products.dart';
import 'package:appazon/providers/user.dart';
import 'package:appazon/screens/auth/welcome.dart';
import 'package:appazon/screens/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthenticatedUser(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Poppins'),
        home: const AppazonApp(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/welcome': (context) => const WelcomeScreen(),
        },
      ),
    );
  }
}
