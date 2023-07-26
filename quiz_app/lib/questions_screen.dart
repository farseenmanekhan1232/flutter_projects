import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "package:quiz_app/answer_button.dart";
import "package:quiz_app/data/questions.dart";

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key, required this.onSelectAnswer});

  final void Function(String answer) onSelectAnswer;

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  var index = 0;
  void answerQuestion(String answer) {
    widget.onSelectAnswer(answer);
    setState(() {
      if (index < questions.length - 1) {
        index++;
      }
    });
  }

  @override
  Widget build(context) {
    final currentQuestion = questions[index];
    return Container(
      margin: const EdgeInsets.all(40),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.text,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ...currentQuestion.getShuffledAnswers().map(
                  (answer) => AnswerButton(
                    text: answer,
                    onTap: () => answerQuestion(answer),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
