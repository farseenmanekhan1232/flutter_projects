import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapsdemo/convert_latlang_to_address.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  final List<Marker> _markers = [];
  final List<Marker> _list = const [
    Marker(
      markerId: MarkerId('3'),
      position: LatLng(37.42796133580664, -122.095749655962),
    ),
    Marker(
      markerId: MarkerId('4'),
      position: LatLng(37.43786133580664, -122.085749655962),
    ),
    Marker(
      markerId: MarkerId('5'),
      position: LatLng(37.42796133580664, -122.085749655962),
    ),
    Marker(
      markerId: MarkerId('6'),
      position: LatLng(37.42796133580664, -122.075749655962),
    ),
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(37.40791133580664, -122.085749655962),
    ),
    Marker(
      markerId: MarkerId('2'),
      position: LatLng(20.5937, 78.9629),
      infoWindow: InfoWindow(
        title: "My current position",
      ),
    ),
  ];

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    _markers.addAll(_list);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_disabled_outlined),
        onPressed: () async {
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              const CameraPosition(
                target: LatLng(20.5937, 78.9629),
                zoom: 5,
              ),
            ),
          );
          setState(() {});
        },
      ),
      body: const SafeArea(
        child: ConvertLatLangToAddress(),
      ),
    );
  }
}
