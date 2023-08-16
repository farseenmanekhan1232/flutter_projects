import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/article/full_article.dart';
import 'package:news_app/widgets/headlines.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ArticleSmall extends StatelessWidget {
  ArticleSmall(
      {super.key, required this.article, required this.heading, this.height});
  final Article article;
  final String heading;
  double? height;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageTransition(
            type: PageTransitionType.bottomToTop,
            child: FullArticleScreen(
              article: article,
              heading: heading,
            ),
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(73, 216, 216, 216),
        ),
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        width: 250,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: article.imageUrl,
                    height: height ?? 120,
                    width: 370,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  textAlign: TextAlign.start,
                  article.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.date_range,
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${DateTime.parse(article.publishedAt).day.toString()}.${DateTime.parse(article.publishedAt).month.toString()}.${DateTime.parse(article.publishedAt).year.toString()}",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 117, 117, 117),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (article.author != null)
                      Text(
                        "By ${article.author!}",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 117, 117, 117),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                )
              ],
            ),
            if (article.name != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      List<Article> filteredArticles = [];
                      for (var articles
                          in Provider.of<NewsProvider>(context, listen: false)
                              .articles
                              .entries) {
                        for (Article article_ in articles.value) {
                          if (article_.name == article.name) {
                            filteredArticles.add(article_);
                          }
                        }
                      }

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => HeadlinesScreen(
                              articles: filteredArticles, topic: article.name!),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(230, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        article.name!,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 54, 54, 54),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
