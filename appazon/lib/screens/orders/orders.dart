import 'package:appazon/providers/products.dart';
import 'package:appazon/screens/cart/widgets/cart_item.dart';
import 'package:appazon/screens/loader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
  }

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
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          title: const Text(
            "Your Orders",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: FutureBuilder(
          future: Provider.of<Products>(context, listen: false).loadOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            } else {
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      for (final MapEntry order
                          in Provider.of<Products>(context).orders.entries)
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat.yMd().add_jm().format(
                                          DateTime.parse(
                                            order.key.toString(),
                                          ),
                                        ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text("Total Amount : "),
                                      Text(
                                        "\$${order.value['price'].toString()}",
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              for (final product
                                  in order.value['products'].entries)
                                CartItem(
                                  product: product.value,
                                  checkout: true,
                                )
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              );
            }
          },
        ));
  }
}
