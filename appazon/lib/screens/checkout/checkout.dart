import 'package:appazon/providers/products.dart';
import 'package:appazon/screens/checkout/details.dart';
import 'package:appazon/screens/checkout/widgets/google_maps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  CheckoutScreen({super.key, this.direct = false, this.product});
  bool direct;
  Map<String, dynamic>? product;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedLocation = '';

  TextEditingController enterLocation = TextEditingController();

  void selectLocation(String location) {
    setState(() {
      selectedLocation = location;
    });
  }

  @override
  void dispose() {
    enterLocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width - 50,
                child: TextFormField(
                  controller: enterLocation,
                  decoration: const InputDecoration(hintText: "Enter Address"),
                ),
              ),
              IconButton(
                  onPressed: () {
                    selectLocation(enterLocation.text);
                  },
                  icon: const Icon(
                    Icons.check_circle,
                    size: 40,
                  ))
            ],
          ),
          const Text(
            "OR",
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            GoogleMapsWidget(selectLocation: selectLocation),
                      ),
                    );
                  },
                  icon: const Icon(Icons.map_sharp, size: 40))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? double.infinity
                        : MediaQuery.of(context).size.width / 2.5,
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(5),
                // height: 100,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(24, 0, 0, 0),
                        spreadRadius: 1,
                        blurRadius: 1)
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        selectedLocation.isEmpty
                            ? "Select Location"
                            : selectedLocation,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 107, 107, 107),
                        ),
                      ),
                    ),
                    const Text('Your Locations'),
                    FutureBuilder(
                      future: Provider.of<Products>(context, listen: false)
                          .loadSavedLocations(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            final List<String> locations = snapshot.data!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                for (final location in locations)
                                  InkWell(
                                    onTap: () {
                                      selectLocation(location);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.all(5),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 235, 235, 235),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        location,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return const Text("error");
                          } else {
                            return const Text("No saved locations");
                          }
                        } else {
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ]),
                            ],
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: selectedLocation.isNotEmpty
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => DetailsScreen(
                              location: selectedLocation,
                              product: widget.product,
                            ),
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
                    color: selectedLocation.isNotEmpty
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
