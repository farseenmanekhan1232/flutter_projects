import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:news_app/news.dart";
import "package:news_app/screens/home/home.dart";

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  AuthScreen({super.key, this.login});

  bool? login;

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLogin = false;
  bool hide = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  bool _isAuthenticating = false;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) return;

    _formKey.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      }
      Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: e.message ?? "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);

      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void viewPassword() {
    setState(() {
      hide = !hide;
    });
  }

  @override
  void initState() {
    if (widget.login != null) {
      setState(() {
        _isLogin = widget.login!;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "assets/images/logo.png",
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 120,
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      width: 200,
                      child: Image.asset(
                        'assets/images/logo.png',
                        color: const Color.fromARGB(176, 0, 0, 0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            enableSuggestions: true,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelText: 'Email Address',
                              floatingLabelStyle:
                                  TextStyle(color: Colors.black),
                            ),
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              String pattern =
                                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                  r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                  r"{0,253}[a-zA-Z0-9])?)*$";
                              RegExp regex = RegExp(pattern);
                              if (value == null || !regex.hasMatch(value)) {
                                return 'Enter a valid email address';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            enableSuggestions: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              floatingLabelStyle:
                                  const TextStyle(color: Colors.black),
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: viewPassword,
                                icon: !hide
                                    ? const Icon(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        Icons.remove_red_eye,
                                      )
                                    : const Icon(
                                        color:
                                            Color.fromARGB(255, 121, 121, 121),
                                        Icons.remove_red_eye_outlined,
                                      ),
                              ),
                            ),
                            obscureText: hide,
                            validator: (value) {
                              RegExp regex = RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                              if (value!.isEmpty) {
                                return 'Please enter password';
                              } else {
                                if (!regex.hasMatch(value)) {
                                  return 'Enter valid password';
                                } else {
                                  return null;
                                }
                              }
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          if (_isAuthenticating)
                            Container(
                                margin: const EdgeInsets.all(10),
                                child: const CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.black),
                                )),
                          // const Spacer(),
                          if (!_isAuthenticating)
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        _isLogin = !_isLogin;
                                      });
                                    },
                                    child: Text(
                                      _isLogin
                                          ? "Create an Account"
                                          : "I already have an Account",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 41, 41, 41),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (!_isAuthenticating)
                    InkWell(
                      onTap: _submit,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(176, 0, 0, 0),
                          border: Border.all(
                            width: 1,
                            color: Color.fromARGB(99, 248, 248, 248),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isLogin ? "Login" : "Register here",
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
