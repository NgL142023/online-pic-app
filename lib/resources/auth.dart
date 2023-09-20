import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:ig_clone_app4/models/user.dart' as model;

import 'package:ig_clone_app4/resources/storage.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> userSignUp(
      {required Uint8List? file,
      required username,
      required String email,
      required String password,
      required String? bio}) async {
    String res = "something wrong happens";
    try {
      QuerySnapshot<Map<String, dynamic>> listUsername = await _firestore
          .collection("users")
          .where("username", isEqualTo: username)
          .get();
      QuerySnapshot<Map<String, dynamic>> listEmail = await _firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .get();
      if (listUsername.docs.isNotEmpty) {
        return "Your username is already been taken";
      }
      if (listEmail.docs.isNotEmpty) {
        return "Someone have already used this email";
      }
      UserCredential cred = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (file == null) {
        ByteData byteData = await rootBundle.load("assets/images/profile.png");
        file = byteData.buffer.asUint8List();
      }
      String photoUrl = await Storage().uploadImageToStorage(
          childname: "profile_image", isPost: false, file: file);
      model.User user = model.User(
          photoUrl: photoUrl,
          uid: cred.user!.uid,
          bio: bio,
          email: email,
          followers: [],
          following: [],
          username: username);
      await _firestore
          .collection("users")
          .doc(cred.user!.uid)
          .set(user.toJson());
      res = "success";
    } on FirebaseAuthException catch (e) {
      res = e.message.toString();
    }
    return res;
  }

  Future<String> userLogin(
      {required String email, required String password}) async {
    String res = "something wrong happens";
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      res = "success";
    } on FirebaseAuthException catch (e) {
      res = e.message.toString();
    }
    return res;
  }

  Future<void> userSignOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> userChangePassword(
      {required String email,
      required String oldPassword,
      required String newPassword}) async {
    String res = "something wrong happens";
    try {
      var cred =
          EmailAuthProvider.credential(email: email, password: oldPassword);
      await _firebaseAuth.currentUser!.reauthenticateWithCredential(cred).then(
          (value) => _firebaseAuth.currentUser!.updatePassword(newPassword));
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
