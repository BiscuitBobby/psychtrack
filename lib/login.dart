import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:psychtrack/main.dart';
import 'package:psychtrack/regis.dart';
import 'package:psychtrack/signup.dart';
import 'package:basic_utils/basic_utils.dart';

class Mylogin extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const Mylogin({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<Mylogin> createState() => _MyloginState();
}

class _MyloginState extends State<Mylogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Color BiscuitOrange = const Color.fromRGBO(240, 174, 131, 1.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: biscuitGrey,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 165),
            child: const Text(
              'Welcome, back!',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: const Text(
              'Please Log In',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, top: 10, right: 20),
            child: Column(children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: 'Username',
                    fillColor: const Color.fromARGB(-1, 241, 226, 204),
                    filled: true,
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: 'Password',
                    fillColor: const Color.fromARGB(-1, 241, 226, 204),
                    filled: true,
                    prefixIcon: Icon(Icons.key),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40))),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: signIn,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: BiscuitOrange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      fixedSize: const Size(280, 60)),
                  child: Text(
                    'Log in',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  )),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                color: Colors.orangeAccent,
                endIndent: 5,
              ),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Click here to register',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () => widget.onClickedSignUp(),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Text(
                      'create an account',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: const Color.fromRGBO(240, 174, 131, 1.0),
                      ),
                    ),
                  ),
                ],
              )),
            ]),
          ),
        ]),
      ),
    );
  }

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      final snackBar = SnackBar(
        content: Text((e.message).toString()),
      );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    navigatorkey.currentState!.popUntil((route) => route.isFirst);
  }
}
