import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'location_settings.dart';
import 'main_page.dart';
import 'map_page.dart';
import 'sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 150,
                      /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                      child: Image.network(
                          'https://ichef.bbci.co.uk/news/976/cpsprodpb/15E47/production/_124717698_gettyimages-1395200655.jpg')),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter valid email id as abc@gmail.com'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                ),
              ),
              TextButton(
                onPressed: () {
                  print("Forgot Password");
                },
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  child: const Text('Sign In'),
                  onPressed: () {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text)
                        .then((value) {
                      print("Successfully Logged in!");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainPage()),
                      );
                    }).catchError((error) {
                      print("Failed to log in!");
                      print(error.toString());
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 130,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SignupPage()));
                },
                child: const Text(
                  'No Account? Sign up!',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
