import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/home/widgets/articles_slider.dart';
import 'package:news_app/screens/home/widgets/headlines.dart';
import 'package:news_app/widgets/headlines.dart';
import 'package:news_app/widgets/image_container.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FullArticleScreen extends StatefulWidget {
  const FullArticleScreen(
      {super.key, required this.article, required this.heading});

  final Article article;
  final String heading;

  @override
  State<FullArticleScreen> createState() => _FullArticleScreenState();
}

class _FullArticleScreenState extends State<FullArticleScreen> {
  @override
  Widget build(BuildContext context) {
    List<Article>? articles =
        Provider.of<NewsProvider>(context).articles[widget.heading];

    if (articles != null) articles.shuffle();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
              icon: const Icon(Icons.home_rounded)),
          IconButton(
            onPressed: () {
              if (!Provider.of<NewsProvider>(context, listen: false)
                  .favourites
                  .containsKey(widget.article.url)) {
                Provider.of<NewsProvider>(context, listen: false)
                    .setFavourite(widget.article);
              } else {
                Provider.of<NewsProvider>(context, listen: false)
                    .removeFavourite(widget.article.url);
              }
            },
            icon: !Provider.of<NewsProvider>(context)
                    .favourites
                    .containsKey(widget.article.url)
                ? const Icon(Icons.bookmark_add)
                : const Icon(
                    Icons.bookmark_added,
                  ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageContainer(
              url: widget.article.imageUrl,
              margin: 0,
              padding: 0,
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      textAlign: TextAlign.start,
                      widget.article.title,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        if (widget.article.name != null)
                          InkWell(
                            onTap: () {
                              List<Article> filteredArticles = [];
                              for (var articles in Provider.of<NewsProvider>(
                                      context,
                                      listen: false)
                                  .articles
                                  .entries) {
                                for (Article article_ in articles.value) {
                                  if (article_.name == widget.article.name) {
                                    filteredArticles.add(article_);
                                  }
                                }
                              }

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => HeadlinesScreen(
                                      articles: filteredArticles,
                                      topic: widget.article.name!),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 15, right: 15, bottom: 5),
                              margin: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(132, 158, 158, 158),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.article.name!,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const Spacer()
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 5, left: 15, right: 15, bottom: 5),
                  margin: const EdgeInsets.only(top: 10, left: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(55, 158, 158, 158),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.date_range,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${DateTime.parse(widget.article.publishedAt).day.toString()}.${DateTime.parse(widget.article.publishedAt).month.toString()}.${DateTime.parse(widget.article.publishedAt).year.toString()}",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Text(
                widget.article.description,
                softWrap: true,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  height: 1.5,
                  fontSize: 18,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await launchUrl(Uri.parse(widget.article.url));
              },
              child: const Text(
                'Read More',
                style: TextStyle(
                  color: Color.fromARGB(174, 0, 0, 0),
                  fontSize: 20,
                ),
              ),
            ),
            ArticlesSlider(articles: articles ?? [], topic: widget.heading)
          ],
        ),
      ),
    );
  }
}
