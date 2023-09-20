import 'package:flutter/material.dart';
import 'package:ig_clone_app4/resources/auth.dart';
import 'package:ig_clone_app4/widgets/input_field.dart';

import '../../main.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();
  final ScaffoldMessengerState? _state = scaffoldKey.currentState;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _newPasswordController.dispose();
    _oldPasswordController.dispose();
    _retypePasswordController.dispose();
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
          title: const Text("Change password"),
          centerTitle: false,
        ),
        body: Center(
          child: ListView(
            children: [
              const SizedBox(
                height: 50,
              ),
              TextInput(
                  controller: _emailController, text: "Enter your email here"),
              const SizedBox(
                height: 10,
              ),
              TextInput(
                controller: _oldPasswordController,
                text: "Enter your current password",
                isPassword: true,
              ),
              const SizedBox(
                height: 10,
              ),
              TextInput(
                controller: _newPasswordController,
                text: "Type your new password here",
                isPassword: true,
              ),
              const SizedBox(
                height: 10,
              ),
              TextInput(
                controller: _retypePasswordController,
                text: "Retype your new password here",
                isPassword: true,
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                child: Container(
                  height: 70,
                  width: 160,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue),
                  child: TextButton(
                    onPressed: () async {
                      String res = "";
                      if (_newPasswordController.text ==
                          _retypePasswordController.text) {
                        res = await Auth().userChangePassword(
                            email: _emailController.text,
                            oldPassword: _oldPasswordController.text,
                            newPassword: _newPasswordController.text);
                      } else {
                        res =
                            "new password and retype password are not the same";
                      }

                      _state!.showSnackBar(SnackBar(content: Text(res)));
                    },
                    child: const Center(
                      child: Text(
                        "Change password",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
