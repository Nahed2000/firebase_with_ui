import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const  CustomButton({
    Key? key,
    required this.title,
    required this.onPress,

  }) : super(key: key);

  final void Function() onPress;
  final String title;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:onPress ,
      style: ElevatedButton.styleFrom(
        primary: Colors.lightBlue.shade400,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
      ),
      child:  Text(
        title,
        style:const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }
}