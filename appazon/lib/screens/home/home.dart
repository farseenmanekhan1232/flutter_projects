import 'package:appazon/providers/products.dart';
import 'package:appazon/screens/cart/cart.dart';
import 'package:appazon/screens/search/search.dart';
import 'package:appazon/screens/home/widgets/categories.dart';
import 'package:appazon/screens/home/widgets/drawer.dart';
import 'package:appazon/widgets/products_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    Provider.of<Products>(context, listen: false)
        .setSize(MediaQuery.of(context).size.width);
    Provider.of<Products>(context, listen: false).loadEverything();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 60.0,
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Tab(
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    FirebaseAuth.instance.currentUser!.photoURL ?? "",
                    width: 30,
                  ),
                ),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height - 100,
                  ),
                  enableDrag: true,
                  showDragHandle: true,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => SizedBox(
                      height: MediaQuery.of(context).size.height - 20,
                      child: const Search()));
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              right: 10,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height - 150,
                      ),
                      enableDrag: true,
                      showDragHandle: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => SizedBox(
                        height: MediaQuery.of(context).size.height - 150,
                        child: const CartScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  alignment: Alignment.topRight,
                  width: 45,
                  child: Container(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Consumer<Products>(
                        builder: (context, value, child) => Text(
                          value.cart.length.toString(),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: RefreshIndicator(
        color: const Color.fromARGB(255, 173, 173, 173),
        onRefresh: () async {
          return Provider.of<Products>(context, listen: false).loadEverything();
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (MediaQuery.of(context).orientation == Orientation.portrait)
                const SizedBox(
                  height: 100,
                ),
              if (MediaQuery.of(context).orientation == Orientation.landscape)
                const SizedBox(
                  height: 50,
                ),
              const Categories(),
              const SizedBox(
                height: 20,
              ),
              ProductsList(
                title: "Today's Deals",
                productsFuture: Provider.of<Products>(context, listen: false)
                    .getProducts('top'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
