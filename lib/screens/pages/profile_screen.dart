import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ig_clone_app4/provider/user_provider.dart';
import 'package:ig_clone_app4/resources/auth.dart';
import 'package:ig_clone_app4/resources/firestore.dart';
import 'package:ig_clone_app4/screens/sub_screen/change_password_screen.dart';
import 'package:ig_clone_app4/screens/sub_screen/edit_profile_screen.dart';

import 'package:ig_clone_app4/screens/sub_screen/loading_screen.dart';
import 'package:ig_clone_app4/screens/sub_screen/post_screen.dart';
import 'package:ig_clone_app4/widgets/follow_button.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart' as model;

class ProfileScreen extends StatefulWidget {
  final String uid;
  final bool isCurrentUser;
  const ProfileScreen(
      {super.key, required this.uid, this.isCurrentUser = true});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Column _userInfo({required int num, required String text}) {
    return Column(
      children: [
        Text(num.toString()),
        const SizedBox(
          height: 3,
        ),
        Text(text)
      ],
    );
  }

  Future<void> refreshData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshOtherUser(uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    model.User? user;
    user = widget.isCurrentUser
        ? Provider.of<UserProvider>(context).getUser
        : Provider.of<UserProvider>(context).getOtherUser;
    if (user != null) {
      return Container(
        //color: Colors.black,
        padding: MediaQuery.of(context).size.width > 600
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 4)
            : null,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("uid", isEqualTo: user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              }
              return Scaffold(
                //backgroundColor: Colors.black,
                appBar: AppBar(
                  title: const Text("User Profile"),
                  centerTitle: false,
                ),
                body: ListView(children: [
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 130,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    snapshot.data!.docs.first["photoUrl"]),
                              ),
                              RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                      style:
                                          const TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                            text: snapshot
                                                .data!.docs.first["username"]),
                                      ])),
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: snapshot.data!.docs.first["bio"],
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _userInfo(
                                num: snapshot
                                    .data!.docs.first["followers"].length,
                                text: "Followers"),
                            const SizedBox(
                              width: 25,
                            ),
                            _userInfo(
                                num: snapshot
                                    .data!.docs.first["following"].length,
                                text: "Following"),
                            /*SizedBox(
                                  width: snapshot.data!.docs.first["uid"] ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? 25
                                      : 0,
                                ),*/
                          ],
                        ),
                        snapshot.data!.docs.first["uid"] ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SimpleDialog(
                                          alignment: Alignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Auth().userSignOut();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Sign out"),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                    return const ChangePasswordScreen();
                                                  }),
                                                );
                                              },
                                              child:
                                                  const Text("Change password"),
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
                                icon: const Icon(Icons.more_vert))
                            : Container()
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: widget.isCurrentUser
                        ? FollowButton(
                            function: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const EditProfileScreen();
                              }));
                            },
                            text: "Edit profile")
                        : snapshot.data!.docs.first["followers"].contains(
                                FirebaseAuth.instance.currentUser!.uid)
                            ? FollowButton(
                                function: () async {
                                  await FireStore()
                                      .followUser(followId: widget.uid);
                                  await refreshData();
                                  setState(() {});
                                },
                                text: "Unfollow")
                            : FollowButton(
                                function: () async {
                                  await FireStore()
                                      .followUser(followId: widget.uid);
                                  await refreshData();
                                  setState(() {});
                                },
                                text: "Follow"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .where("uid",
                            isEqualTo: snapshot.data!.docs.first["uid"])
                        .snapshots(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingScreen();
                      }
                      return SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: GridView.builder(
                          itemCount: snapshot.data!.docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4),
                          itemBuilder: ((context, index) => InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return PostScreen(
                                        snap:
                                            snapshot.data!.docs[index].data());
                                  }));
                                },
                                child: Image.network(
                                  snapshot.data!.docs[index]
                                      .data()["postImage"],
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                      );
                    }),
                  ),
                ]),
              );
            }),
      );
    } else {
      return const LoadingScreen();
    }
  }
  /*@override
  Widget build(BuildContext context) {
    model.User? user;
    user = widget.isCurrentUser
        ? Provider.of<UserProvider>(context).getUser
        : Provider.of<UserProvider>(context).getOtherUser;
    if (user != null) {
      return Container(
        color: Colors.black,
        padding: MediaQuery.of(context).size.width > 600
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 4)
            : null,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text(user.username),
            centerTitle: false,
          ),
          body: ListView(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(user.photoUrl),
                      ),
                      RichText(
                          text: TextSpan(
                              style: const TextStyle(color: Colors.white),
                              children: [
                            TextSpan(text: user.username),
                          ])),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: user.bio,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ]),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _userInfo(num: user.followers.length, text: "Followers"),
                      const SizedBox(
                        width: 25,
                      ),
                      _userInfo(num: user.following.length, text: "Following"),
                      SizedBox(
                        width:
                            user.uid == FirebaseAuth.instance.currentUser!.uid
                                ? 25
                                : 0,
                      ),
                      user.uid == FirebaseAuth.instance.currentUser!.uid
                          ? IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        alignment: Alignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Auth().userSignOut();
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Sign out"),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return const ChangePasswordScreen();
                                                }),
                                              );
                                            },
                                            child:
                                                const Text("Change password"),
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
                              icon: const Icon(Icons.more_vert))
                          : Container()
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: widget.isCurrentUser
                  ? FollowButton(
                      function: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const EditProfileScreen();
                        }));
                      },
                      text: "Edit profile")
                  : user.followers
                          .contains(FirebaseAuth.instance.currentUser!.uid)
                      ? FollowButton(
                          function: () async {
                            await FireStore().followUser(followId: widget.uid);
                            await refreshData();
                            setState(() {});
                          },
                          text: "Unfollow")
                      : FollowButton(
                          function: () async {
                            await FireStore().followUser(followId: widget.uid);
                            await refreshData();
                            setState(() {});
                          },
                          text: "Follow"),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .where("uid", isEqualTo: user.uid)
                  .snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                }
                return SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4),
                    itemBuilder: ((context, index) => InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return PostScreen(
                                  snap: snapshot.data!.docs[index].data());
                            }));
                          },
                          child: Image.network(
                            snapshot.data!.docs[index].data()["postImage"],
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                );
              }),
            ),
          ]),
        ),
      );
    } else {
      return const LoadingScreen();
    }
  }*/
}
