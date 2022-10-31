import 'dart:async';

import 'package:continuous_tracking_app/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'location_settings.dart';

const _pinkHue = 350.0;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late List keys = [];
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

  void getKeys() async {
    ref.onValue.listen((event) {
      final love = Map<String, dynamic>.from(event.snapshot.value as Map);
      keys = love.keys.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    getKeys();
    return Scaffold(
        appBar: AppBar(
          title: const Text(""),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        body: StreamBuilder(
            stream: ref1.orderByKey().onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final tilesList = <ListTile>[];
                final allUsers = Map<String, dynamic>.from(
                    (snapshot.data! as DatabaseEvent).snapshot.value as Map);
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
                        // snippet: allUsers[keys[i]]['description'] as String, //document['address'] as String
                      ),
                    );
                    final nextTile = ListTile(
                      leading: const Icon(Icons.people),
                      title: Text("${allUsers[keys[i]]['username']}"),
                      subtitle: Text(
                          "${allUsers[keys[i]]['latitude']}, ${allUsers[keys[i]]['longitude']}"),
                    );
                    tilesList.add(nextTile);
                    markers.add(nextMarker);
                  }
                }
              }
              return Scaffold(
                  appBar: AppBar(
                    title: const Text('Maps Sample App'),
                    backgroundColor: Colors.green,
                  ),
                  body: SlidingUpPanel(
                    minHeight: 25,
                    maxHeight: 400,
                    parallaxEnabled: true,
                    parallaxOffset: .5,
                    panel: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Container(
                              height: 5.0,
                              width: 35.0,
                              color: Colors.transparent,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                              )),
                          const SizedBox(height: 180),
                          const Text("This is the sliding Widget")
                        ]),
                    collapsed: Container(
                      decoration: BoxDecoration(
                          color: Colors.lightBlueAccent, borderRadius: radius),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Container(
                              height: 5.0,
                              width: 35.0,
                              color: Colors.transparent,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                              )),
                        ],
                      ),
                    ),
                    borderRadius: radius,
                  ),
                  drawer: Drawer(
                    // Add a ListView to the drawer. This ensures the user can scroll
                    // through the options in the drawer if there isn't enough vertical
                    // space to fit everything.
                    child: ListView(
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: [
                        DrawerHeader(
                            decoration:
                            const BoxDecoration(color: Colors.green),
                            child: UserAccountsDrawerHeader(
                              decoration:
                              const BoxDecoration(color: Colors.green),
                              accountName: Text(
                                "Gavin",
                                style: const TextStyle(fontSize: 18),
                              ),
                              accountEmail: Text("placeholder"),
                              currentAccountPictureSize: const Size.square(50),
                              currentAccountPicture: CircleAvatar(
                                backgroundColor:
                                const Color.fromARGB(255, 165, 255, 137),
                                child: Text(
                                  "e",
                                  style: const TextStyle(
                                      fontSize: 30.0, color: Colors.blue),
                                ), //Text
                              ),
                            )),
                        const ListTile(
                          leading: Icon(Icons.map, color: Colors.grey),
                          title: Text(' Map ',
                              style: TextStyle(color: Colors.grey)),
                        ),
                        Ink(
                            child: ListTile(
                                leading: const Icon(Icons.account_circle),
                                title: const Text(' My Profile '),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const ProfileScreen()));
                                })),
                        Ink(
                            child: const ListTile(
                              leading: Icon(Icons.people),
                              title: Text(' Friends '),
                            )),
                        Ink(
                            child: ListTile(
                              leading: const Icon(Icons.settings),
                              title: const Text(' Settings '),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const LocationPage()));
                              },
                            )),
                        const SizedBox(height: 300),
                        Ink(
                            child: ListTile(
                                leading: const Icon(Icons.arrow_back),
                                title: const Text(' Back '),
                                onTap: () {
                                  Navigator.pop(context);
                                }))
                      ],
                    ),
                  ));
            }));
  }
}

class StoreMap extends StatelessWidget {
  const StoreMap({
    Key? key,
    required this.markerSets,
    required this.initialPosition,
    required this.mapController,
  }) : super(key: key);

  final LatLng initialPosition;
  final Completer<GoogleMapController> mapController;
  final Set<Marker> markerSets;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 12,
        ),
        markers: markerSets,
        onMapCreated: (mapController) {
          this.mapController.complete(mapController);
        });
  }
}
