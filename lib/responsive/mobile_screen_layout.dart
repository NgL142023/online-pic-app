import 'package:flutter/material.dart';
import 'package:ig_clone_app4/models/user.dart';
import 'package:ig_clone_app4/provider/user_provider.dart';
import 'package:ig_clone_app4/screens/sub_screen/loading_screen.dart';

import 'package:ig_clone_app4/utils/pages.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _index = 0;
  void _changeIndex(int i) {
    setState(() {
      _index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    return user != null
        ? SafeArea(
            child: Scaffold(
              body: pages[_index],
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.blue,
                iconSize: 30,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.white,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                currentIndex: _index,
                onTap: _changeIndex,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: "Search",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add_circle_outline),
                    label: "Add post",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "Profile",
                  ),
                ],
              ),
            ),
          )
        : const LoadingScreen();
  }
}
