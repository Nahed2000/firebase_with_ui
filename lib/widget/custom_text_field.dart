import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
   CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
     this.obSecured = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
   bool obSecured;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        prefixIcon: Icon(widget.prefixIcon),
        suffixIcon: Visibility(
          visible: widget.hintText=='Password',
          child: IconButton(
            icon: Icon(widget.obSecured?Icons.visibility_off:Icons.visibility),
            onPressed: (){
              print(widget.obSecured);
              setState(() {
                widget.obSecured = !widget.obSecured;
              });
            },

          ),
        )
      ),
      obscureText: widget.obSecured,
    );
  }
}
