import 'package:appazon/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  CartItem({super.key, required this.product});

  final Map<String, dynamic> product;
  late final productDetails = product['product'];
  late final quantity = product['quantity'];
  late final selectedVariant = product['selectedVariant'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 240, 240, 240),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  productDetails['images'][0],
                  width: 100,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        productDetails['title'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "\$${productDetails['price'] * quantity}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "  ( ${productDetails['price']} x $quantity )",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Provider.of<Products>(context, listen: false).removeFromCart(
                    "${productDetails['id']}:$selectedVariant",
                  );
                },
                icon: const Icon(
                  Icons.delete,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Provider.of<Products>(context, listen: false)
                      .decreateQuantity(
                    "${productDetails['id']}:$selectedVariant",
                  );
                },
                icon: const Icon(Icons.remove_circle),
              ),
              Text(
                "$quantity",
                overflow: TextOverflow.ellipsis,
              ),
              IconButton(
                onPressed: () {
                  Provider.of<Products>(context, listen: false)
                      .increaseQuantity(
                    "${productDetails['id']}:$selectedVariant",
                  );
                },
                icon: const Icon(Icons.add_circle),
              ),
            ],
          )
        ],
      ),
    );
  }
}
