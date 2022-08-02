import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_with_ui/screen/auth/login_screen.dart';
import 'package:firebase_with_ui/screen/home_screen.dart';
import 'package:firebase_with_ui/screen/lunch_screen.dart';
import 'package:flutter/material.dart';

import 'screen/auth/forget_password.dart';
import 'screen/auth/register_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/lunch_screen',
      routes: {
        '/lunch_screen':(context) =>const LunchScreen(),
        '/home_screen':(context) =>const HomeScreen(),
        '/login_screen':(context) =>const LoginScreen(),
        '/register_screen':(context) =>const RegisterScreen(),
        '/forget_password':(context) =>const ForgetPassword(),
        // '/image_screen':(context) =>const ImageScreen(),
        // '/upload_image':(context) =>const UploadImage(),
      },
    );
  }
}
