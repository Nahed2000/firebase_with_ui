import 'package:firebase_with_ui/firebase/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notes Screen',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuthController().logeOut();
              Navigator.pushReplacementNamed(context, '/login_screen');
            },
            icon: Icon(
              Icons.login_outlined,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
