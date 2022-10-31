import 'dart:async';

import 'package:continuous_tracking_app/friends_page.dart';
import 'package:continuous_tracking_app/location_settings.dart';
import 'package:continuous_tracking_app/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const _pinkHue = 350.0;

class FriendsList extends StatefulWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  State<FriendsList> createState() => _FriendsList();
}

class _FriendsList extends State<FriendsList> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late List keys = [];
  late List values = [];
  late List usernames = [];
  final Set<Marker> markers = {};
  var ref = FirebaseDatabase.instance
      .ref()
      .child("friends/${FirebaseAuth.instance.currentUser?.uid}");
  final ref1 = FirebaseDatabase.instance.ref().child("users/");
  final Completer<GoogleMapController> _mapController = Completer();
  var friendsProfile;
  var usernameOutput;
  var latitudeOutput;
  var longitudeOutput;
  var email = '';
  var username = '';
  var username1 = '';

  void getKeys() async {
    ref.onValue.listen((event) {
      final love = Map<String, dynamic>.from(event.snapshot.value as Map);
      keys = love.values.toList();
      values = love.keys.toList();
      for (var i = 0; i < keys.length; i++) {
        if (keys[i] == 'true' && values[i] != uid) {
          keys[i] = values[i];
        } else {
          keys.remove(i);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getKeys();
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: StreamBuilder(
          stream: ref1.orderByKey().onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final tilesList = <ListTile>[];
              final allUsers = Map<String, dynamic>.from(
                  (snapshot.data! as DatabaseEvent).snapshot.value as Map);
              var love = allUsers[FirebaseAuth.instance.currentUser!.uid]
              ['email']
                  .toString();
              var kiss = allUsers[FirebaseAuth.instance.currentUser!.uid]
              ['username']
                  .toString();
              //var hug = allUsers[FirebaseAuth.instance.currentUser!.uid]['latitude'].toString();
              email = love;
              username = kiss;
              //location = hug;
              username1 = kiss[0];
              for (int i = 0; i < keys.length; i++) {
                if (allUsers.keys.contains(keys[i])) {
                  final nextMarker = Marker(
                    markerId: MarkerId(allUsers[keys[i]]['uid']
                    as String), //document['placeID'] as String
                    icon: BitmapDescriptor.defaultMarkerWithHue(_pinkHue),
                    position: LatLng(
                      allUsers[keys[i]]['latitude'],
                      allUsers[keys[i]]['longitude'],
                    ),
                    infoWindow: InfoWindow(
                      title: allUsers[keys[i]]['username']
                      as String, //document['name'] as String
                      //snippet: allUsers[keys[i]]['description'] as String, //document['address'] as String
                    ),
                  );
                  final nextTile = ListTile(
                    leading: const Icon(Icons.people),
                    title: Text("${allUsers[keys[i]]['username']}"),
                    subtitle: Text(
                        "${allUsers[keys[i]]['latitude']}, ${allUsers[keys[i]]['longitude']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              String alternate = keys[i];
                              DatabaseReference listPush = FirebaseDatabase
                                  .instance
                                  .ref()
                                  .child("friends/$uid");
                              listPush.update({
                                keys[i].toString(): "cancelled",
                              });
                              listPush = FirebaseDatabase.instance.ref().child("friends/$alternate");
                              listPush.update({
                                uid.toString(): "deleted",
                              });
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FriendsList()), // this mymainpage is your page to refresh
                                    (Route<dynamic> route) => false,
                              );
                            },
                            icon: const Icon(Icons.person_remove)),
                      ],
                    ),
                  );
                  tilesList.add(nextTile);
                  markers.add(nextMarker);
                }
              }
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Your Friends'),
                  backgroundColor: Colors.green,
                ),
                body: Column(
                  children: [
                    Flexible(
                      flex: 2,
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView(
                          children: tilesList,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FriendsPage()));
                        },
                        icon: const Icon(Icons.arrow_back))
                  ],
                ),
                // drawer: Drawer(
                //   // Add a ListView to the drawer. This ensures the user can scroll
                //   // through the options in the drawer if there isn't enough vertical
                //   // space to fit everything.
                //     child: ListView(
                //       // Important: Remove any padding from the ListView.
                //       padding: EdgeInsets.zero,
                //       children: [
                //         DrawerHeader(
                //             decoration: const BoxDecoration(color: Colors.green),
                //             child: UserAccountsDrawerHeader(
                //               decoration: const BoxDecoration(color: Colors.green),
                //               accountName: Text(
                //                 username,
                //                 style: const TextStyle(fontSize: 18),
                //               ),
                //               accountEmail: Text(email),
                //               currentAccountPictureSize: const Size.square(50),
                //               currentAccountPicture: CircleAvatar(
                //                 backgroundColor:
                //                 const Color.fromARGB(255, 165, 255, 137),
                //                 child: Text(
                //                   username1,
                //                   style: const TextStyle(
                //                       fontSize: 30.0, color: Colors.blue),
                //                 ), //Text
                //               ),
                //             )),
                //         const ListTile(
                //           leading: Icon(Icons.map),
                //           title: Text(' Map ',
                //               style: TextStyle(color: Colors.grey)),
                //         ),
                //         Ink(
                //             child: ListTile(
                //               leading: const Icon(Icons.account_circle, color: Colors.grey),
                //               title: const Text(' My Profile '),
                //               onTap: () {
                //                 Navigator.push(
                //                     context,
                //                     MaterialPageRoute(
                //                         builder: (context) =>
                //                         const ProfileScreen()));
                //               },
                //             )),
                //         Ink(
                //             child: ListTile(
                //               leading: const Icon(Icons.people),
                //               title: const Text(' Friends '),
                //               onTap: () {
                //                 Navigator.push(
                //                     context,
                //                     MaterialPageRoute(
                //                         builder: (context) =>
                //                         const FriendsPage()));
                //               },
                //             )),
                //         Ink(
                //             child: ListTile(
                //               leading: const Icon(Icons.settings),
                //               title: const Text(' Settings '),
                //               onTap: () {
                //                 Navigator.push(
                //                     context,
                //                     MaterialPageRoute(
                //                         builder: (context) =>
                //                         const LocationPage()));
                //               },
                //             )),
                //         const SizedBox(height: 300),
                //         Ink(
                //             child: ListTile(
                //                 leading: const Icon(Icons.arrow_back),
                //                 title: const Text(' Back '),
                //                 onTap: () {
                //                   Navigator.pop(context);
                //                 }))
                //       ],
                //     )
                // ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

// class StoreMap extends StatelessWidget {
//
//   const StoreMap({
//     Key? key,
//     required this.markerSets,
//     required this.initialPosition,
//     required this.mapController,
//   }) : super(key: key);
//
//   final LatLng initialPosition;
//   final Completer<GoogleMapController> mapController;
//   final Set<Marker> markerSets;
//
//   @override
//   Widget build(BuildContext context) {
//     return GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: initialPosition,
//           zoom: 12,
//         ),
//         markers: markerSets,
//
//         onMapCreated: (mapController) {
//           this.mapController.complete(mapController);
//         }
//     );
//   }
// }
