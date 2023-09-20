import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ig_clone_app4/screens/sub_screen/loading_screen.dart';
import 'package:ig_clone_app4/screens/pages/profile_screen.dart';
import 'package:ig_clone_app4/screens/sub_screen/post_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;
  bool _isShowUser = false;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).size.width > 600
          ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 4)
          : null,
      child: Scaffold(
          appBar: AppBar(
            leading: _isShowUser
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        _isShowUser = false;
                        _controller.text = "";
                      });
                    },
                    icon: const Icon(Icons.arrow_back))
                : const Icon(Icons.search),
            title: TextFormField(
              onTap: () {
                setState(() {
                  _isSearching = true;
                });
              },
              onFieldSubmitted: (value) {
                setState(() {
                  _isShowUser = true;
                });
              },
              controller: _controller,
              decoration: const InputDecoration(
                  labelText: "Search for users",
                  labelStyle: TextStyle(color: Colors.white)),
            ),
          ),
          body: _bodyPage(context, _isSearching, _isShowUser, _controller)),
    );
  }
}

Widget _bodyPage(BuildContext context, bool isSearch, bool isShowUser,
    TextEditingController controller) {
  if (isShowUser == true) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .where("username", isGreaterThanOrEqualTo: controller.text)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return ProfileScreen(
                      uid: snapshot.data!.docs[index].data()["uid"],
                      isCurrentUser: FirebaseAuth.instance.currentUser!.uid ==
                          snapshot.data!.docs[index].data()["uid"],
                    );
                  }),
                );
              },
              leading: CircleAvatar(
                radius: 15,
                backgroundImage:
                    NetworkImage(snapshot.data!.docs[index].data()["photoUrl"]),
              ),
              title: Text(snapshot.data!.docs[index].data()["username"]),
            ),
          );
        });
  }
  if (isSearch == true && isShowUser == false) {
    return Container();
  } else {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("posts")
          .orderBy("datetime", descending: true)
          .snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }
        return GridView.builder(
          itemCount: snapshot.data!.docs.length,
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            pattern: const [
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
            ],
          ),
          itemBuilder: ((context, index) => InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return PostScreen(snap: snapshot.data!.docs[index].data());
                  }));
                },
                child: Image.network(
                  snapshot.data!.docs[index].data()["postImage"],
                  fit: BoxFit.cover,
                ),
              )),
        );
      }),
    );
  }
}
