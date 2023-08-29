import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';

class AuthenticatedUser extends ChangeNotifier {
  UserCredential? _user;

  bool loading = false;

  void loadUser(UserCredential user) {
    _user = user;
    notifyListeners();
  }

  Future<UserCredential?> googleAuth() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    _user = await FirebaseAuth.instance.signInWithCredential(credential);

    notifyListeners();

    return _user;
  }

  Future<UserCredential?> twitterAuth() async {
    TwitterAuthProvider twitterProvider = TwitterAuthProvider();
    try {
      if (kIsWeb) {
        _user = await FirebaseAuth.instance.signInWithPopup(twitterProvider);
      } else {
        _user = await FirebaseAuth.instance.signInWithProvider(twitterProvider);
      }
    } catch (e) {
      print(e);
    }

    return _user;
  }

  void isLoading(bool state) {
    loading = state;
  }

  void signOut() async {
    _user = null;
    notifyListeners();
  }
}
