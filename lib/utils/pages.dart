import 'package:firebase_auth/firebase_auth.dart';

import 'package:ig_clone_app4/screens/pages/home_screen.dart';
import 'package:ig_clone_app4/screens/pages/profile_screen.dart';
import 'package:ig_clone_app4/screens/pages/search_screen.dart';
import 'package:ig_clone_app4/screens/pages/upload_post_screen.dart';

List pages = [
  const HomeScreen(),
  const SearchScreen(),
  const UploadPostScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
