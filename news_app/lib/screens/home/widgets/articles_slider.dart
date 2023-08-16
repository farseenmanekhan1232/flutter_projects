import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/widgets/article_small.dart';
import 'package:news_app/widgets/headlines.dart';

class ArticlesSlider extends StatelessWidget {
  ArticlesSlider(
      {super.key, required this.articles, required this.topic, this.height});

  final List<Article> articles;
  final String topic;
  double? height;

  @override
  Widget build(BuildContext context) {
    if (articles.isNotEmpty) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: Text(
                  topic,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) =>
                          HeadlinesScreen(articles: articles, topic: topic)));
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 20, 20, 0),
                  child: const Text("More"),
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.all(5),
            height: height != null ? height! + 120 : 235,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: articles.length > 5 ? 5 : articles.length,
              itemBuilder: (context, index) => ArticleSmall(
                  article: articles[index], heading: topic, height: height),
            ),
          )
        ],
      );
    } else {
      return const SizedBox(width: 0);
    }
  }
}
