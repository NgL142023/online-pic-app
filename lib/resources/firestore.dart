import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ig_clone_app4/models/post.dart';
import 'package:ig_clone_app4/resources/storage.dart';

import 'package:uuid/uuid.dart';

class FireStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadPost(
      {required String uid,
      required String username,
      required String profileImage,
      required String? caption,
      required Uint8List file}) async {
    String res = "something wrong happen";
    try {
      String postImage = await Storage()
          .uploadImageToStorage(childname: "posts", isPost: true, file: file);
      String postId = const Uuid().v1();
      Post post = Post(
        uid: uid,
        username: username,
        profileImage: profileImage,
        postId: postId,
        dateTime: DateTime.now(),
        postImage: postImage,
        caption: caption,
        likes: [],
      );

      await _firestore.collection("posts").doc(postId).set(post.toJson());

      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(
      {required String postId, required uid, required List like}) async {
    try {
      if (like.contains(uid)) {
        _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> reportPost(
      {required String postId, required String? notes}) async {
    try {
      String reportId = const Uuid().v1();
      DocumentSnapshot snap =
          await _firestore.collection("posts").doc(postId).get();
      //Post post = Post.fromSnap(snap);
      _firestore
          .collection("reports")
          .doc(reportId)
          .set({"postId": postId, "uid": snap["uid"], "notes": notes});
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> reportComment(
      {required String postId,
      required String commentId,
      required String? notes}) async {
    try {
      String reportId = const Uuid().v1();

      DocumentSnapshot snap = await _firestore
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .doc(commentId)
          .get();
      _firestore.collection("reports").doc(reportId).set({
        "postId": postId,
        "uid": snap["uid"],
        "commentId": snap["commentId"],
        "notes": notes
      });
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> deletePost({required String postId}) async {
    try {
      var snap = await _firestore
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .get();

      for (int i = 0; i < snap.docs.length; i++) {
        await deleteComment(
            commentId: snap.docs[i].data()["commentId"], postId: postId);
      }

      await _firestore.collection("posts").doc(postId).delete();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> userComment(
      {required String username,
      required String uid,
      required String profileImage,
      required String postId,
      required String text}) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          "postId": postId,
          "commentId": commentId,
          "uid": uid,
          "username": username,
          "profileImage": profileImage,
          "text": text,
          "datetime": DateTime.now(),
          "likes": []
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> likeComment(
      {required List like,
      required String postId,
      required String uid,
      required String commentId}) async {
    try {
      if (like.contains(uid)) {
        _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> deleteComment(
      {required String commentId, required String postId}) async {
    try {
      await _firestore
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .doc(commentId)
          .delete();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> followUser({required String followId}) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot snap =
          await _firestore.collection("users").doc(followId).get();
      Map<String, dynamic> followerInfo = snap.data() as Map<String, dynamic>;

      if (followerInfo["followers"].contains(uid)) {
        await _firestore.collection("users").doc(followId).update({
          "followers": FieldValue.arrayRemove([uid])
        });
        await _firestore.collection("users").doc(uid).update({
          "following": FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection("users").doc(followId).update({
          "followers": FieldValue.arrayUnion([uid])
        });
        await _firestore.collection("users").doc(uid).update({
          "following": FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<String> updateProfile(
      {required String? username,
      required String? bio,
      required Uint8List? file}) async {
    String res = "something wrong happen";
    try {
      if (bio == "" && username == "" && file == null) {
        return "You need to change something first";
      }

      var snap = await _firestore
          .collection("users")
          .where("username", isEqualTo: username)
          .get();
      if (snap.docs.isNotEmpty) {
        return "This usename have been taken";
      }
      if (username == "" && bio == "") {
        String photoUrl = await Storage().uploadImageToStorage(
            childname: "profile_image", isPost: false, file: file!);
        await _firestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "photoUrl": photoUrl,
        });
        return "success";
      }
      if (file == null && username == "") {
        _firestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"bio": bio});
        return "success";
      }
      if (file == null && bio == "") {
        _firestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"username": username});
        return "success";
      }
      if (file == null) {
        _firestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "username": username,
          "bio": bio,
        });
        return "success";
      }

      String photoUrl = await Storage().uploadImageToStorage(
          childname: "profile_image", isPost: false, file: file);
      await _firestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"username": username, "photoUrl": photoUrl, "bio": bio});
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
