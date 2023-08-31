import 'package:appazon/providers/products.dart';
import 'package:appazon/widgets/products_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
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
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            ProductsList(
              productsFuture:
                  Provider.of<Products>(context).loadProducts(category),
              title: "🔥 Hot Deals on ${category.toUpperCase()}",
            ),
          ],
        ),
      ),
    );
  }
}
