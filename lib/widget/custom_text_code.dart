
import 'package:flutter/material.dart';

class CustomTextCode extends StatelessWidget {
  const CustomTextCode({
    Key? key,
    required this.controller,
    required this.node,
    required this.onChanged,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode node;
  final void Function(String value)onChanged;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        focusNode: node,
        keyboardType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey),
          ),
          counterText: '',
        ),
        cursorColor: Colors.grey,
      ),
    );
  }
}