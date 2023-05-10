import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'chat.dart';
import 'package:http/http.dart' as http;
import 'package:psychtrack/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temporary title',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

Future<String?> getUsernames() async {
  final usersCollection = FirebaseFirestore.instance.collection('users');
  final usersSnapshot = await usersCollection.get();
  final currentUser = FirebaseAuth.instance.currentUser;
  final email = currentUser?.email;

  String? usernames;
  for (final userDoc in usersSnapshot.docs) {
    if (userDoc.exists) {
      final username = userDoc.data()['username'] as String?;
      final mail = userDoc.data()['email'] as String?;
      if (username != null && mail == email) {
        usernames = username;
        break;
      }
    }
  }
  return usernames;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color BiscuitGrey = Color.fromRGBO(47, 47, 47, 1.0);
  Color BiscuitOrange = const Color.fromRGBO(240, 174, 131, 1.0);
  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning,';
    } else if (hour < 16) {
      return 'Good afternoon,';
    } else {
      return 'Good evening,';
    }
  }

  bool _isServerOnline = true;
  Future<void> _checkServerStatus() async {
    try {
      final response =
          await http.get(Uri.parse('https://react.biscuitbobby.me/active'));
      if (response.statusCode == 200) {
        setState(() {
          _isServerOnline = true;
        });
      } else {
        setState(() {
          _isServerOnline = false;
        });
      }
    } catch (e) {
      print('error getting status');
    }
  }

  @override
  String username = "";
  void getTextFromFile() async {
    try {
      String? data = await getUsernames();
      setState(() {
        username = data!;
      });
    } catch (ex) {
      print(ex);
    }
  }

  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final List<DateTime> dates = [
      now.subtract(Duration(days: 1)),
      now,
      now.add(Duration(days: 1)),
      now.add(Duration(days: 2)),
    ];
    getTextFromFile();
    _checkServerStatus();

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: BiscuitGrey,
        child: ListView(children: [
          Stack(
            children: [
              Positioned(
                  top: 0,
                  child: Image.asset('assets/character.png',
                      width: MediaQuery.of(context).size.width)),
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    margin: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: BiscuitGrey,
                    ),
                    child: Column(
                      children: [
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0)),
                        Row(
                          children: [
                            const Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 12.0)),
                            CircleAvatar(
                              radius: MediaQuery.of(context).size.width / 10,
                              backgroundImage: const AssetImage(
                                'assets/logo.png',
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    _getGreeting(),
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    username,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 65)),
                            Container(
                              height: 35,
                              width: MediaQuery.of(context).size.width / 4,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: Text(
                                TimeOfDay.now().format(context),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              height: 35,
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  color: Colors.white),
                              child: Text(
                                _isServerOnline
                                    ? 'Server status: Online'
                                    : 'Server status: Offline',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: dates.map((date) {
                                        final bool isToday =
                                            date.day == now.day;
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 7, vertical: 6),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: isToday
                                                    ? (MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            100) *
                                                        20.5
                                                    : (MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            100) *
                                                        16.5,
                                                decoration: BoxDecoration(
                                                  color: isToday
                                                      ? BiscuitOrange
                                                      : null,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                height: 85,
                                                child: Column(
                                                  children: [
                                                    const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 6)),
                                                    Text(
                                                      DateFormat('EEEE')
                                                              .format(date)[0] +
                                                          DateFormat('EEEE')
                                                              .format(date)[1] +
                                                          DateFormat('EEEE')
                                                              .format(date)[2],
                                                      style: TextStyle(
                                                        fontSize: 21.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: isToday
                                                            ? Colors.white
                                                            : null,
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 2),
                                                    ),
                                                    Text(
                                                      DateFormat('d')
                                                          .format(date),
                                                      style: TextStyle(
                                                        fontSize: 32.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: isToday
                                                            ? Colors.white
                                                            : null,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 3 + 15,
                left: MediaQuery.of(context).size.width / 2 + 30,
                right: 0,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the new screen/widget on button click
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Chat()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      minimumSize: const Size(80, 80),
                      backgroundColor: BiscuitGrey),
                  child: Image.asset('assets/message.png', scale: 10),
                ),
              ),
              Positioned(
                  //top: 10,
                  bottom: MediaQuery.of(context).size.height / 9,
                  right: 50,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          TextButton(
                            onPressed: () => FirebaseAuth.instance.signOut(),
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      IconButton(
                          icon: const Icon(
                            Icons.exit_to_app,
                            size: 40,
                          ),
                          color: Colors.white,
                          onPressed: () => FirebaseAuth.instance.signOut()),
                    ],
                  ))
            ],
          ),
        ]),
      ),
    );
  }
}


// class NavigationDrawer extends StatelessWidget {
//   const NavigationDrawer({super.key});

