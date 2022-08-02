import 'package:firebase_with_ui/firebase/firebase_auth.dart';
import 'package:firebase_with_ui/model/firebase_response.dart';
import 'package:flutter/material.dart';

import '../../util/helper.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with Helper {
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
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Register Screen',
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              letterSpacing: 2,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.s,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome...!!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'please enter your email, password to register ,and your gender',
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
              const SizedBox(height: 20),
              CustomButton(
                  onPress: () async => await _performRegister(),
                  title: 'Register'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _performRegister() async {
    if (checkData()) {
      await register();
    }
  }

  bool checkData() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context,
        message:
        'Required Data, Please Enter your information Password, Email and full Name ',
        error: true);
    return false;
  }

  Future<void> register() async {
    FBResponse fbResponse = await FirebaseAuthController().createAccount(
        email: _emailController.text, password: _passwordController.text);
    showSnackBar(
        context, message: fbResponse.message, error: !fbResponse.status);
    if (fbResponse.status){
      Navigator.pop(context);
    }
  }

}
