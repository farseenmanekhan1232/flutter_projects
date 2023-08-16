import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app/models/article.dart';

import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

class NewsProvider extends ChangeNotifier {
  final Map<String, List<Article>> articles = {};
  final Map<String, Article> _favourites = {};

  get favourites => _favourites;

  Future<List<Article>> loadArticles(String url, String title) async {
    if (articles.entries.isNotEmpty) return articles[title]!;
    var response;

    try {
      response = await http.get(
        Uri.parse(url),
      );
    } catch (e) {
      return [];
    }

    if (jsonDecode(response.body)['articles'] == null) return [];

    List<Article> news = List<Article>.from(
        jsonDecode(response.body)['articles']
            .where((article) =>
                (article['source']['id'] != null &&
                    article['source']['name'] != null &&
                    article['title'] != null &&
                    article['description'] != null &&
                    article['url'] != null &&
                    article['urlToImage'] != null &&
                    article['publishedAt'] != null) &&
                article['content'] != null &&
                !['thehill.com', 'etimg', '.ru']
                    .any(article['urlToImage'].contains))
            .map((article) => Article(
                  name: article['source']['name'],
                  id: article['source']['id'],
                  title: article['title'],
                  description: article['description'],
                  url: article['url'],
                  imageUrl: article['urlToImage'],
                  publishedAt: article['publishedAt'],
                  content: article["content"],
                ))
            .toList());
    return news.sublist(0, news.length > 20 ? 20 : news.length);
  }

  Future<List<Article>> getArticles(String url, String title) async {
    List<Article> response;
    response = await loadArticles(url, title);
    if (response.isEmpty) {
      articles[title] = [];
    }
    articles[title] = response;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    for (Article article in response) {
      if (prefs.getStringList(article.url) != null) {
        _favourites[article.url] = article;
      }
    }

    loadFavourties();

    return response;
  }

  void loadFavourties() async {
    if (_favourites.isNotEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (String key in keys) {
      final article = prefs.getStringList(key);
      if (article != null) {
        _favourites[key] = Article(
          name: article[0],
          id: article[1],
          author: article[2],
          title: article[3],
          description: article[4],
          url: article[5],
          imageUrl: article[6],
          publishedAt: article[7],
          content: article[8],
        );
      }
    }
  }

  void setFavourite(Article article) async {
    _favourites[article.url] = article;
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      article.url,
      [
        article.name ?? "",
        article.id ?? "",
        article.author ?? "",
        article.title,
        article.description,
        article.url,
        article.imageUrl,
        article.publishedAt,
        article.content ?? ""
      ],
    );

    Fluttertoast.showToast(
        msg: "Added to Favourites",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);

    notifyListeners();
  }

  void removeFavourite(String url) async {
    _favourites.remove(url);
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(url);

    Fluttertoast.showToast(
      msg: "Removed from Favourites",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    notifyListeners();
  }
}
