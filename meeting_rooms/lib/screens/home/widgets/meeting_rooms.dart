import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meeting_rooms/providers/base_api.dart';
import 'package:meeting_rooms/providers/data_store.dart';
import 'package:meeting_rooms/screens/home/widgets/meeting_room.dart';
import 'package:meeting_rooms/screens/home/widgets/slider.dart';
import 'package:meeting_rooms/widgets/text_feild.dart';
import 'package:provider/provider.dart';

class MeetingRooms extends StatefulWidget {
  const MeetingRooms({super.key});

  @override
  State<MeetingRooms> createState() => _MeetingRoomsState();
}

class _MeetingRoomsState extends State<MeetingRooms> {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<DataStore>(context).isDataPresent) {
      return FutureBuilder(
        future: Provider.of<BaseApiProvider>(context).meetingsRooms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null || snapshot.data!.responseBody == 'error') {
            return Center(
              child: TextFieldReturn.textField(
                  'Something Went Wrong', Colors.black),
            );
          }

          final Map res =
              jsonDecode(snapshot.data!.responseBody)['meetingRooms'];
          List keys = res.keys.toList();

          if (keys.isEmpty) {
            return Center(
              child: TextFieldReturn.textField(
                  'No meeting Rooms found for Selected Building', Colors.black),
            );
          }

          Map<String, dynamic> data = Provider.of<DataStore>(context).data;
          String date = data['Date'];
          String slots =
              '${data['Duration']['start']}:${data['Duration']['stop']}';

          return FutureBuilder(
            future: Provider.of<BaseApiProvider>(context)
                .meetings(data['Date'], slots),
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

              List meetingIds =
                  jsonDecode(snapshot.data!.responseBody)['mids'].toList();

              if (meetingIds.isEmpty) {
                return Center(
                  child: TextFieldReturn.textField(
                      'No Meeting Rooms Available', Colors.black),
                );
              }

              return ListView.builder(
                itemCount: meetingIds.length,
                itemBuilder: (context, index) {
                  if (keys
                      .where((element) => element == meetingIds[index])
                      .isNotEmpty) {
                    return MeetingRoom(
                      meetingIds: meetingIds,
                      index: index,
                      slots: slots,
                      res: res,
                      date: date,
                    );
                  }
                  return null;
                },
              );
            },
          );
        },
      );
    }
    return Center(
      child: SizedBox(
        child: TextFieldReturn.textField('Choose the Slots', Colors.black),
      ),
    );
  }
}
