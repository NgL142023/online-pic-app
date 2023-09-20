import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ig_clone_app4/main.dart';
import 'package:ig_clone_app4/models/user.dart';
import 'package:ig_clone_app4/provider/user_provider.dart';
import 'package:ig_clone_app4/resources/firestore.dart';
import 'package:ig_clone_app4/screens/sub_screen/loading_screen.dart';
import 'package:ig_clone_app4/utils/util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadPostScreen extends StatefulWidget {
  const UploadPostScreen({super.key});

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  final ScaffoldMessengerState? _state = scaffoldKey.currentState;
  final TextEditingController _caption = TextEditingController();
  Uint8List? _file;
  bool _isLoading = false;
  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    return _isLoading != true
        ? Container(
            padding: MediaQuery.of(context).size.width > 600
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 4)
                : null,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Post to"),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      String res;
                      if (_file != null) {
                        res = await FireStore().uploadPost(
                            uid: user!.uid,
                            username: user.username,
                            profileImage: user.photoUrl,
                            caption: _caption.text,
                            file: _file!);
                      } else {
                        res = "You need to upload an image first!";
                      }
                      setState(() {
                        _isLoading = false;
                      });
                      _state!.showSnackBar(SnackBar(content: Text(res)));
                      if (res == "success") {
                        setState(() {
                          _file = null;
                          _caption.text = "";
                        });
                      }
                    },
                    child: const Text(
                      "Upload Post",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _file = null;
                        _caption.text = "";
                      });
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(user!.photoUrl),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(user.username),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextField(
                        controller: _caption,
                        decoration: const InputDecoration(
                          hintText: "Enter your caption here",
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.2)),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1.2,
                            ),
                          ),
                        ),
                        maxLines: 8,
                        minLines: 1,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    _file != null
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.45,
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: MemoryImage(_file!))),
                            ),
                          )
                        : SizedBox(
                            child: Column(
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      Uint8List? file =
                                          await pickImage(ImageSource.gallery);
                                      setState(() {
                                        _file = file;
                                      });
                                    },
                                    icon: const Icon(Icons.upload)),
                                const Text("Choose your image to upload")
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          )
        : const LoadingScreen();
  }
}
