import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:ig_clone_app4/provider/user_provider.dart';
import 'package:ig_clone_app4/resources/firestore.dart';
import 'package:ig_clone_app4/screens/sub_screen/comment_screen.dart';

import 'package:ig_clone_app4/screens/pages/profile_screen.dart';
import 'package:ig_clone_app4/screens/sub_screen/loading_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as model;
import 'input_field.dart';

class PostCard extends StatefulWidget {
  final dynamic snap;
  final bool isCurrentUser;
  const PostCard({super.key, required this.snap, required this.isCurrentUser});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isPostAnimating = false;
  final TextEditingController _notes = TextEditingController();
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    _notes.dispose();
  }

  void getData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    userProvider.refreshOtherUser(uid: widget.snap["uid"]);
  }

  @override
  Widget build(BuildContext context) {
    model.User? user;

    user = widget.isCurrentUser
        ? Provider.of<UserProvider>(context).getUser
        : Provider.of<UserProvider>(context).getOtherUser;
    if (user == null) {
      return const LoadingScreen();
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return ProfileScreen(
                          uid: widget.snap["uid"],
                          isCurrentUser:
                              FirebaseAuth.instance.currentUser!.uid ==
                                  widget.snap["uid"],
                        );
                      }),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(user.photoUrl),
                      ),
                      const SizedBox(
                        width: 0.5,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(user.username),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                widget.snap["uid"] == FirebaseAuth.instance.currentUser!.uid
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          FireStore().deletePost(
                                              postId: widget.snap["postId"]);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Delete Post"))
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.more_vert))
                    : IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  title:
                                      const Center(child: Text("Report user")),
                                  children: [
                                    TextInput(
                                      controller: _notes,
                                      text: "Write your notes here",
                                      maxLength: 10000,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        FireStore().reportPost(
                                            postId: widget.snap["postId"],
                                            notes: _notes.text);
                                        Navigator.of(context).pop();
                                      },
                                      child:
                                          const Center(child: Text("Report")),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child:
                                          const Center(child: Text("Cancel")),
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.more_vert))
              ],
            ),
          ),
          const SizedBox(height: 3),
          GestureDetector(
            onDoubleTap: () async {
              await FireStore().likePost(
                  postId: widget.snap["postId"],
                  uid: FirebaseAuth.instance.currentUser!.uid,
                  like: widget.snap["likes"]);
              setState(() {
                _isPostAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.width < 600
                    ? MediaQuery.of(context).size.height * 0.45
                    : MediaQuery.of(context).size.height * 0.65,
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Image(
                    image: NetworkImage(widget.snap["postImage"]),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              AnimatedOpacity(
                onEnd: () {
                  setState(() {
                    _isPostAnimating = false;
                  });
                },
                duration: const Duration(milliseconds: 500),
                opacity: _isPostAnimating ? 1 : 0,
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 100,
                ),
              ),
            ]),
          ),
          const SizedBox(height: 3),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: IconButton(
                  onPressed: () async {
                    await FireStore().likePost(
                        postId: widget.snap["postId"],
                        uid: FirebaseAuth.instance.currentUser!.uid,
                        like: widget.snap["likes"]);
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: widget.snap["likes"].contains(
                      FirebaseAuth.instance.currentUser!.uid,
                    )
                        ? Colors.red
                        : Colors.grey,
                  )),
            ),
            const SizedBox(
              width: 8,
            ),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentScreen(snap: widget.snap)));
                },
                icon: const Icon(
                  Icons.comment,
                  color: Colors.grey,
                )),
          ]),
          const SizedBox(height: 1),
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.snap["likes"].length} likes"),
                const SizedBox(height: 1),
                RichText(
                  text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: user.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: " ${widget.snap["caption"]}")
                      ]),
                ),
                const SizedBox(height: 1),
                Text(
                  DateFormat.yMMMd().format(widget.snap["datetime"].toDate()),
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
