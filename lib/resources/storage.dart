import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class Storage {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(
      {required String childname,
      required bool isPost,
      required Uint8List file}) async {
    Reference ref = _firebaseStorage
        .ref()
        .child(childname)
        .child(FirebaseAuth.instance.currentUser!.uid);
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }
    TaskSnapshot snapshot =
        await ref.putData(file, SettableMetadata(contentType: "image/png"));
    return snapshot.ref.getDownloadURL();
  }
}
