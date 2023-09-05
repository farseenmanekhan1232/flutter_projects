import 'package:appazon/providers/products.dart';
import 'package:appazon/screens/cart/widgets/cart_item.dart';
import 'package:appazon/screens/checkout/order_placed.dart';
import 'package:appazon/screens/product_details/product_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen(
      {super.key, required this.location, this.savedLocation, this.product});

  final String location;

  bool? savedLocation;

  Map<String, dynamic>? product;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isAdded = false;

  int paymentMode = -1;
  String paymentMethod = "";

  final TextEditingController _controller = TextEditingController();

  String phoneNumber = "";

  @override
  void initState() {
    if (widget.savedLocation != null) {
      setState(() {
        isAdded = true;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double price = 0.0;

    if (widget.product != null) {
      price = widget.product!.values.first!['product']['price'].toDouble();
    } else {
      Provider.of<Products>(context).cart.values.forEach(
        (product) {
          price = price + product['product']['price'] * product['quantity'];
        },
      );
    }

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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Address : ",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    // height: 80,
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 10, right: 10),

                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 241, 241, 241),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 70,
                          child: Text(
                            widget.location,
                          ),
                        ),
                        widget.savedLocation == null
                            ? !isAdded
                                ? SizedBox(
                                    width: 20,
                                    child: IconButton(
                                      onPressed: () async {
                                        await Provider.of<Products>(context,
                                                listen: false)
                                            .saveLocation(widget.location);

                                        setState(() {
                                          isAdded = true;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.add_circle,
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(12),
                                    child: const Icon(
                                      Icons.check_circle,
                                    ),
                                  )
                            : const SizedBox()
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Phone no : ",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      controller: _controller,
                      validator: (value) {
                        if (phoneNumber.isEmpty) {
                          return "Enter valid phone number";
                        } else if (phoneNumber[0] != '+') {
                          return "Enter country code first";
                        } else if (phoneNumber.length < 9) {
                          return "Enter valid phone number";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          phoneNumber = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Overview",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      if (widget.product == null)
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
                            child: CartItem(product: product, checkout: true),
                          ),
                      if (widget.product != null)
                        for (final product_ in widget.product!.values)
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => ProductDetailsScreen(
                                      product: product_['product']),
                                ),
                              );
                            },
                            child: CartItem(product: product_, checkout: true),
                          )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Payment mode",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            paymentMode = 1;
                            paymentMethod = "Google Pay";
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: paymentMode == 1
                                  ? const Color.fromARGB(255, 30, 148, 245)
                                  : const Color.fromARGB(255, 206, 206, 206),
                            ),
                          ),
                          child: Image.asset(
                            "assets/images/gpay.png",
                            width: 80,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            paymentMode = 2;
                            paymentMethod = "PhonePe";
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: paymentMode == 2
                                  ? const Color.fromARGB(255, 30, 148, 245)
                                  : const Color.fromARGB(255, 206, 206, 206),
                            ),
                          ),
                          child: Image.asset(
                            "assets/images/phonepe.png",
                            width: 80,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            paymentMode = 3;
                            paymentMethod = "Paytm";
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              color: paymentMode == 3
                                  ? const Color.fromARGB(255, 30, 148, 245)
                                  : const Color.fromARGB(255, 206, 206, 206),
                            ),
                          ),
                          child: Image.asset(
                            "assets/images/paytm.png",
                            width: 80,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        paymentMode = 4;
                        paymentMethod = "COD";
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: paymentMode == 4
                                ? const Color.fromARGB(255, 30, 148, 245)
                                : const Color.fromARGB(255, 206, 206, 206),
                          ),
                        ),
                        child: const Text(
                          'Cash on Delivery',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: paymentMode != -1
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => OrderPlacedScreen(
                                product: widget.product,
                                price: price,
                                paymentMethod: paymentMethod,
                                location: widget.location,
                                phoneNumber: phoneNumber),
                          ),
                        );
                      }
                    : null,
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  decoration: BoxDecoration(
                    color: paymentMode != -1
                        ? const Color.fromARGB(255, 0, 226, 94)
                        : Colors.grey,
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
                        ' Proceed',
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
    );
  }
}
