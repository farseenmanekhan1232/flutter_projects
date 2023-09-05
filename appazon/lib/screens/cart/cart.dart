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

    return Provider.of<Products>(context).cart.values.isNotEmpty
        ? Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    for (final product
                        in Provider.of<Products>(context).cart.values)
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => ProductDetailsScreen(
                                  product: product['product']),
                            ),
                          );
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
                          color: const Color.fromARGB(255, 238, 238, 238),
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
                            color: const Color.fromARGB(255, 39, 199, 106),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Nothing here...",
                  ),
                ],
              )
            ],
          );
  }
}
