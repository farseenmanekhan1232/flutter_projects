import 'package:flutter/material.dart';
import 'package:meeting_rooms/models/response.dart';
import 'package:meeting_rooms/providers/base_api.dart';
import 'package:meeting_rooms/providers/ui.dart';
import 'package:meeting_rooms/widgets/text_feild.dart';
import 'package:provider/provider.dart';
import 'package:slider_button/slider_button.dart';

class SliderBtnModal extends StatefulWidget {
  const SliderBtnModal(
      {super.key,
      required this.mid,
      required this.slot,
      required this.date,
      required this.refreshFunction});

  final String mid;
  final String slot;
  final String date;
  final Function() refreshFunction;

  @override
  State<SliderBtnModal> createState() => _SliderBtnModalState();
}

class _SliderBtnModalState extends State<SliderBtnModal> {
  final _controller = TextEditingController();
  bool isShowBtn = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      validate(_controller.text);
    });
  }

  void validate(String title) {
    if (title.trim().isNotEmpty) {
      setState(() {
        isShowBtn = true;
      });
    } else {
      setState(() {
        isShowBtn = false;
      });
    }
  }

  String dateSplitter(String date) {
    return '${date.substring(0, 4)}/${date.substring(4, 6)}/${date.substring(6, 8)}';
  }

  String timeSplitter(String slot) {
    List<String> splitsList = slot.split(':');
    int opening = 9;
    int closing = 19;
    int hoursLeft = closing - opening;
    List<String> hours = List.generate(
      hoursLeft * 2 + 1,
      (index) {
        var time =
            '${opening + (index / 2).floor()}:${index % 2 == 0 ? '00' : '30'}';
        return time;
      },
    ).toList();
    return '${hours[int.parse(splitsList[0])]}-${hours[int.parse(splitsList[1])]}';
  }

  void snackBar(String message) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: TextFieldReturn.textField(message, Colors.black),
      backgroundColor: Colors.white,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldReturn.textField(
              'Meeting Room : ${widget.mid}', Colors.black),
          TextFieldReturn.textField(
              'Timing : ${timeSplitter(widget.slot)}', Colors.black),
          TextFieldReturn.textField(
              'Date : ${dateSplitter(widget.date)}', Colors.black),
          const SizedBox(height: 20),
          TextFormField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Enter Meeting Title'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter the title';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 30),
          if (isShowBtn)
            Center(
              child: SliderButton(
                action: () async {
                  setState(() {
                    isLoading = true;
                  });
                  ApiResponse apiResponse =
                      await Provider.of<BaseApiProvider>(context, listen: false)
                          .scheduleMeet(widget.mid, _controller.text,
                              widget.slot, widget.date);
                  setState(() {
                    isLoading = false;
                  });
                  widget.refreshFunction();
                  if (apiResponse.code == 200) {
                    snackBar('Meeting Room Booked Successfully');
                  } else {
                    snackBar('Something Went Wrong while Booking Meeting Room');
                  }
                },
                label: TextFieldReturn.textField(
                  "Book the Meeting",
                  Colors.black,
                ),
                icon: TextFieldReturn.textField(
                  'Slide',
                  Colors.black,
                ),
              ),
            ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
