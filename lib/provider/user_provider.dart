import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:ig_clone_app4/models/user.dart' as model;

class UserProvider with ChangeNotifier {
  model.User? _user;
  model.User? _otherUser;
  model.User? get getUser => _user;

  Future<void> refreshUser() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    _user = model.User.fromSnap(snap);
    notifyListeners();
  }

  model.User? get getOtherUser => _otherUser;

  Future<void> refreshOtherUser({required String uid}) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    _otherUser = model.User.fromSnap(snap);
    notifyListeners();
  }
}
