import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_with_ui/firebase/firebase_auth.dart';
import 'package:firebase_with_ui/model/firebase_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/helper.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Helper {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    // TODO: implement initState
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Login Screen',
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              letterSpacing: 2,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.s,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome Back ...!!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'please enter your email and password to login ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                letterSpacing: 1,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 40),
            CustomTextField(
              controller: _emailController,
              hintText: 'Email',
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _passwordController,
              hintText: 'Password',
              prefixIcon: Icons.lock,
              obSecured: true,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/forget_password'),
                child: const Text(
                  'Forget Password',
                  style: TextStyle(color: CupertinoColors.activeBlue),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
                onPress: () async => await _performLogin(), title: 'Login'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have account?"),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/register_screen'),
                  child: const Text('Register Now!'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performLogin() async {
    if (checkData()) {
      await login();
    }
  }

  bool checkData() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context,
        message:
            'Required Data, Please Enter your information Password and Email ',
        error: true);
    return false;
  }

  Future<void> login() async {
    FBResponse fbResponse = await FirebaseAuthController().signIn(
        password: _passwordController.text, email: _emailController.text);
    showSnackBar(context, message: fbResponse.message, error: !fbResponse.status);
    if(fbResponse.status){
      Navigator.pushReplacementNamed(context, '/notes_screen');
    }
  }
}
