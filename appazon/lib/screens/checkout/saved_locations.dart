import 'package:appazon/providers/products.dart';
import 'package:appazon/screens/checkout/details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedLocations extends StatefulWidget {
  const SavedLocations({super.key});

  @override
  State<SavedLocations> createState() => _SavedLocationsState();
}

class _SavedLocationsState extends State<SavedLocations> {
  @override
  Widget build(BuildContext context) {
    Future<List<String>> getLocations =
        Provider.of<Products>(context, listen: false).loadSavedLocations();

    return FutureBuilder(
      future: getLocations,
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => DetailsScreen(
                            location: location,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 235, 235, 235),
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
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
    );
  }
}
