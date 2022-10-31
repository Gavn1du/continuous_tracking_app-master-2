import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:continuous_tracking_app/change_notification.dart';
import 'package:continuous_tracking_app/change_settings.dart';
import 'package:continuous_tracking_app/get_location.dart';
import 'package:continuous_tracking_app/listen_location.dart';
import 'package:continuous_tracking_app/permission_status.dart';
import 'package:continuous_tracking_app/service_enabled.dart';

import 'map_page.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  _LocationPage createState() => _LocationPage();
}

class _LocationPage extends State<LocationPage> {
  final user = FirebaseAuth.instance.currentUser;
  // final name = user.username;
  // final email = user.email;
  //
  // // The user's ID, unique to the Firebase project. Do NOT use this value to
  // // authenticate with your backend server, if you have one. Use
  // // User.getIdToken() instead.
  // final uid = user.uid;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Location',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'Location Settings'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, this.title});
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title!),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: const <Widget>[
              SizedBox(height: 16),
              PermissionStatusWidget(),
              Divider(height: 32),
              ServiceEnabledWidget(),
              Divider(height: 32),
              GetLocationWidget(),
              Divider(height: 32),
              ListenLocationWidget(),
              Divider(height: 32),
              ChangeSettings(),
              Divider(height: 32),
              ChangeNotificationWidget()
            ],
          ),
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
              ListTile(
                leading: const Icon(Icons.map),
                title: const Text(' Map '),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MapPage()));
                }
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
                  child: const ListTile(
                    leading: Icon(Icons.settings, color: Colors.grey),
                    title: Text(' Settings ', style: TextStyle(color: Colors.grey)),
              )),
              SizedBox(height: MediaQuery.of(context).size.height - 480),
              Ink(
                  child: ListTile(
                      leading: const Icon(Icons.arrow_back),
                      title: const Text(' Back '),
                      onTap: () {
                        Navigator.pop(context);
                      }))
            ])));
  }
}
