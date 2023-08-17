import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';

class ConvertLatLangToAddress extends StatefulWidget {
  const ConvertLatLangToAddress({super.key});
  @override
  State<ConvertLatLangToAddress> createState() =>
      _ConvertLatLangToAddressState();
}

class _ConvertLatLangToAddressState extends State<ConvertLatLangToAddress> {
  String stAddress = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              final coordinates = Coordinates(33.6992, 72.9744);
              var address =
                  await Geocoder.local.findAddressesFromQuery('Hubballi');
              var first = address.first;
              print(first.addressLine.toString());
            },
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: const Center(
                child: Text("Convert"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
