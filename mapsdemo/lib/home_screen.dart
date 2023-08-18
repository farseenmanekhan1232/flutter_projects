import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' show locationFromAddress;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mapsdemo/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng? _locationInput;
  Completer<GoogleMapController> _controller = Completer();

  Location location = Location();
  List<Marker> _markers = [];

  void _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) return;

    setState(() {
      _locationInput = LatLng(lat, lng);
      _markers = [
        Marker(markerId: MarkerId('location'), position: _locationInput!)
      ];
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _locationInput!, zoom: 14.7),
      ),
    );
  }

  void setLocation(String input) async {
    var response = await locationFromAddress(input);

    setState(() {
      _locationInput = LatLng(response[0].latitude, response[0].longitude);

      _markers = [
        Marker(markerId: MarkerId('location'), position: _locationInput!)
      ];
    });

    if (_locationInput == null) return;

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _locationInput!, zoom: 14.7),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Location',
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => SearchScreen(setLocation: setLocation)));
              },
              icon: const Icon(Icons.search))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.location_searching),
      ),
      body: _locationInput == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No Location Selected'),
                ],
              ),
            )
          : GoogleMap(
              markers: _markers.isEmpty ? {} : Set.of(_markers),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              initialCameraPosition: CameraPosition(
                target: _locationInput!,
                zoom: 14.7,
              ),
            ),
    );
  }
}
