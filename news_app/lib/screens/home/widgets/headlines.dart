import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/home/widgets/articles_slider.dart';
import 'package:provider/provider.dart';

class Headlines extends StatefulWidget {
  const Headlines({super.key, required this.topic});
  final String topic;
  @override
  State<Headlines> createState() => _HeadlinesState();
}

class _HeadlinesState extends State<Headlines> {
  late Future<List<Article>> _getArticles;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getArticles = Provider.of<NewsProvider>(context).getArticles(
        "https://newsapi.org/v2/everything?q=${widget.topic}&apiKey=41e50386d7d947c7876d3dd70b62f803",
        widget.topic);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            final articles = snapshot.data!;
            return ArticlesSlider(articles: articles, topic: widget.topic);
          } else if (snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Check your Internet Connection",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            );
          } else {
            return const Text("");
          }
        });
  }
}
