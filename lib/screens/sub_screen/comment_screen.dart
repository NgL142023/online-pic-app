import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ig_clone_app4/provider/user_provider.dart';
import 'package:ig_clone_app4/resources/firestore.dart';
import 'package:ig_clone_app4/widgets/comment_card.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';

class CommentScreen extends StatefulWidget {
  final dynamic snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      //color: Colors.black,
      padding: MediaQuery.of(context).size.width > 600
          ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 4)
          : null,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text("Comment"),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("posts")
              .doc(widget.snap["postId"])
              .collection("comments")
              .orderBy("datetime", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) =>
                  CommentCard(snap: snapshot.data!.docs[index].data()),
            );
          },
        ),
        bottomNavigationBar: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user!.photoUrl),
                radius: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                      hintText: "comment as ${user.username}"),
                ),
              ),
              const SizedBox(
                width: 3,
              ),
              IconButton(
                  onPressed: () async {
                    await FireStore().userComment(
                        username: user.username,
                        uid: user.uid,
                        profileImage: user.photoUrl,
                        postId: widget.snap["postId"],
                        text: _controller.text);
                    setState(() {
                      _controller.text = "";
                    });
                  },
                  icon: const Icon(Icons.send))
            ],
          ),
        ),
      ),
    );
  }
}
