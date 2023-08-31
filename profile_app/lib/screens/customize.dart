import "dart:io";

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_storage/firebase_storage.dart";

import "package:http/http.dart" as http;
import "package:path/path.dart" as path;
import "package:path_provider/path_provider.dart" as path_provider;

import 'package:flutter/material.dart';
import 'package:profile_app/widgets/image_input.dart';

class CustomizeScreen extends StatefulWidget {
  CustomizeScreen({super.key, this.isEditing = false, this.profile});
  bool isEditing;
  final profile;

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  final _formKey = GlobalKey<FormState>();

  var _enteredEmail = '';
  var _enteredUsername = '';
  File? _selectedImage;

  var _formChanged = false;
  var _imageChanged = false;

  bool isSubmitting = false;
  bool isPicking = false;

  void _delete() async {
    final firebase = FirebaseFirestore.instance;
    final imageRef =
        FirebaseStorage.instance.ref().child("profiles/$_enteredUsername.jpg");

    try {
      await firebase.collection("profiles").doc(widget.profile.id).delete();

      await imageRef.delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("unable to delete profile")));
    }

    Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid || _selectedImage == null) return;

    _formKey.currentState!.save();

    setState(() {
      isSubmitting = true;
    });

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profiles')
          .child("$_enteredUsername.jpg");

      String imageUrl;

      if (_imageChanged) {
        await storageRef.putFile(_selectedImage!);
        imageUrl = await storageRef.getDownloadURL();
      } else {
        imageUrl = widget.profile['image_url'];
      }

      final firebase = FirebaseFirestore.instance;

      if (widget.isEditing) {
        await firebase.collection('profiles').doc(widget.profile.id).update({
          "username": _enteredUsername,
          "email": _enteredEmail,
          "image_url": imageUrl
        });
      } else {
        var _fetchedEmail = await firebase
            .collection("profiles")
            .where("email=$_enteredEmail")
            .get();

        var _fetchedUsername = await firebase
            .collection("profiles")
            .where("username=$_enteredUsername")
            .get();

        print(_fetchedEmail);
        print(_fetchedUsername);

        if (_fetchedEmail.docs.isNotEmpty || _fetchedUsername.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("User already exists"),
            ),
          );

          setState(() {
            isSubmitting = false;
          });
          return;
        }

        firebase.collection('profiles').doc().set(
          {
            "username": _enteredUsername,
            "email": _enteredEmail,
            "image_url": imageUrl,
          },
        );
      }

      setState(() {
        isSubmitting = false;
        Navigator.of(context).pop();
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
        ),
      );
    }
  }

  void _onImageSaveButtonPressed(String url) async {
    final response = await http.get(Uri.parse(url));
    final imageName = path.basename(url);
    final appDir = await path_provider.getApplicationDocumentsDirectory();
    final localPath = path.join(appDir.path, imageName);
    final imageFile = File(localPath);
    await imageFile.writeAsBytes(response.bodyBytes).then((value) {
      if (mounted) {
        setState(() {
          _selectedImage = imageFile;
          isPicking = false;
        });
      }
    });
  }

  @override
  void initState() {
    if (widget.profile != null) {
      setState(() {
        isPicking = true;
      });
      _onImageSaveButtonPressed(widget.profile['image_url']);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Form(
                    onChanged: () {
                      setState(() {
                        _formChanged = true;
                      });
                    },
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isPicking
                            ? const CircularProgressIndicator()
                            : ImageInput(
                                onPickImage: (image) {
                                  setState(() {
                                    _selectedImage = image;
                                    _imageChanged = true;
                                  });
                                },
                                pickedImage: _selectedImage,
                              ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          initialValue:
                              widget.isEditing ? widget.profile['email'] : "",
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
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
                        TextFormField(
                          keyboardType: TextInputType.text,
                          initialValue: widget.isEditing
                              ? widget.profile['username']
                              : "",
                          decoration:
                              const InputDecoration(labelText: "Username"),
                          enableSuggestions: false,
                          validator: (value) {
                            RegExp regex = RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                            if (value == null || value.isEmpty) {
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
                            _enteredUsername = value!;
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Row(
                            children: [
                              const Spacer(),
                              if (widget.isEditing)
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text("Warning"),
                                          content: const Text(
                                              "This actions is irreversible"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop();
                                                },
                                                child: const Text('Cancel')),
                                            TextButton(
                                              onPressed: _delete,
                                              child: const Text("Delete"),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.delete)),
                              GestureDetector(
                                onTap: !isSubmitting
                                    ? _formChanged || _imageChanged
                                        ? _submit
                                        : null
                                    : null,
                                child: isSubmitting
                                    ? const CircularProgressIndicator()
                                    : Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.blue),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: const Text(
                                          "Submit",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
