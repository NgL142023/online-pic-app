import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../../widgets/post_card.dart';
import '../sub_screen/loading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).size.width > 600
          ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 4)
          : null,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Homepage"),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              }
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("You haven't post anything!"),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => PostCard(
                        snap: snapshot.data!.docs[index].data(),
                        isCurrentUser: FirebaseAuth.instance.currentUser!.uid ==
                            snapshot.data!.docs[index].data()["uid"],
                      ));
            }),
      ),
    );
  }
}
