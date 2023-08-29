import 'package:appazon/providers/products.dart';
import 'package:appazon/screens/cart/cart.dart';
import 'package:appazon/screens/wishlist/wistlist.dart';
import 'package:appazon/widgets/product_details.dart';
import 'package:appazon/widgets/products_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Map<String, dynamic> product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with TickerProviderStateMixin {
  late final ScrollController _controller;

  late final AnimationController _animationController;

  late final Animation<double> _animation;

  late int _currentPrice;

  // @override
  // void didChangeDependencies() {

  //   // _animationController.reset();
  //   super.didChangeDependencies();
  // }

  @override
  void didChangeDependencies() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
      value: 0,
      lowerBound: 0,
      upperBound: 1,
    );

    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn);

    _controller = ScrollController(
      initialScrollOffset: 0,
      keepScrollOffset: true,
    );

    _controller.addListener(
      () {
        Provider.of<Products>(context, listen: false)
            .onScroll(_controller.offset, _animationController);
      },
    );

    _animationController.forward();

    super.didChangeDependencies();
  }

  void _getCurrentPrice(int variant) {
    _currentPrice = variant;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
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
            color: Colors.black,
            shadows: [Shadow(color: Colors.black)],
          ),
        ),
        title: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/home');
          },
          icon: const Icon(
            Icons.home_outlined,
            color: Colors.black,
          ),
        ),
        actions: [
          GestureDetector(
            onLongPress: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const WishlistScreen()));
            },
            child: IconButton(
                onPressed: () {
                  Provider.of<Products>(context, listen: false)
                      .toggleWishList(widget.product);
                },
                icon: Consumer<Products>(
                  builder: (context, value, child) => Icon(
                    value.wishlist.containsKey(widget.product['id'].toString())
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: Colors.black,
                  ),
                )),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _controller,
            child: Column(
              children: [
                ProductDetails(
                    product: widget.product, currentPrice: _getCurrentPrice),
                Container(
                  width: MediaQuery.of(context).size.width,
                ),
                ProductsList(
                  productsFuture: Provider.of<Products>(context, listen: false)
                      .loadProducts(
                    widget.product['category'],
                  ),
                  title: "Recommended",
                  exclude: widget.product['id'],
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
          Consumer<Products>(builder: (context, value, child) {
            return Container(
              child: value.scrolled
                  ? FadeTransition(
                      opacity: _animation,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => CartScreen(),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 5, right: 5, bottom: 20),
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              width: 1,
                                              color: const Color.fromARGB(
                                                  69, 0, 0, 0),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.shopping_cart_outlined,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 2),
                                          alignment: Alignment.topRight,
                                          width: 45,
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              value.cart.length.toString(),
                                              textAlign: TextAlign.right,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 114, 192, 255),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Color.fromARGB(43, 0, 0, 0),
                                            spreadRadius: 1,
                                            blurRadius: 1)
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.shopping_bag_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: value.cart.containsKey(
                                      "${widget.product['id'].toString()}:$_currentPrice",
                                    )
                                        ? () {
                                            Provider.of<Products>(context,
                                                    listen: false)
                                                .removeFromCart(
                                                    "${widget.product['id'].toString()}:$_currentPrice");
                                          }
                                        : () {
                                            Provider.of<Products>(context,
                                                    listen: false)
                                                .addToCart(widget.product,
                                                    _currentPrice);
                                          },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: value.cart.containsKey(
                                          "${widget.product['id'].toString()}:$_currentPrice",
                                        )
                                            ? const Color.fromARGB(
                                                255, 255, 130, 130)
                                            : const Color.fromARGB(
                                                255, 114, 147, 255),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: const [
                                          BoxShadow(
                                              color:
                                                  Color.fromARGB(43, 0, 0, 0),
                                              spreadRadius: 1,
                                              blurRadius: 1)
                                        ],
                                      ),
                                      child: Icon(
                                        value.cart.containsKey(
                                                "${widget.product['id'].toString()}:$_currentPrice")
                                            ? Icons
                                                .remove_shopping_cart_outlined
                                            : Icons.add_shopping_cart_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    )
                  : FadeTransition(
                      opacity: _animation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 5, right: 5, bottom: 10),
                                height: 50,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 60,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 114, 192, 255),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color.fromARGB(43, 0, 0, 0),
                                        spreadRadius: 1,
                                        blurRadius: 1)
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Buy Now',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.shopping_bag_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => CartScreen(),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 5, right: 5, bottom: 10),
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            width: 1,
                                            color: const Color.fromARGB(
                                                69, 0, 0, 0)),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.shopping_cart_outlined,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 2),
                                      alignment: Alignment.topRight,
                                      width: 45,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          value.cart.length.toString(),
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: value.cart.containsKey(
                                  "${widget.product['id'].toString()}:$_currentPrice",
                                )
                                    ? () {
                                        Provider.of<Products>(context,
                                                listen: false)
                                            .removeFromCart(
                                                "${widget.product['id'].toString()}:$_currentPrice");
                                      }
                                    : () {
                                        Provider.of<Products>(context,
                                                listen: false)
                                            .addToCart(
                                                widget.product, _currentPrice);
                                      },
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      60,
                                  margin: const EdgeInsets.only(
                                      left: 5, right: 5, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: value.cart.containsKey(
                                      "${widget.product['id'].toString()}:$_currentPrice",
                                    )
                                        ? const Color.fromARGB(
                                            255, 255, 130, 130)
                                        : const Color.fromARGB(
                                            255, 114, 147, 255),
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
                                        value.cart.containsKey(
                                          "${widget.product['id'].toString()}:$_currentPrice",
                                        )
                                            ? "Remove"
                                            : 'Add to Cart',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(
                                        value.cart.containsKey(
                                          "${widget.product['id'].toString()}:$_currentPrice",
                                        )
                                            ? Icons
                                                .remove_shopping_cart_outlined
                                            : Icons.add_shopping_cart_outlined,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            );
          })
        ],
      ),
    );
  }
}
