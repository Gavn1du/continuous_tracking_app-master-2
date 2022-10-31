import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'location_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  var userProfile;
  final db = FirebaseDatabase.instance.ref();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  var profilePic = '';
  var username = '';
  var location = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          backgroundColor: Colors.green,
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.green),
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Colors.green),
                    accountName: Text(
                      "Gavin Du",
                      style: TextStyle(fontSize: 18),
                    ),
                    accountEmail: Text("gavindu88@gmail.com"),
                    currentAccountPictureSize: Size.square(50),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 165, 255, 137),
                      child: Text(
                        "G",
                        style: TextStyle(fontSize: 30.0, color: Colors.blue),
                      ), //Text
                    ),
                  )),
              const ListTile(
                leading: Icon(Icons.map, color: Colors.grey),
                title: Text(' Map ', style: TextStyle(color: Colors.grey)),
              ),
              Ink(
                  child: const ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text(' My Profile '),
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
                      }
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}