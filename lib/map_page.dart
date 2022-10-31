import 'dart:async';

import 'package:continuous_tracking_app/friends_page.dart';
import 'package:continuous_tracking_app/location_settings.dart';
import 'package:continuous_tracking_app/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'login.dart';

const _pinkHue = 350.0;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late List keys = [];
  late List values = [];
  late List usernames = [];
  final Set<Marker> markers = {};
  var ref = FirebaseDatabase.instance.ref().child("friends/${FirebaseAuth.instance.currentUser?.uid}");
  final ref1 = FirebaseDatabase.instance.ref().child("users/");
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final Completer<GoogleMapController> _mapController = Completer();
  var friendsProfile;
  var usernameOutput;
  var latitudeOutput;
  var longitudeOutput;
  var email = '';
  var username = '';
  var username1 = '';

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void getKeys() async {
    ref.onValue.listen((event) {
      final love = Map<String,dynamic>.from(event.snapshot.value as Map);
      keys = love.values.toList();
      values = love.keys.toList();
      for (var i=0; i<keys.length; i++){
        if (keys[i] == 'true'){
          keys[i] = values[i];
        }
        else{
          keys.remove(i);
        }
        if (values[i] == uid){
          String you = 'you';
          String last = keys[i] + you;
        }
      }
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
      extendBodyBehindAppBar: true,
      body: StreamBuilder(
          stream: ref1.orderByKey().onValue,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              final tilesList = <ListTile> [];
              final allUsers = Map<String,dynamic>.from(
                  (snapshot.data! as DatabaseEvent).snapshot.value as Map);
              var love = allUsers[FirebaseAuth.instance.currentUser!.uid]['email'].toString();
              var kiss =allUsers[FirebaseAuth.instance.currentUser!.uid]['username'].toString();
              //var hug = allUsers[FirebaseAuth.instance.currentUser!.uid]['latitude'].toString();
              email = love;
              username = kiss;
              //location = hug;
              username1 = kiss[0];
              for (int i = 0; i < keys.length; i++) {
                if (allUsers.keys.contains(keys[i])) {
                  final nextMarker = Marker(
                    markerId: MarkerId(allUsers[keys[i]]['uid'] as String),//document['placeID'] as String
                    icon: BitmapDescriptor.defaultMarkerWithHue(_pinkHue),
                    position: LatLng(
                      allUsers[keys[i]]['latitude'],
                      allUsers[keys[i]]['longitude'],
                    ),
                    infoWindow: InfoWindow(
                      title: allUsers[keys[i]]['username'] as String, //document['name'] as String
                      //snippet: allUsers[keys[i]]['description'] as String, //document['address'] as String
                    ),
                  );
                  final nextTile = ListTile(
                    leading: const Icon(Icons.people),
                    title: Text("${allUsers[keys[i]]['username']}"),
                    subtitle: Text("${allUsers[keys[i]]['latitude']}, ${allUsers[keys[i]]['longitude']}"),
                  );
                  tilesList.add(nextTile);
                  markers.add(nextMarker);
                }
              }
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Maps And Friends'),
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
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                            )),
                        Flexible(
                          flex: 2,
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView(
                              children: tilesList,
                            ),
                          ),
                        ),]),
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
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                            )),
                      ],
                    ),
                  ),
                  body: Stack(children: [
                    Flexible(
                        flex: 3,
                        child: StoreMap(
                          markerSets: markers,
                          initialPosition: const LatLng(37.7786, -122.4375),
                          mapController: _mapController,
                        )
                    ),
                  ]),
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
                            decoration: const BoxDecoration(color: Colors.green),
                            child: UserAccountsDrawerHeader(
                              decoration: const BoxDecoration(color: Colors.green),
                              accountName: Text(
                                username,
                                style: const TextStyle(fontSize: 18),
                              ),
                              accountEmail: Text(email),
                              currentAccountPictureSize: const Size.square(50),
                              currentAccountPicture: CircleAvatar(
                                backgroundColor:
                                const Color.fromARGB(255, 165, 255, 137),
                                child: Text(
                                  username1,
                                  style: const TextStyle(
                                      fontSize: 30.0, color: Colors.blue),
                                ), //Text
                              ),
                            )),
                        const ListTile(
                            leading: Icon(Icons.map),
                            title: Text(' Map ',
                                style: TextStyle(color: Colors.grey)),
                        ),
                        Ink(
                            child: ListTile(
                              leading: const Icon(Icons.account_circle, color: Colors.grey),
                              title: const Text(' My Profile '),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const ProfileScreen()));
                              },
                            )),
                        Ink(
                            child: ListTile(
                              leading: const Icon(Icons.people),
                              title: const Text(' Friends '),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const FriendsPage()));
                              },
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
                        SizedBox(height: MediaQuery.of(context).size.height - 480),
                        Ink(
                            child: ListTile(
                                leading: const Icon(Icons.arrow_back),
                                title: const Text(' Sign Out '),
                                onTap: () {
                                  _signOut();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const LoginPage()));
                                }))
                      ],
                    )
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),
    );
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
        }
    );
  }
}