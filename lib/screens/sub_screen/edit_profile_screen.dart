import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ig_clone_app4/main.dart';
import 'package:ig_clone_app4/resources/firestore.dart';
import 'package:ig_clone_app4/screens/sub_screen/loading_screen.dart';
import 'package:ig_clone_app4/utils/util.dart';
import 'package:ig_clone_app4/widgets/input_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../provider/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ScaffoldMessengerState? _state = scaffoldKey.currentState;
  final TextEditingController _userBio = TextEditingController();
  final TextEditingController _username = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _userBio.dispose();
    _username.dispose();
  }

  Uint8List? _file;
  void _selectImage() async {
    Uint8List? file = await pickImage(ImageSource.gallery);
    setState(() {
      _file = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    return _isLoading == false
        ? Container(
            //color: Colors.black,
            padding: MediaQuery.of(context).size.width > 600
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 4)
                : null,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Edit profile"),
                centerTitle: false,
              ),
              body: ListView(
                children: [
                  Center(
                    child: SizedBox(
                      height: 70,
                      width: 100,
                      child: Stack(
                        children: [
                          _file != null
                              ? CircleAvatar(
                                  radius: 45,
                                  backgroundImage: MemoryImage(_file!),
                                )
                              : CircleAvatar(
                                  radius: 45,
                                  backgroundImage: NetworkImage(user!.photoUrl),
                                ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              onPressed: _selectImage,
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: Colors.blue,
                                size: 35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextInput(
                    controller: _username,
                    text: "enter your new username here",
                    maxLength: 30,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextInput(
                    controller: _userBio,
                    text: "enter your new bio here",
                    maxLength: 80,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 60,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          String res = await FireStore().updateProfile(
                              username: _username.text,
                              bio: _userBio.text,
                              file: _file);

                          setState(() {
                            _isLoading = false;
                          });
                          _state!.showSnackBar(SnackBar(content: Text(res)));
                        },
                        child: const Text("Submit change")),
                  )
                ],
              ),
            ),
          )
        : const LoadingScreen();
  }
}
