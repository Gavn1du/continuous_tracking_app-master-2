import 'package:continuous_tracking_app/firebase_options.dart';
import 'package:continuous_tracking_app/map_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Clean Code',
        home: AnimatedSplashScreen(
            duration: 3000,
            splash: Image.network(
                "https://static.toiimg.com/photo/imgsize-1751158,msid-80568748/80568748.jpg"),
            nextScreen: FirstRoute(),
            splashTransition: SplashTransition.rotationTransition,
            backgroundColor: Colors.black));
  }
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

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
                            builder: (context) => const LoginPage()));
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
