import 'package:flutter/material.dart';

import "package:cloud_firestore/cloud_firestore.dart";
import 'package:profile_app/screens/customize.dart';
import 'package:profile_app/screens/profile_details.dart';

class ProfileListScreen extends StatefulWidget {
  const ProfileListScreen({super.key});
  @override
  State<ProfileListScreen> createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('profiles').snapshots(),
          builder: (ctx, snapShots) {
            if (snapShots.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapShots.hasData || snapShots.data!.docs.isEmpty) {
              return const Center(
                child: Text('No Profiles'),
              );
            }

            if (snapShots.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            } else {
              final profiles = snapShots.data!.docs;
              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                children: [
                  for (final profile in profiles)
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => CustomizeScreen(
                              isEditing: true, profile: profile),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 2,
                        ),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 0.2,
                                blurRadius: 10,
                                color: Color.fromARGB(85, 158, 158, 158)),
                          ],
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: Column(
                          children: [
                            Image.network(
                              profile['image_url'],
                              loadingBuilder: (ctx, child, progress) {
                                if (progress == null)
                                  return child;
                                else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: [
                                Text(
                                  profile['username'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  profile['email'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
