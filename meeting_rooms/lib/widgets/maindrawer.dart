import 'package:flutter/material.dart';
import 'package:meeting_rooms/screens/meeting_details/meetings_details.dart';
import 'package:meeting_rooms/widgets/text_feild.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            ListTile(
              title: Row(
                children: [
                  const Icon(Icons.meeting_room_outlined),
                  TextFieldReturn.textField(
                    'Meetings',
                    Colors.black,
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MeetingsDetails(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
