import 'dart:async';

import 'package:firebase_with_ui/firebase/firebase_auth.dart';
import 'package:flutter/material.dart';

class LunchScreen extends StatefulWidget {
  const LunchScreen({Key? key}) : super(key: key);

  @override
  State<LunchScreen> createState() => _LunchScreenState();
}

class _LunchScreenState extends State<LunchScreen> {
  late StreamSubscription streamSubscription;

  @override
  void initState() {
    ;

    // TODO: implement initState
    Future.delayed(const Duration(seconds: 2), () {
      return streamSubscription =
          FirebaseAuthController().checkUserState(({required bool loggedIn}) {
        String rout = loggedIn ? '/home_screen' : 'login_screen';
        Navigator.pushReplacementNamed(context, rout);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepOrange.shade600,
                  Colors.deepOrange.shade200,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Text(
              'Welcome ot firebase app',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )),
      ),
    );
  }
}
