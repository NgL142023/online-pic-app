import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final bool isPassword;
  final int maxLength;
  const TextInput(
      {super.key,
      required this.controller,
      this.isPassword = false,
      required this.text,
      this.maxLength = 320});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: TextField(
          maxLength: maxLength,
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: text,
            contentPadding: const EdgeInsets.all(0.5),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.2),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1.2),
            ),
          ),
        ),
      ),
    );
  }
}
