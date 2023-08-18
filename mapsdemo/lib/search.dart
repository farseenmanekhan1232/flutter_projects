import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import "package:http/http.dart" as http;

class SearchScreen extends StatefulWidget {
  SearchScreen({required this.setLocation, super.key});

  void Function(String input) setLocation;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> _placesList = [];

  var uuid = Uuid();

  String _sessionToken = "123";

  void _handleInput(String input) async {
    String kPLACES_API_KEY = "API KEY HERE";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(response.body)['predictions'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Form(
              child: TextFormField(
                autofocus: true,
                onChanged: _handleInput,
              ),
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _placesList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    widget.setLocation(_placesList[index]['description']);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      border: Border.symmetric(
                        vertical: BorderSide(color: Colors.black, width: 2),
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
    );
  }
}
