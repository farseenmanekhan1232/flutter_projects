import 'package:appazon/providers/products.dart';
import 'package:appazon/screens/product_details/product_details.dart';
import 'package:appazon/screens/wishlist/widgets/wishlist_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    Provider.of<Products>(context, listen: false).loadCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Wishlist",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            shadows: [Shadow(color: Colors.black)],
          ),
        ),
      ),
      body: Provider.of<Products>(context).wishlist.values.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  for (final product
                      in Provider.of<Products>(context).wishlist.values)
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) =>
                                ProductDetailsScreen(product: product)));
                      },
                      child: WishListItem(product: product),
                    )
                ],
              ),
            )
          : const Column(
              children: [
                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Nothing here...",
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
