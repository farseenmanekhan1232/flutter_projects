import 'dart:async';
import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart' show locationFromAddress;
import 'package:geocoding/geocoding.dart' show placemarkFromCoordinates;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

class GoogleMapsWidget extends StatefulWidget {
  const GoogleMapsWidget({super.key, required this.selectLocation});

  final void Function(String) selectLocation;

  @override
  State<GoogleMapsWidget> createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
  LatLng? _locationInput;
  final Completer<GoogleMapController> _controller = Completer();

  Location location = Location();
  List<Marker> _markers = [];

  List<dynamic> _placesList = [];

  var uuid = const Uuid();

  final String _sessionToken = "123";

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  void _handleInput(String? input) async {
    if (input == null || input.isEmpty) return;
    await dotenv.load(fileName: "lib/screens/checkout/widgets/.env");
    final String kplacesApiKey = dotenv.env["API_KEY"]!;
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kplacesApiKey&sessiontoken=$_sessionToken';

    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(response.body)['predictions'];
      });
    }
  }

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
    if (mounted) {
      setState(() {
        _locationInput = LatLng(lat, lng);

        _markers = [
          Marker(
            markerId: const MarkerId('location'),
            position: _locationInput!,
            infoWindow: const InfoWindow(title: "Your Location"),
          )
        ];
      });
      final place = await placemarkFromCoordinates(lat, lng);
      String location =
          "${place[1].subLocality!.isNotEmpty ? "${place[1].subLocality}," : ""} ${place[1].locality}, ${place[1].administrativeArea}, ${place[1].country}, ${place[1].postalCode}";

      widget.selectLocation(location);
    }

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _locationInput!, zoom: 14.7),
      ),
    );
  }

  void setLocation(String input) async {
    widget.selectLocation(input);
    var response = await locationFromAddress(input);

    if (mounted) {
      setState(() {
        _locationInput = LatLng(response[0].latitude, response[0].longitude);

        _markers = [
          Marker(
            markerId: const MarkerId('location'),
            position: _locationInput!,
            infoWindow: InfoWindow(
              title: input,
            ),
          )
        ];
      });
    }

    if (_locationInput == null) return;

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _locationInput!, zoom: 14.7),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _locationInput == null
        ? const Column(
            children: [
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          )
        : Stack(
            children: [
              GoogleMap(
                zoomControlsEnabled: false,
                onTap: (latlng) async {
                  if (mounted) {
                    var place = await placemarkFromCoordinates(
                        latlng.latitude, latlng.longitude);

                    String input =
                        "${place[1].subLocality!.isNotEmpty ? "${place[1].subLocality}," : ""} ${place[1].locality}, ${place[1].administrativeArea}, ${place[1].country}, ${place[1].postalCode}";
                    setLocation(input);
                  }
                },
                markers: _markers.isEmpty ? {} : Set.of(_markers),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                initialCameraPosition: CameraPosition(
                  target: _locationInput!,
                  zoom: 14.7,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      child: TextFormField(
                        autofocus: true,
                        onChanged: _handleInput,
                        decoration: const InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Search"),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _placesList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setLocation(_placesList[index]['description']);
                                setState(() {
                                  _placesList.clear();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border.symmetric(
                                    vertical: BorderSide(
                                        color: Colors.black, width: 2),
                                  ),
                                ),
                                child: Text(
                                  _placesList[index]['description'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
