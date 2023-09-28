import 'package:flutter/material.dart';
import 'package:meeting_rooms/models/mydateformat.dart';
import 'package:meeting_rooms/providers/data_store.dart';
import 'package:meeting_rooms/providers/ui.dart';
import 'package:meeting_rooms/widgets/text_feild.dart';
import 'package:provider/provider.dart';

class DaySelection extends StatefulWidget {
  const DaySelection({super.key});

  @override
  State<DaySelection> createState() => _DaySelectionState();
}

class _DaySelectionState extends State<DaySelection> {
  bool isToday = true;
  bool isTomorrow = false;
  bool isOtherday = false;
  late String dateShow;

  @override
  void initState() {
    super.initState();
    dateShow = dayMonthShower(DateTime.now().month, DateTime.now().day + 2);
  }

  String dayMonthShower(int month, int day) {
    switch (month) {
      case 1:
        return '$day Jan';
      case 2:
        return '$day Feb';
      case 3:
        return '$day Mar';
      case 4:
        return '$day Apr';
      case 5:
        return '$day May';
      case 6:
        return '$day Jun';
      case 7:
        return '$day Jul';
      case 8:
        return '$day Aug';
      case 9:
        return '$day Sep';
      case 10:
        return '$day Oct';
      case 11:
        return '$day Nov';
      case 12:
        return '$day Dec';
      default:
        return '';
    }
  }

  void storeData(DateTime time) {
    Provider.of<DataStore>(context, listen: false).clearData();
    Provider.of<DataStore>(context, listen: false)
        .addData('Date', MyDateFormat.dateFrmt(time));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Provider.of<UIProvider>(context, listen: false).clearSlotBorder();

              setState(() {
                isToday = true;
                isTomorrow = false;
                isOtherday = false;
              });
              storeData(DateTime.now());
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isToday
                    ? const Color.fromARGB(255, 55, 55, 55)
                    : Color.fromARGB(255, 236, 236, 236),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: TextFieldReturn.textFieldMeduim(
                'Today',
                isToday ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              Provider.of<UIProvider>(context, listen: false).clearSlotBorder();

              setState(() {
                isToday = false;
                isTomorrow = true;
                isOtherday = false;
              });
              storeData(DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day + 1));
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isTomorrow
                    ? const Color.fromARGB(255, 55, 55, 55)
                    : Color.fromARGB(255, 236, 236, 236),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: TextFieldReturn.textFieldMeduim(
                'Tomorrow',
                isTomorrow ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day + 2,
                ),
                firstDate: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day + 2,
                ),
                lastDate: DateTime(DateTime.now().year + 2),
              );
              if (picked != null) {
                Provider.of<UIProvider>(context, listen: false)
                    .clearSlotBorder();

                setState(() {
                  dateShow = dayMonthShower(picked.month, picked.day);
                  isToday = false;
                  isTomorrow = false;
                  isOtherday = true;
                });
                storeData(picked);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isOtherday
                    ? const Color.fromARGB(255, 55, 55, 55)
                    : Color.fromARGB(255, 236, 236, 236),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Row(
                children: [
                  TextFieldReturn.textFieldMeduim(
                    dateShow,
                    isOtherday ? Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.date_range_outlined,
                    size: 15,
                    color: isOtherday ? Colors.white : Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
