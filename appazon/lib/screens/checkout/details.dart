import 'package:appazon/providers/products.dart';
import 'package:appazon/screens/cart/widgets/cart_item.dart';
import 'package:appazon/screens/checkout/order_placed.dart';
import 'package:appazon/screens/product_details/product_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen({
    super.key,
    required this.location,
    this.savedLocation,
    this.product,
  });

  final String location;

  bool? savedLocation;

  Map<String, dynamic>? product;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isAdded = false;
  double price = 0.0;

  final _key = GlobalKey<FormState>();

  final TextEditingController _controller = TextEditingController();

  String phoneNumber = "";

  @override
  void initState() {
    if (widget.savedLocation != null) {
      setState(() {
        isAdded = true;
      });
    }

    if (widget.product != null) {
      setState(() {
        price = widget.product!.values.first!['product']['price'].toDouble();
      });
    } else {
      setState(() {
        Provider.of<Products>(
          context,
        ).cart.values.forEach(
          (product) {
            price = (price + product['product']['price'] * product['quantity']);
          },
        );
      });
    }
    super.initState();
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(context, "Payment Failed", "${response.message}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");

    Navigator.of(context).popUntil(ModalRoute.withName('/home'));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => OrderPlacedScreen(
            product: widget.product,
            price: price,
            paymentMethod: response.paymentId!,
            location: widget.location,
            phoneNumber: phoneNumber),
      ),
    );
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                                    width: 20,
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
                    key: _key,
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      validator: (value) {
                        RegExp format =
                            RegExp(r'^\+[0-9]{1,3}[7-9]([0-9]{9})$');

                        if (value == null) {
                          return "Enter phone number ";
                        } else if (!format.hasMatch(value)) {
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
                                    product: product['product'],
                                  ),
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
                                    product: product_['product'],
                                  ),
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
                  SizedBox(
                      child: Column(
                    children: [
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
                        height: 20,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Amount : "),
                              Text("\$$price")
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Shipping Charges",
                              ),
                              Text(
                                '\$${(price * 0.0121).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 112, 112, 112),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Final Amount :"),
                              Text(
                                "\$${(price * 0.0121 + price).toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                        ],
                      )
                    ],
                  ))
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: (_key.currentState != null
                        ? _key.currentState!.validate()
                        : false)
                    ? () {
                        final razorpay = Razorpay();

                        double billAmount = price * 100.00 + price * 12.10;

                        final options = {
                          'key': 'rzp_test_bAzBDm2llxnyHw',
                          'amount': billAmount.toInt(),
                          "currency": "USD",
                          'name': 'Appazon',
                          'retry': {'enabled': true, 'max_count': 1},
                          'send_sms_hash': true,
                          'prefill': {
                            "email": "test@razorpay.com",
                            'contact': phoneNumber,
                          },
                          'external': {
                            'wallets': ['paytm']
                          }
                        };
                        razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                            handlePaymentErrorResponse);
                        razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                            handlePaymentSuccessResponse);
                        razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                            handleExternalWalletSelected);
                        razorpay.open(options);
                      }
                    : null,
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  decoration: BoxDecoration(
                    color: (_key.currentState != null
                            ? _key.currentState!.validate()
                            : false)
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
