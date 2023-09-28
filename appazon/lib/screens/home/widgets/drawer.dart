import 'package:appazon/screens/orders/orders.dart';
import 'package:appazon/screens/wishlist/wistlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 70,
                  fit: BoxFit.cover,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AppaZon',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "don't search your dad here",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (MediaQuery.of(context).orientation == Orientation.portrait)
              Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const WishlistScreen()));
                    },
                    title: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 56, 56, 56),
                        border: Border.all(
                            width: 1,
                            color: const Color.fromARGB(255, 85, 85, 85)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Wishlist',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.favorite_rounded,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const OrdersScreen(),
                        ),
                      );
                    },
                    title: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 56, 56, 56),
                        border: Border.all(
                            width: 1,
                            color: const Color.fromARGB(255, 85, 85, 85)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Orders',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.shopping_basket,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if (MediaQuery.of(context).orientation == Orientation.landscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const WishlistScreen()));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 56, 56, 56),
                        border: Border.all(
                            width: 1,
                            color: const Color.fromARGB(255, 85, 85, 85)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const OrdersScreen(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 56, 56, 56),
                        border: Border.all(
                            width: 1,
                            color: const Color.fromARGB(255, 85, 85, 85)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.shopping_basket,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            const Spacer(),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {
                FirebaseAuth.instance.signOut();

                Navigator.of(context).pushReplacementNamed('/welcome');
              },
              title: Container(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(
                      width: 1, color: const Color.fromARGB(255, 85, 85, 85)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign out',
                      style: TextStyle(
                        color: Color.fromARGB(255, 31, 31, 31),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
