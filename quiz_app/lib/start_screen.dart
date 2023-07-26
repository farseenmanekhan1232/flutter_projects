import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";

class StartScreen extends StatelessWidget {
  const StartScreen(this.startQuiz, {super.key});

  final void Function(String screenName) startQuiz;

  @override
  Widget build(context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/quiz-logo.png',
            width: 300,
            color: const Color.fromARGB(100, 255, 255, 255),
          ),
          const SizedBox(
            height: 80,
          ),
          Text(
            'Learn Flutter the Fun Way!',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          OutlinedButton.icon(
            onPressed: () => startQuiz('Quiz'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 238, 227, 255),
            ),
            icon: const Icon(
              Icons.arrow_right_alt,
            ),
            label: const Text("Start Quiz"),
          )
        ],
      ),
    );
  }
}
