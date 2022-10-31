import 'package:continuous_tracking_app/map_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'location_settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userProfile;
  final db = FirebaseDatabase.instance.ref();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  var email = '';
  var username = '';
  var location = '';
  var username1 = '';
  var profilePic = '';

  String description = "";

  @override
  Widget build(BuildContext context) {
    String like;
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Profile'),
        //   backgroundColor: Colors.green,
        // ),
        backgroundColor: const Color(0xffdee2fe),
        body: Stack(
            children: [
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
                    like = tilesList['profilePic'].toString();
                    email = love;
                    username = kiss;
                    location = hug;
                    username1 = kiss[0];
                    profilePic = like;
                  }
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Maps Sample App'),
                      backgroundColor: Colors.green,
                    ),
                    body: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 20,
                            child: Column(
                              children: [
                                Container(
                                  height: 200,
                                  width: 300,
                                  margin: const EdgeInsets.only(
                                    top: 100,
                                    bottom: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(2, 2),
                                        blurRadius: 10,
                                      ),
                                    ],
                                    image:  DecorationImage(
                                      image: NetworkImage(profilePic),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Text(
                                  description,
                                  style: const TextStyle(
                                    fontFamily: "Montserrat",
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 20,
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 20,
                                left: 24,
                                right: 24,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                      bottom: 50,
                                      right: 0,
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                const MapPage()),
                                          );
                                        },
                                        heroTag: "btn1",
                                        child: const Icon(
                                          Icons.map,
                                          size: 30,
                                        ),
                                      )),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "PROFILE",
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      listProfile(Icons.person, "Username", username),
                                      listProfile(Icons.date_range, "Date of Birth",
                                          "Placeholder"),
                                      listProfile(
                                          Icons.location_pin, "Location", location),
                                      listProfile(
                                          Icons.male, "Gender", "Placeholder"),
                                      listProfile(
                                          Icons.phone, "Phone Number", "Placeholder"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]
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
                            Ink(child: ListTile(
                                leading: const Icon(Icons.map),
                                title: const Text(' Map '),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const MapPage()));
                                }
                            )),
                            Ink(
                                child: const ListTile(
                                  leading: Icon(Icons.account_circle, color: Colors.grey),
                                  title: Text(' My Profile ',
                                      style: TextStyle(color: Colors.grey)),

                                )),
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
                            SizedBox(height: MediaQuery.of(context).size.height - 480),
                            Ink(
                                child: ListTile(
                                    leading: const Icon(Icons.arrow_back),
                                    title: const Text(' Back '),
                                    onTap: () {
                                      Navigator.pop(context);
                                    }))
                          ],
                        )
                    ),
                  );
                },
              )
            ]
        ),
      ),
    );
  }

  Widget listProfile(IconData icon, String text1, String text2) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1,
                style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: "Montserrat",
                  fontSize: 14,
                ),
              ),
              Text(
                text2,
                style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}