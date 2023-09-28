import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meeting_rooms/firebase_options.dart';
import 'package:meeting_rooms/providers/base_api.dart';
import 'package:meeting_rooms/providers/data_store.dart';
import 'package:meeting_rooms/providers/ui.dart';
import 'package:meeting_rooms/screens/myhomepage.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BaseApiProvider()),
        ChangeNotifierProvider(create: (context) => DataStore()),
        ChangeNotifierProvider(create: (context) => UIProvider()),
      ],
      child: ResponsiveSizer(
        builder: (p0, p1, p2) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: "Montserrat",
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
              secondary: Colors.black,
            ),
          ),
          home: const MyHomePage(),
        ),
      ),
    );
  }
}
