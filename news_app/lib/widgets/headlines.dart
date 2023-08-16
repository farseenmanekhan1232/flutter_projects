import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/widgets/article_large.dart';

class HeadlinesScreen extends StatelessWidget {
  const HeadlinesScreen(
      {super.key, required this.articles, required this.topic});

  final List<Article> articles;
  final String topic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          topic,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 25,
          ),
        ),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return ArticleLarge(article: articles[index], heading: topic);
        },
      ),
    );
  }
}
