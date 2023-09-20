import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String username;
  final String uid;
  final String? bio;
  final List followers;
  final List following;
  final String photoUrl;
  const User(
      {required this.uid,
      required this.bio,
      required this.email,
      required this.followers,
      required this.following,
      required this.username,
      required this.photoUrl});

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "uid": uid,
        "followers": followers,
        "following": following,
        "bio": bio,
        "photoUrl": photoUrl
      };

  static User fromSnap(DocumentSnapshot snap) {
    Map<String, dynamic> userData = snap.data() as Map<String, dynamic>;
    return User(
        uid: userData["uid"],
        bio: userData["bio"],
        email: userData["email"],
        followers: userData["followers"],
        following: userData["following"],
        username: userData["username"],
        photoUrl: userData["photoUrl"]);
  }
}
