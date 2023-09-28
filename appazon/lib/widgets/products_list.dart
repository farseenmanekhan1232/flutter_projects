import 'dart:convert';

import 'package:appazon/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductsList extends StatelessWidget {
  ProductsList({
    super.key,
    required this.productsFuture,
    required this.title,
    this.exclude,
  });

  final String title;
  final Future productsFuture;

  int? exclude;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          final data = [];
          if (snapshot.data.runtimeType == Response) {
            data.addAll(jsonDecode(snapshot.data.body));
          } else {
            data.addAll(snapshot.data);
          }

          if (data.isEmpty) {
            return const Text("");
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? double.infinity
                          : MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    runAlignment: WrapAlignment.start,
                    alignment: WrapAlignment.center,
                    children: [
                      for (final product in data)
                        if (exclude == null || product['id'] != exclude)
                          ProductTile(product: product)
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Text('error');
        }
      },
    );
  }
}
