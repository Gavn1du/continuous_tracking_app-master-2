import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'location_settings.dart';
import 'map_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(""),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 20),
          const Icon(Icons.satellite_alt, size: 100, color: Colors.green),
          const SizedBox(height: 50),
          const Icon(Icons.settings_input_antenna,
              size: 100, color: Colors.greenAccent),
          const SizedBox(height: 25),
          Center(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.teal[100], shape: BoxShape.circle),
                  width: 280.0,
                  height: 280.0,
                  child: const Center(
                      child: Text('Finding\nGrandmas',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 55))))),
          const SizedBox(height: 30),
          Ink(
              decoration: const ShapeDecoration(
                color: Colors.lightBlue,
                shape: CircleBorder(),
              ),
              child: IconButton(
                  iconSize: 50.0,
                  color: Colors.white,
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {
                    print("pressed");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MapPage()));
                  }))

          // Ink(
          //     decoration: const ShapeDecoration(
          //       color: Colors.lightBlue,
          //       shape: CircleBorder(),
          //     ),
          //     child: IconButton(
          //         iconSize: 50.0,
          //         color: Colors.white,
          //         icon: const Icon(Icons.play_arrow),
          //         onPressed: () {
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => const GameSelection()));
          //         }))
        ]));
  }
}