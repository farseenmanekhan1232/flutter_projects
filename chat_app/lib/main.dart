import "package:chat_app/screens/auth.dart";
import "package:chat_app/screens/chat.dart";
import "package:chat_app/screens/splash.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";

import "package:firebase_core/firebase_core.dart";
import "firebase_options.dart";

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.title}');
  print('Message notification: ${message.notification?.body}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Chat',
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 6, 4, 14),
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            if (snapshot.hasData) {
              return const ChatScreen();
            } else {
              return const AuthScreen();
            }
          },
        ));
  }
}
