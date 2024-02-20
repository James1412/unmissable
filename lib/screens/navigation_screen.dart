import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unmissable/screens/home_screen.dart';
import 'package:unmissable/screens/write_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _index = 0;
  List<Widget> screens = [
    const HomeScreen(),
    const WriteScreen(),
  ];

  void changeScreen(int index) {
    if (Platform.isIOS) {
      HapticFeedback.lightImpact();
    }
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: screens[_index],
      bottomSheet: Container(
        color: Colors.white,
        height: 75,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => changeScreen(0),
                child: Center(
                  child: Opacity(
                    opacity: _index == 0 ? 1 : 0.4,
                    child: const FaIcon(
                      CupertinoIcons.home,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => changeScreen(1),
                child: Center(
                  child: Opacity(
                    opacity: _index == 1 ? 1 : 0.4,
                    child: const FaIcon(
                      CupertinoIcons.pen,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
