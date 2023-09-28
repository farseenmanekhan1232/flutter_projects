import 'package:appazon/screens/cart/widgets/cart_item.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({super.key, required this.details});

  final Map<String, dynamic> details;

  @override
  Widget build(BuildContext context) {
    print(details);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.7,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        title: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/home');
          },
          icon: const Icon(
            Icons.home_filled,
            color: Color.fromARGB(255, 29, 29, 29),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Shipping Address",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text("${details['location']}"),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Amount Paid",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "\$${details['price']}",
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 48, 133, 50),
              ),
            ),
            Text(
              "Transaction Id : ${details['paymentMethod']}",
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 107, 107, 107),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Products",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                for (final product in details['products'].entries)
                  CartItem(
                    product: product.value,
                    checkout: true,
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
