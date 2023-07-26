import "package:flutter/material.dart";

import "package:quiz_app/start_screen.dart";
import "package:quiz_app/questions_screen.dart";
import "package:quiz_app/data/questions.dart";
import "package:quiz_app/result_screen.dart";

class Quiz extends StatefulWidget {
  const Quiz({super.key});
  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  Widget? activeScreen;

  final List<String> selectedAnswers = [];

  void chooseAnswer(String answer) {
    selectedAnswers.add(answer);
    if (selectedAnswers.length == questions.length) {
      setState(() {
        activeScreen = ResultsScreen(switchScreen, selectedAnswers);
      });
    }
  }

  @override
  void initState() {
    activeScreen = StartScreen(switchScreen);
    super.initState();
  }

  void switchScreen(String screenName) {
    setState(() {
      if (screenName == "Start") {
        selectedAnswers.clear();
        activeScreen = StartScreen(
          switchScreen,
        );
      } else if (screenName == 'Quiz') {
        activeScreen = QuestionsScreen(
          onSelectAnswer: chooseAnswer,
        );
      }
    });
  }

  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple,
                Color.fromARGB(255, 118, 72, 197),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: activeScreen,
        ),
      ),
    );
  }
}
