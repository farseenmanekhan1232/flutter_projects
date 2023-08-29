import 'package:appazon/providers/user.dart';
import 'package:appazon/screens/wishlist/wistlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            const SizedBox(
              height: 20,
            ),
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
                      width: 1, color: const Color.fromARGB(255, 85, 85, 85)),
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
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    FirebaseAuth.instance.currentUser!.photoURL ?? "",
                    width: 70,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      FirebaseAuth.instance.currentUser!.displayName ?? "",
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser!.email ?? "",
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser!.phoneNumber ?? "",
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Provider.of<AuthenticatedUser>(context, listen: false)
                    .signOut();
                Navigator.of(context).pushReplacementNamed('/welcome');
              },
              title: Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 40),
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
                      'SignOut',
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
