import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import '../screens/sub_screen/loading_screen.dart';
import '../utils/pages.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
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
              appBar: AppBar(
                actions: [
                  IconButton(
                      onPressed: () {
                        _changeIndex(0);
                      },
                      icon: Icon(
                        Icons.home,
                        color: _index == 0 ? Colors.black : Colors.white,
                      )),
                  IconButton(
                      onPressed: () {
                        _changeIndex(1);
                      },
                      icon: Icon(
                        Icons.search,
                        color: _index == 1 ? Colors.black : Colors.white,
                      )),
                  IconButton(
                      onPressed: () {
                        _changeIndex(2);
                      },
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: _index == 2 ? Colors.black : Colors.white,
                      )),
                  IconButton(
                      onPressed: () {
                        _changeIndex(3);
                      },
                      icon: Icon(
                        Icons.person,
                        color: _index == 3 ? Colors.black : Colors.white,
                      )),
                ],
              ),
              body: pages[_index],
            ),
          )
        : const LoadingScreen();
  }
}
