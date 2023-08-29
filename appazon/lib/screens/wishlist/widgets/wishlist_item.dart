import 'package:appazon/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishListItem extends StatelessWidget {
  const WishListItem({super.key, required this.product});

  final Map<String, dynamic> product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 80,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Hero(
                  tag: product['images'][0],
                  child: Image.network(
                    product['images'][0],
                    width: 100,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    product['title'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Provider.of<Products>(context, listen: false).toggleWishList(
                    product,
                  );
                },
                icon: const Icon(
                  Icons.delete,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
