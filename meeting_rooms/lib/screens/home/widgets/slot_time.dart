import 'package:flutter/material.dart';
import 'package:meeting_rooms/providers/data_store.dart';
import 'package:meeting_rooms/providers/ui.dart';
import 'package:meeting_rooms/widgets/text_feild.dart';
import 'package:provider/provider.dart';

class SlotTime extends StatefulWidget {
  const SlotTime({super.key, required this.index, required this.hours});

  final int index;
  final List<String> hours;

  @override
  State<SlotTime> createState() => _SlotTimeState();
}

class _SlotTimeState extends State<SlotTime> {
  final _key = UniqueKey();

  bool isActive = false;
  final TextEditingController _controller = TextEditingController();

  bool isValid(String time, String date) {
    List splitTime = time.split(':');
    String timeFormatted =
        '${int.parse(splitTime[0]) < 10 ? '0${splitTime[0]}' : splitTime[0]}${splitTime[1]}';
    String datetimeToconvert = '${date}T$timeFormatted';
    DateTime convertedDateTime = DateTime.parse(datetimeToconvert);
    if (convertedDateTime.difference(DateTime.now()).inMinutes < 15) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool option = isValid(
        widget.hours[widget.index],
        Provider.of<DataStore>(
          context,
        ).data['Date']);

    return InkWell(
      onTap: option
          ? null
          : () {
              Provider.of<UIProvider>(context, listen: false)
                  .setSlotBorder(_key.toString());

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Duration'),
                    content: TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        RegExp pattern = RegExp(r'^(\d+(\.5)?)$');

                        if (value != null && !pattern.hasMatch(value)) {
                          return 'Input Should be 0.5, 1, 1.5, 2.....';
                        }
                        if (value == '0') {
                          return 'Enter non-zero value';
                        }
                        if (((double.parse(value!) ~/ 0.5).toInt() +
                                widget.index) >
                            widget.hours.length) {
                          return 'Duration out of range';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _controller.clear();
                          Navigator.of(context).pop();
                        },
                        child: TextFieldReturn.textFieldMeduim(
                          'CANCEL',
                          Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          String text = _controller.text;
                          RegExp pattern = RegExp(r'^(\d+(\.5)?)$');
                          if (pattern.hasMatch(text)) {
                            int val = (double.parse(text) ~/ 0.5).toInt();
                            if (((double.parse(text) ~/ 0.5).toInt() +
                                    widget.index) <=
                                widget.hours.length) {
                              Provider.of<DataStore>(context, listen: false)
                                  .addData('Duration', {
                                'start': widget.index,
                                'stop': widget.index + val,
                              });
                              Navigator.of(context).pop();
                            }
                          }
                          _controller.clear();
                        },
                        child: TextFieldReturn.textFieldMeduim(
                          'OK',
                          Colors.black,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: !option
              ? const Color.fromARGB(255, 236, 236, 236)
              : const Color.fromARGB(255, 207, 207, 207),
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          border:
              Provider.of<UIProvider>(context).currentSlot == _key.toString()
                  ? Border.all(width: 1)
                  : null,
        ),
        child: Text(widget.hours[widget.index]),
      ),
    );
  }
}
