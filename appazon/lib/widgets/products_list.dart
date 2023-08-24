import 'package:appazon/widgets/product_tile.dart';
import 'package:flutter/material.dart';

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
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          snapshot.data!.shuffle();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  runAlignment: WrapAlignment.start,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final product in snapshot.data!)
                      if (exclude == null || product['id'] != exclude)
                        ProductTile(product: product)
                  ],
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return const Text('error');
        } else {
          return const Text("nothing ");
        }
      },
    );
  }
}
