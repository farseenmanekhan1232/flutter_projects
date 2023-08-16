import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/screens/article/full_article.dart';
import 'package:page_transition/page_transition.dart';
import 'package:transparent_image/transparent_image.dart';

class ArticleLarge extends StatelessWidget {
  const ArticleLarge({super.key, required this.article, required this.heading});

  final Article article;
  final String heading;

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
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10, left: 10),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: article.imageUrl,
                width: 150,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    article.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
