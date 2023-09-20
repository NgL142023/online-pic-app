import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String username;
  final String profileImage;
  final String postId;
  final DateTime dateTime;
  final String postImage;
  final String? caption;
  final List likes;

  const Post({
    required this.uid,
    required this.username,
    required this.profileImage,
    required this.postId,
    required this.dateTime,
    required this.postImage,
    required this.caption,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "profileImage": profileImage,
        "postId": postId,
        "datetime": dateTime,
        "postImage": postImage,
        "caption": caption,
        "likes": likes,
      };
  static fromSnap(DocumentSnapshot snap) {
    Map<String, dynamic> postData = snap.data() as Map<String, dynamic>;
    return Post(
      uid: postData["uid"],
      username: postData["username"],
      profileImage: postData["profileImage"],
      postId: postData["postId"],
      dateTime: postData["datetime"],
      postImage: postData["postImage"],
      caption: postData["caption"],
      likes: postData["likes"],
    );
  }
}
