import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final String text;
  const FollowButton({super.key, required this.function, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 35,
        width: 270,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: TextButton(onPressed: function, child: Text(text)));
  }
}
