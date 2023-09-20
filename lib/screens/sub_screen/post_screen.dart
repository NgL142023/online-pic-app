import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ig_clone_app4/screens/sub_screen/loading_screen.dart';
import 'package:ig_clone_app4/widgets/post_card.dart';

class PostScreen extends StatelessWidget {
  final dynamic snap;
  const PostScreen({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(snap["postId"])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          return Container(
            // decoration: const BoxDecoration(color: Colors.black),
            padding: MediaQuery.of(context).size.width > 600
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 4)
                : null,
            child: Scaffold(
              //backgroundColor: Colors.black,
              appBar: AppBar(
                title: const Text("Posts"),
                centerTitle: false,
              ),
              body: ListView(children: [
                PostCard(
                  snap: snapshot.data!.data(),
                  isCurrentUser: FirebaseAuth.instance.currentUser!.uid ==
                      snapshot.data!.data()!["uid"],
                ),
              ]),
            ),
          );
        });
  }
}
