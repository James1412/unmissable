import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],
      bottomSheet: Container(
        color: Colors.white,
        height: 60,
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
