import 'package:appazon/providers/products.dart';
import 'package:appazon/screens/cart/widgets/cart_item.dart';
import 'package:appazon/screens/checkout/address.dart';
import 'package:appazon/screens/product_details/product_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  double total = 0;

  @override
  Widget build(BuildContext context) {
    double price = 0;

    Provider.of<Products>(context).cart.values.forEach((product) {
      price = price + product['product']['price'] * product['quantity'];
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Cart",
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/home');
            },
            icon: const Icon(
              Icons.home,
              color: Colors.black,
              shadows: [Shadow(color: Colors.black)],
            ),
          ),
        ],
      ),
      body: Provider.of<Products>(context).cart.values.isNotEmpty
          ? Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      for (final product
                          in Provider.of<Products>(context).cart.values)
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => ProductDetailsScreen(
                                    product: product['product'])));
                          },
                          child: CartItem(product: product),
                        ),
                      const SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2,
                          margin: const EdgeInsets.only(
                              left: 5, right: 5, bottom: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(224, 224, 224, 1),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromARGB(43, 0, 0, 0),
                                  spreadRadius: 1,
                                  blurRadius: 1)
                            ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Total : \$$price",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 43, 43, 43),
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => CheckoutScreen(),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width / 2 - 60,
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(0, 189, 79, 1),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromARGB(43, 0, 0, 0),
                                    spreadRadius: 1,
                                    blurRadius: 1)
                              ],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Checkout',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 16,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_back_ios,
                                  textDirection: TextDirection.rtl,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
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
