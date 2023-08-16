import 'package:flutter/material.dart';
import 'package:news_app/screens/home/widgets/headlines.dart';
import 'package:news_app/screens/home/widgets/top_headlines.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Stack(children: [
        Column(
          children: [
            TopHeadlines(),
            Headlines(topic: "Indian Finance"),
            Headlines(topic: "Technology"),
            Headlines(topic: "Crypto News"),
          ],
        ),
      ]),
    );
  }
}
