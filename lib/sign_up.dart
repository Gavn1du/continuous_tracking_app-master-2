import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'location_settings.dart';
import 'map_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var usernameController = TextEditingController();
  var cardHaving = TextEditingController();
  String locationController = "";
  String descriptionController = "";
  String profilePicController = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
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
                  controller: usernameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      hintText: 'Please use your real name'),
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
              const SizedBox(height: 50),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  child: const Text('Sign Up!'),
                  onPressed: () {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text)
                        .then((authResult) {
                      //print("Successfully signed up UID! UID: ${authResult.user!.uid}");

                      var userProfile = {
                        'uid': authResult.user!.uid,
                        'email': emailController.text,
                        'password': passwordController.text,
                        'username': usernameController.text,
                        'latitude': 27.1144,
                        'longitude': 38.8887,
                      };
                      FirebaseDatabase.instance
                          .ref()
                          .child("friends/${authResult.user!.uid}")
                          .set({
                        authResult.user!.uid: "true",
                      });

                      FirebaseDatabase.instance
                          .ref()
                          .child("users/${authResult.user!.uid}")
                          .set(userProfile)
                          .then((value) {
                        // print("Successfully created a portfolio");
                      }).catchError((error) {
                        print("Failed to create a portfolio");
                      });
                      Navigator.pop(context);
                    }).catchError((error) {
                      // print("Failed to sign up!");
                      // print(error.toString());
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
