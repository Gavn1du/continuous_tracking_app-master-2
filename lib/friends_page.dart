import 'package:continuous_tracking_app/map_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'friends_list.dart';
import 'incoming_requests.dart';
import 'location_settings.dart';
import 'pendingPage.dart';
import 'profile_page.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final ref = FirebaseDatabase.instance.ref().child("friends/");
  final ref1 = FirebaseDatabase.instance.ref().child("users/");

  var requestController = TextEditingController();
  var userProfile;
  final db = FirebaseDatabase.instance.ref();
  var email = '';
  var username = '';
  var location = '';
  var username1 = '';
  var profilePic = '';

  String description = "";

  @override
  Widget build(BuildContext context) {
    dynamic friendsUID1;
    dynamic friendsProfile;
    String like;
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Profile'),
        //   backgroundColor: Colors.green,
        // ),
        backgroundColor: const Color(0xffdee2fe),
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
                like = tilesList['profilePic'].toString();
                email = love;
                username = kiss;
                location = hug;
                username1 = kiss[0];
                profilePic = like;
              }
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Friends'),
                  backgroundColor: Colors.green,
                ),
                body: SingleChildScrollView(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      Padding(
                        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: requestController,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  ref1
                                      .orderByChild("email")
                                      .equalTo(requestController.text)
                                      .onValue
                                      .listen((event) {
                                    friendsProfile = event.snapshot.value;
                                    final cardList = Map<String, dynamic>.from(
                                        friendsProfile);
                                    cardList.forEach((key, value) {
                                      final nextCard =
                                          Map<String, dynamic>.from(value);
                                      var friendsUID = nextCard['uid'];
                                      //print(friendsUID);
                                      friendsUID1 = friendsUID;
                                    });
                                    DatabaseReference listPush =
                                        FirebaseDatabase.instance
                                            .ref()
                                            .child("friends/$uid");
                                    listPush.update({
                                      friendsUID1.toString(): "pending",
                                    });
                                    listPush = FirebaseDatabase.instance
                                        .ref()
                                        .child("friends/$friendsUID1");
                                    listPush
                                        .update({uid.toString(): "requested"});
                                  });
                                  const snackBar = SnackBar(
                                    content: Text('Request sent'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  requestController.clear();
                                },
                                icon: const Icon(Icons.send),
                                color: Colors.lightBlueAccent,
                              ),
                              border: const OutlineInputBorder(),
                              labelText: "Enter a friend's email!"),
                        ),
                      ),
                      const SizedBox(height: 100),
                      Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                          child: ElevatedButton(
                              child: const Text('Outgoing Requests'),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PendingPage()));
                              })),
                      const SizedBox(height: 100),
                      Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                          child: ElevatedButton(
                              child: const Text('Incoming Requests'),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const IncomingPage()));
                              })),
                      const SizedBox(height: 100),
                      Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                          child: ElevatedButton(
                              child: const Text('Friends List'),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const FriendsList()));
                              }))
                    ])),
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
                    ListTile(
                        leading: const Icon(Icons.map),
                        title: const Text(' Map '),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MapPage()));
                        }),
                    Ink(
                        child: ListTile(
                            leading:
                                const Icon(Icons.account_circle, color: Colors.grey),
                            title: const Text(' My Profile '),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ProfileScreen()));
                            })),
                    Ink(
                        child: const ListTile(
                      leading: Icon(Icons.people),
                      title: Text(' Friends ', style: TextStyle(color: Colors.grey)),
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
                    SizedBox(height: MediaQuery.of(context).size.height - 480),
                    Ink(
                        child: ListTile(
                            leading: const Icon(Icons.arrow_back),
                            title: const Text(' Back '),
                            onTap: () {
                              Navigator.pop(context);
                            }))
                  ],
                )),
              );
            },
          )
        ]),
      ),
    );
  }

  // Widget listProfile(IconData icon, String text1, String text2) {
  //   return Container(
  //     width: double.infinity,
  //     margin: const EdgeInsets.only(top: 20),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Icon(
  //           icon,
  //           size: 20,
  //         ),
  //         const SizedBox(
  //           width: 10,
  //         ),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               text1,
  //               style: const TextStyle(
  //                 color: Colors.black87,
  //                 fontFamily: "Montserrat",
  //                 fontSize: 14,
  //               ),
  //             ),
  //             Text(
  //               text2,
  //               style: const TextStyle(
  //                 color: Colors.black87,
  //                 fontFamily: "Montserrat",
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 16,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
