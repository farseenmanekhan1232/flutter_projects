import 'dart:math';

import 'package:appazon/providers/products.dart';
import 'package:appazon/screens/category/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<Products>(context).loadCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Wrap(
                  runSpacing: 5.0,
                  spacing: 5.0,
                  children: [
                    for (final String category in snapshot.data!)
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  CategoryScreen(category: category),
                            ),
                          );
                        },
                        child: Container(
                            margin: const EdgeInsets.all(5),
                            width: MediaQuery.of(context).size.width / 2 - 40,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors
                                    .primaries[Random()
                                        .nextInt(Colors.primaries.length)]
                                    .shade800,
                              ),
                              child: Text(
                                category,
                                style: const TextStyle(
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(color: Colors.black),
                                  ],
                                ),
                              ),
                            )),
                      )
                  ],
                ),
              ],
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return const Text('error');
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
