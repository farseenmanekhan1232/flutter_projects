import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meeting_rooms/providers/base_api.dart';
import 'package:meeting_rooms/widgets/text_feild.dart';
import 'package:provider/provider.dart';

class UserMeetings extends StatefulWidget {
  const UserMeetings(
      {super.key,
      required this.type,
      required this.response,
      required this.refresh});

  final String type;
  final Map response;
  final Function refresh;
  @override
  State<UserMeetings> createState() => _UserMeetingsState();
}

class _UserMeetingsState extends State<UserMeetings> {
  String getTime(List slots) {
    int opening = 9;
    int closing = 19;
    int hoursLeft = closing - opening;
    List<String> hours = List.generate(
      hoursLeft * 2 + 1,
      (index) {
        var time =
            '${opening + (index / 2).floor() > 12 ? (opening + (index / 2).floor() - 12) : (opening + (index / 2).floor())}:${index % 2 == 0 ? '00' : '30'} ${opening + (index / 2).floor() > 12 ? "PM" : "AM"}';
        return time;
      },
    ).toList();
    return '${hours[slots[0]]} - ${hours[slots[1]]}';
  }

  @override
  Widget build(BuildContext context) {
    int bookedMeetingCount = 0;
    for (final dates in widget.response.entries) {
      if (dates.value['meetings'].isNotEmpty) {
        bookedMeetingCount = bookedMeetingCount + 1;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (bookedMeetingCount > 0)
          for (final dates in widget.response.entries)
            if (dates.value['meetings'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${dates.key.toString().substring(0, 4)}-${dates.key.toString().substring(4, 6)}-${dates.key.toString().substring(6, 8)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 247, 247, 247),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final MapEntry meeting
                            in dates.value['meetings'].entries)
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) {
                                  return Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Text(
                                            meeting.value['title'],
                                            style:
                                                const TextStyle(fontSize: 25),
                                          ),
                                          Text(getTime(meeting.value['slots'])),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () async {
                                              await Provider.of<
                                                          BaseApiProvider>(
                                                      context,
                                                      listen: false)
                                                  .cancelMeet(
                                                      meeting.key.toString(),
                                                      dates.key.toString());

                                              Navigator.of(context).pop();
                                              widget.refresh();
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(10),
                                              decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 255, 113, 103),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  "Cancel Meeting",
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ));
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              child: Row(
                                children: [
                                  Text(
                                    meeting.value['title'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Text(getTime(meeting.value['slots']))
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  )
                ],
              ),
        if (bookedMeetingCount == 0)
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("No Meetings Available"),
            ],
          )
      ],
    );
  }
}
