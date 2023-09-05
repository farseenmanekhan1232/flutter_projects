import 'package:appazon/screens/checkout/details.dart';
import 'package:appazon/screens/checkout/saved_locations.dart';
import 'package:appazon/screens/checkout/widgets/google_maps.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  CheckoutScreen({super.key, this.direct = false, this.product});
  bool direct;
  Map<String, dynamic>? product;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedLocation = '';

  void selectLocation(String location) {
    setState(() {
      selectedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Stack(
        children: [
          GoogleMapsWidget(selectLocation: selectLocation),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(5),
                height: 100,
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
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          enableDrag: true,
                          showDragHandle: true,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            width: MediaQuery.of(context).size.width,
                            child: const SavedLocations(),
                          ),
                        );
                      },
                      child: const Text('Your Locations'),
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
          )
        ],
      ),
    );
  }
}
