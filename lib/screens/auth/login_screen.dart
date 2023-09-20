import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ig_clone_app4/main.dart';
import 'package:ig_clone_app4/resources/auth.dart';
import 'package:ig_clone_app4/responsive/responsive.dart';

import 'package:ig_clone_app4/screens/sub_screen/forgot_password_screen.dart';
import 'package:ig_clone_app4/screens/sub_screen/loading_screen.dart';
import 'package:ig_clone_app4/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ScaffoldMessengerState? _state = scaffoldKey.currentState;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const ResponsiveLayout();
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
                          height: 250,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextInput(
                            controller: _emailController,
                            text: "Enter your email here"),
                        const SizedBox(
                          height: 5,
                        ),
                        TextInput(
                            controller: _passwordController,
                            isPassword: true,
                            text: "Enter your password here"),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return const ForgotPasswordScreen();
                                }));
                              },
                              child: const Text("Forgot password")),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          child: Container(
                            height: 70,
                            width: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.blue),
                            child: TextButton(
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                String res = await Auth().userLogin(
                                    email: _emailController.text,
                                    password: _passwordController.text);

                                setState(() {
                                  _isLoading = false;
                                });

                                _state!
                                    .showSnackBar(SnackBar(content: Text(res)));
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            InkWell(
                              onTap: () {
                                context.go(context.namedLocation("sign_up"));
                              },
                              child: const Text(
                                "Sign up",
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
        },
      ),
    );
  }
}
