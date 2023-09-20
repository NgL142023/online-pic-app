import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ig_clone_app4/provider/user_provider.dart';
import 'package:ig_clone_app4/resources/firestore.dart';
import 'package:ig_clone_app4/screens/pages/profile_screen.dart';
import 'package:ig_clone_app4/widgets/input_field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as model;

class CommentCard extends StatefulWidget {
  final dynamic snap;
  const CommentCard({super.key, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final TextEditingController _notes = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _notes.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ProfileScreen(
                  uid: widget.snap["uid"],
                  isCurrentUser: FirebaseAuth.instance.currentUser!.uid ==
                      widget.snap["uid"],
                );
              }));
            },
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.snap["profileImage"]),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: widget.snap["username"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: " ${widget.snap["text"]}"),
                      ]),
                ),
                Text(
                  DateFormat.yMMMd().format(
                    widget.snap["datetime"].toDate(),
                  ),
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 12),
                ),
              ],
            ),
          ),
          FittedBox(
            fit: BoxFit.cover,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    await FireStore().likeComment(
                        like: widget.snap["likes"],
                        postId: widget.snap["postId"],
                        uid: user.uid,
                        commentId: widget.snap["commentId"]);
                  },
                  icon: Icon(
                    Icons.favorite,
                    size: 12,
                    color: widget.snap["likes"].contains(user!.uid)
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
                Text(
                  "${widget.snap["likes"].length}",
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          user.uid == widget.snap["uid"]
              ? IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            alignment: Alignment.center,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 4),
                            children: [
                              InkWell(
                                onTap: () {
                                  FireStore().deleteComment(
                                      commentId: widget.snap["commentId"],
                                      postId: widget.snap["postId"]);
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Uncomment"),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancel"),
                              )
                            ],
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    size: 10,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            title: const Center(child: Text("Report user")),
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
                                  FireStore().reportComment(
                                      postId: widget.snap["postId"],
                                      notes: _notes.text,
                                      commentId: widget.snap["commentId"]);
                                  Navigator.of(context).pop();
                                },
                                child: const Center(child: Text("Report")),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Center(child: Text("Cancel")),
                              ),
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.more_vert))
        ],
      ),
    );
  }
}
