import 'dart:math';

import "package:soundpool/soundpool.dart";

import "package:flutter/material.dart";
import 'package:flutter/services.dart';

final random = Random();

class DiceRoller extends StatefulWidget {
  const DiceRoller({super.key});

  @override
  State<DiceRoller> createState() {
    return _DiceRollerState();
  }
}

Soundpool pool = Soundpool(streamType: StreamType.music);

class _DiceRollerState extends State<DiceRoller> {
  String activeDiceImage = "assets/images/dice-1.png";
  void rollDice() async {
    int soundId = await rootBundle
        .load('assets/audio/diceroll.mp3')
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    await pool.play(soundId);
    setState(() {
      var image = 1 + random.nextInt(6);
      activeDiceImage = "assets/images/dice-$image.png";
    });
    // print('changing');
  }

  @override
  Widget build(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          activeDiceImage,
          width: 200,
        ),
        TextButton(
          onPressed: rollDice,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(20),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(color: Colors.black),
          ),
          child: const Text(
            "Roll dice",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
