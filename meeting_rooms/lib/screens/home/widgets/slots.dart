import 'package:flutter/material.dart';
import 'package:meeting_rooms/screens/home/widgets/slot_time.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Slots extends StatefulWidget {
  const Slots({super.key});

  @override
  State<Slots> createState() => _SlotsState();
}

class _SlotsState extends State<Slots> {
  @override
  Widget build(BuildContext context) {
    int opening = 9;
    int closing = 19;
    int hoursLeft = closing - opening;
    List<String> hours = List.generate(
      hoursLeft * 2,
      (index) {
        var time =
            '${(opening + (index / 2).floor())}:${index % 2 == 0 ? '00' : '30'}';
        return time;
      },
    ).toList();

    return Container(
      width: 100.w,
      height: 25.h,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: const Color.fromARGB(255, 78, 78, 78).withOpacity(0.3),
        ),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 80.w / 20.h,
        ),
        itemCount: hours.length,
        itemBuilder: (context, index) {
          return SlotTime(index: index, hours: hours);
        },
      ),
    );
  }
}
