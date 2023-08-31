import 'dart:async';

import 'package:appazon/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPlacedScreen extends StatelessWidget {
  OrderPlacedScreen(
      {super.key,
      this.product,
      required this.price,
      required this.paymentMethod,
      required this.location});
  final String location;
  Map<String, dynamic>? product;
  final String paymentMethod;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: Provider.of<Products>(context, listen: false)
          .placeOrder(product, price, paymentMethod, location),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ],
              ),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Order Placed",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const Icon(
                Icons.check_circle_outline,
                size: 200,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/home');
                      if (product == null) {
                        Provider.of<Products>(context, listen: false)
                            .clearCart();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("Go to Home"),
                    ),
                  )
                ],
              ),
            ],
          );
        }
      },
    ));
  }
}
