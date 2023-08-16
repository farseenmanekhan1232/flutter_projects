import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/widgets/article_large.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatefulWidget {
  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  late List<MapEntry<String, Article>> favourites;

  @override
  void didChangeDependencies() {
    favourites = Provider.of<NewsProvider>(context).favourites.entries.toList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (favourites.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: Text(
            "Add Favourite Articles",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Your Favourites",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: favourites.length,
        itemBuilder: (context, index) {
          return ArticleLarge(article: favourites[index].value, heading: "");
        },
      ),
    );
  }
}
