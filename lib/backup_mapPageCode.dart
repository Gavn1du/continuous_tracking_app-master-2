import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'location_settings.dart';
import 'profile_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPage createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  late List keys = [];
  late List usernames = [];
  final Set<Marker> markers = {};
  var ref = FirebaseDatabase.instance.ref().child("friends/${FirebaseAuth.instance.currentUser?.uid}");
  final ref1 = FirebaseDatabase.instance.ref().child("users/");
  var friendsProfile;
  var usernameOutput;
  var latitudeOutput;
  var longitudeOutput;

  void getKeys() async {
    ref.onValue.listen((event) {
      final love = Map<String,dynamic>.from(event.snapshot.value as Map);
      keys = love.keys.toList();
    });
  }

  final db = FirebaseDatabase.instance.ref();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  var email = '';
  var username = '';
  var location = '';
  var username1 = '';
  var profilePic = '';
  var friends = '';

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return MaterialApp(
        home: Scaffold(
          // appBar: AppBar(
          //   title: const Text('Maps Sample App'),
          //   backgroundColor: Colors.green,
          // ),
            body: Stack(children: [
              StreamBuilder(
                stream: db.child("users/$uid").orderByKey().onValue,
                builder: (context, snapshot) {
                  final tilesList = {};
                  if (snapshot.hasData) {
                    final cardsList = Map<String, dynamic>.from(
                        (snapshot.data! as DatabaseEvent).snapshot.value as Map);
                    for (dynamic type in cardsList.keys) {
                      tilesList[type] = cardsList[type];
                    }
                    var love = tilesList['email'].toString();
                    var kiss = tilesList['username'].toString();
                    var hug = tilesList['location'].toString();
                    email = love;
                    username = kiss;
                    location = hug;
                    username1 = kiss[0];
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
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10.0))),
                                  )),
                              const SizedBox(height:180),
                              const Text("This is the sliding Widget")]),
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
                          GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: _center,
                              zoom: 11.0,
                            ),
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
                              leading: Icon(Icons.map, color: Colors.grey),
                              title:
                              Text(' Map ', style: TextStyle(color: Colors.grey)),
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
                                            builder: (context) => const LocationPage()));
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
                },
              ),
            ])));
  }
}
