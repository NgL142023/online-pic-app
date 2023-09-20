import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ig_clone_app4/main.dart';
import 'package:ig_clone_app4/resources/auth.dart';

import 'package:ig_clone_app4/screens/sub_screen/loading_screen.dart';
import 'package:ig_clone_app4/utils/util.dart';
import 'package:ig_clone_app4/widgets/input_field.dart';
import 'package:image_picker/image_picker.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  ScaffoldMessengerState? state = scaffoldKey.currentState;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userBioController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();
  Uint8List? _file;
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _userBioController.dispose();
    _retypePasswordController.dispose();
  }

  void selectImage() async {
    Uint8List file = await pickImage(ImageSource.gallery);
    setState(() {
      _file = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const LoginScreen();
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            }
            return _isLoading == false
                ? Scaffold(
                    body: Container(
                      padding: MediaQuery.of(context).size.width > 600
                          ? EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width / 3)
                          : null,
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 150,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Align(
                            child: SizedBox(
                              height: 70,
                              width: 100,
                              child: Stack(
                                children: [
                                  _file == null
                                      ? const CircleAvatar(
                                          radius: 45,
                                          backgroundImage: AssetImage(
                                              "assets/images/profile.png"),
                                        )
                                      : CircleAvatar(
                                          radius: 45,
                                          backgroundImage: MemoryImage(_file!),
                                        ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                      onPressed: selectImage,
                                      icon: const Icon(
                                        Icons.add_a_photo,
                                        size: 35,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextInput(
                            controller: _usernameController,
                            text: "Enter your username here",
                            maxLength: 30,
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          TextInput(
                              controller: _emailController,
                              text: "Enter your email here"),
                          const SizedBox(
                            height: 3,
                          ),
                          TextInput(
                              controller: _passwordController,
                              isPassword: true,
                              text: "Enter your password here"),
                          const SizedBox(
                            height: 3,
                          ),
                          TextInput(
                              controller: _retypePasswordController,
                              isPassword: true,
                              text: "Retype your password here"),
                          const SizedBox(
                            height: 3,
                          ),
                          TextInput(
                            controller: _userBioController,
                            text: "Enter your bio here",
                            maxLength: 80,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            child: Container(
                              height: 70,
                              width: 130,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12)),
                              child: TextButton(
                                onPressed: () async {
                                  String res = "";
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  if (_passwordController.text ==
                                      _retypePasswordController.text) {
                                    res = await Auth().userSignUp(
                                        file: _file,
                                        username: _usernameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        bio: _userBioController.text);
                                  } else {
                                    res =
                                        "password and retype password are not the same";
                                  }
                                  setState(() {
                                    _isLoading = false;
                                  });

                                  state!.showSnackBar(
                                      SnackBar(content: Text(res)));
                                },
                                child: const Text(
                                  "Sign up",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account! "),
                              InkWell(
                                onTap: () {
                                  context.go(context.namedLocation("login"));
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : const LoadingScreen();
          }),
    );
  }
}
