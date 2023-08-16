import 'package:flutter/material.dart';
import 'package:profile_app/screens/customize.dart';
import 'package:profile_app/screens/profile_list.dart';

class Profiles extends StatefulWidget {
  const Profiles({super.key});

  @override
  State<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profiles",
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 30),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => CustomizeScreen(),
              );
            },
            icon: const Icon(Icons.add),
            color: Colors.black,
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: const ProfileListScreen(),
    );
  }
}
