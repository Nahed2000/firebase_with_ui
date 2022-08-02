import 'package:flutter/material.dart';

import '../../firebase/firebase_auth.dart';
import '../../model/firebase_response.dart';
import '../../util/helper.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text_field.dart';


class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> with Helper {
  late TextEditingController _emailController;

  @override
  void initState() {
    // TODO: implement initState
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
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
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: const Text(
          'Forget Password Screen',
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              letterSpacing: 2,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Forget Password ...!!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'please enter your email to sent a code  ',
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
            CustomButton(
                onPress: () async => await _performForget(),
                title: 'Sent a Code'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have account?"),
                TextButton(
                  onPressed: () {},
                  child: const Text('Register Now!'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performForget() async {
    if (checkData()) {
      await forgetPassword();
    }
  }

  bool checkData() {
    if (_emailController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context,
        message: 'Required Data, Please Enter your Email ', error: true);
    return false;
  }

  Future<void> forgetPassword() async {
    FBResponse fbResponse = await FirebaseAuthController().forgetPassword(
        email: _emailController.text);
    showSnackBar(
        context, message: fbResponse.message, error: !fbResponse.status);
    if (fbResponse.status){
      Navigator.pop(context);
    }
  }
}
