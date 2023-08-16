import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/article/full_article.dart';
import 'package:news_app/screens/home/widgets/articles_slider.dart';
import 'package:news_app/screens/splash_screen.dart';
import 'package:news_app/widgets/image_container.dart';
import 'package:provider/provider.dart';

class TopHeadlines extends StatefulWidget {
  const TopHeadlines({super.key});

  @override
  State<TopHeadlines> createState() => _TopHeadlinesState();
}

class _TopHeadlinesState extends State<TopHeadlines> {
  late Future<List<Article>> _getArticles;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getArticles = Provider.of<NewsProvider>(context).getArticles(
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=41e50386d7d947c7876d3dd70b62f803",
        "Top Headlines");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty) {
            final articles = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => FullArticleScreen(
                            article: articles[0], heading: "Top Headlines"),
                      ),
                    );
                  },
                  child: ImageContainer(
                    url: articles![0].imageUrl,
                    padding: 0,
                    margin: 0,
                    height: 300,
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 5, left: 15, right: 15, bottom: 5),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(132, 158, 158, 158),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "News of the Day",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer()
                            ],
                          ),
                          Text(
                            articles[0].title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ArticlesSlider(
                    articles: articles, topic: "Top Headlines", height: 200),
              ],
            );
          } else {
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
          }
        });
  }
}
