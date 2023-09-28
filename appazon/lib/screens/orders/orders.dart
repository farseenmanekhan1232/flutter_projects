import 'package:appazon/providers/products.dart';
import 'package:appazon/screens/cart/widgets/cart_item.dart';
import 'package:appazon/screens/loader.dart';
import 'package:appazon/screens/orders/order_details.dart';
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
        body: RefreshIndicator(
            onRefresh: () async {
              await Provider.of<Products>(context, listen: false).loadOrders();
            },
            child: FutureBuilder(
              future:
                  Provider.of<Products>(context, listen: false).loadOrders(),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Shipping Address : "),
                                  Text("${order.value['location']}"),
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
                                            "\$${order.value['price'].toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 36, 182, 0),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) => OrderDetails(
                                                  details: order.value)));
                                    },
                                    child: const Text("Order Overview",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        )),
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
            )));
  }
}
