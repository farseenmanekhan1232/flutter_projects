import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";

import "package:quiz_app/data/questions.dart";
import "package:quiz_app/questions_summary.dart";

class ResultsScreen extends StatelessWidget {
  const ResultsScreen(this.onRestart, this.chosenAnswers, {super.key});

  final void Function(String screenName) onRestart;

  final List<String> chosenAnswers;

  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary = [];

    for (int i = 0; i < chosenAnswers.length; i++) {
      summary.add({
        'question_index': i,
        'question': questions[i].text,
        'answer': questions[i].answers[0],
        'user_answer': chosenAnswers[i]
      });
    }
    return summary;
  }

  @override
  Widget build(context) {
    final summaryData = getSummaryData();
    final numberOfQuestions = questions.length;
    final correctAnswers = summaryData.where((data) {
      return data['user_answer'] == data['answer'];
    }).length;

    return SizedBox(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You answered $correctAnswers out of $numberOfQuestions questions correctly',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            QuestionsSummary(getSummaryData()),
            const SizedBox(
              height: 30,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 238, 227, 255),
              ),
              onPressed: () => onRestart('Start'),
              child: const Text('Restart Quiz'),
            )
          ],
        ),
      ),
    );
  }
}
