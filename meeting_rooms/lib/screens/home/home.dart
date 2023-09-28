import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meeting_rooms/providers/base_api.dart';
import 'package:meeting_rooms/widgets/day_selection.dart';
import 'package:meeting_rooms/widgets/maindrawer.dart';
import 'package:meeting_rooms/screens/home/widgets/meeting_rooms.dart';
import 'package:meeting_rooms/screens/home/widgets/slots.dart';
import 'package:meeting_rooms/widgets/text_feild.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextFieldReturn.textField(
          'Book Meeting Rooms',
          Colors.black,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: DaySelection(),
          ),
          const SizedBox(height: 10),
          const Slots(),
          // const SizedBox(height: 10),
          Expanded(
            child: Container(
              color: Colors.grey.withOpacity(0.3),
              child: const MeetingRooms(),
            ),
          ),
        ],
      ),
    );
  }
}
