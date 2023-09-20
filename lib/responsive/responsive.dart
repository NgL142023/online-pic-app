import 'package:flutter/material.dart';
import 'package:ig_clone_app4/provider/user_provider.dart';

import 'package:ig_clone_app4/responsive/mobile_screen_layout.dart';
import 'package:ig_clone_app4/responsive/web_screen_layout.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({super.key});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  void addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) => constrains.maxWidth <= 600
          ? const MobileScreenLayout()
          : const WebScreenLayout(),
    );
  }
}
