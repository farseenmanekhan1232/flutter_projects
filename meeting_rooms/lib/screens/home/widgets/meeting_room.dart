import 'package:flutter/material.dart';
import 'package:meeting_rooms/screens/home/widgets/slider.dart';
import 'package:meeting_rooms/widgets/text_feild.dart';

class MeetingRoom extends StatefulWidget {
  const MeetingRoom({
    super.key,
    required this.meetingIds,
    required this.index,
    required this.slots,
    required this.res,
    required this.date,
  });

  final int index;
  final List meetingIds;
  final String slots;
  final Map res;
  final String date;

  @override
  State<MeetingRoom> createState() => _MeetingRoomState();
}

class _MeetingRoomState extends State<MeetingRoom> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return SliderBtnModal(
              mid: widget.meetingIds[widget.index],
              slot: widget.slots,
              date: widget.date,
              refreshFunction: () {
                setState(() {});
              },
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldReturn.textField(
              'Meeting Room ${widget.meetingIds[widget.index]}',
              Colors.black,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromARGB(255, 247, 247, 247),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.people_outline),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.res['${widget.meetingIds[widget.index]}']
                                ['amenities']['capacity']
                            .toString(),
                      ),
                    ],
                  ),
                ),
                if (widget.res['${widget.meetingIds[widget.index]}']
                        ['amenities']['ac'] ||
                    widget.res['${widget.meetingIds[widget.index]}']
                        ['amenities']['tv'])
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      if (widget.res['${widget.meetingIds[widget.index]}']
                          ['amenities']['ac'])
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color.fromARGB(255, 247, 247, 247),
                          ),
                          child: const Icon(Icons.ac_unit, size: 18),
                        ),
                      if (widget.res['${widget.meetingIds[widget.index]}']
                          ['amenities']['tv'])
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color.fromARGB(255, 247, 247, 247),
                          ),
                          child: const Icon(Icons.tv, size: 18),
                        ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
