import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ig_clone_app4/main.dart';
import 'package:ig_clone_app4/widgets/input_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ScaffoldMessengerState? _state = scaffoldKey.currentState;
  final TextEditingController _emailController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.black,
      padding: MediaQuery.of(context).size.width > 600
          ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 3)
          : null,
      child: Scaffold(
        //backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("Forgot password"),
          centerTitle: false,
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 100,
            ),
            const Center(
                child: Text(
                    "Enter your email and we will send you a reser password link")),
            const SizedBox(
              height: 5,
            ),
            TextInput(
                controller: _emailController, text: "Enter your email here"),
            const SizedBox(
              height: 5,
            ),
            Align(
              child: Container(
                height: 60,
                width: 140,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue),
                child: TextButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: _emailController.text.trim());
                      _state!.showSnackBar(const SnackBar(
                          content: Text(
                              "Password reset link send, check your email")));
                    } on FirebaseAuthException catch (e) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(e.message.toString()),
                            );
                          });
                    }
                  },
                  child: const Text(
                    "Reset password",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
