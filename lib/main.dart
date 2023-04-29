import 'package:flutter/material.dart';
import 'chat.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Color BiscuitGrey = Color.fromRGBO(47, 47, 47, 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.orangeAccent,
          child: ListView(
              children: [
                Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height/2.5,
                          color: Colors.orangeAccent,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height/1.5,
                          margin: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: BiscuitGrey,
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                margin: EdgeInsets.all(50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.indigoAccent, width: 2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height/3+10,
                      left: MediaQuery.of(context).size.width/2+30,
                      right: 0,
                      child: ElevatedButton(
                          onPressed: () {
                            // Navigate to the new screen/widget on button click
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Chat()),
                            );
                          },
                          child: Text('Button'),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            minimumSize: Size(100,100),
                            primary: BiscuitGrey
                          ),
                      ),
                    ),
                  ],
                ),
              ]
          ),
        ),
    );
  }
}

