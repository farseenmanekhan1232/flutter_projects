import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meeting_rooms/providers/base_api.dart';
import 'package:meeting_rooms/widgets/text_feild.dart';
import 'package:meeting_rooms/screens/meeting_details/widgets/user_meetings.dart';
import 'package:provider/provider.dart';

class MeetingsDetails extends StatefulWidget {
  const MeetingsDetails({super.key});

  @override
  State<MeetingsDetails> createState() => _MeetingsDetailsState();
}

class _MeetingsDetailsState extends State<MeetingsDetails> {
  String currentTab = "upcoming";

  void changeWidget(String identifier) {
    setState(() {
      currentTab = identifier;
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFieldReturn.textField(
          'Meeting Details',
          Colors.black,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  changeWidget('upcoming');
                },
                child: TextFieldReturn.textFieldMeduim('Upcoming',
                    currentTab == 'upcoming' ? Colors.red : Colors.black),
              ),
              TextButton(
                onPressed: () {
                  changeWidget('completed');
                },
                child: TextFieldReturn.textFieldMeduim('Completed',
                    currentTab == 'completed' ? Colors.red : Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FutureBuilder(
                future: Provider.of<BaseApiProvider>(context).userMeets(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.data == null ||
                      snapshot.data!.responseBody == 'error') {
                    return Center(
                      child: TextFieldReturn.textField(
                          'Something Went Wrong', Colors.black),
                    );
                  }

                  if (snapshot.data!.responseBody == '') {
                    return Center(
                      child: TextFieldReturn.textField(
                          'Book the Meetings', Colors.black),
                    );
                  }

                  Map response = jsonDecode(snapshot.data!.responseBody);
                  return UserMeetings(
                      type: currentTab, response: response, refresh: refresh);
                },
              )),
        ],
      ),
    );
  }
}
