// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unmissable/repos/firebase_auth.dart';
import 'package:unmissable/screens/navigation_screen.dart';
import 'package:unmissable/utils/themes.dart';

enum SignUpLogin {
  signUp,
  logIn,
}

class SignUpPage extends StatefulWidget {
  const SignUpPage(
      {super.key,
      required this.buttonText,
      required this.title,
      required this.type});
  final String buttonText;
  final String title;
  final SignUpLogin type;
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> onTap() async {
    if (Platform.isIOS) {
      HapticFeedback.lightImpact();
    }
    if (widget.type == SignUpLogin.signUp) {
      showDialog(
        context: context,
        builder: (context) =>
            const Center(child: CircularProgressIndicator.adaptive()),
      );
      final auth = await FirebaseAuthentication().signUpWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
        context: context,
      );
      Navigator.pop(context);
      if (auth != null) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: const Text("Error"),
            content: Text(auth.message!),
          ),
        );
      } else {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const NavigationScreen(),
            ),
            (route) => false);
      }
    } else if (widget.type == SignUpLogin.logIn) {
      showDialog(
        context: context,
        builder: (context) =>
            const Center(child: CircularProgressIndicator.adaptive()),
      );
      final auth = await FirebaseAuthentication().signInWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pop(context);
      if (auth != null) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: const Text("Error"),
            content: Text(auth.message!),
          ),
        );
      } else {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const NavigationScreen(),
            ),
            (route) => false);
      }
    }
  }

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () {
          if (FocusManager.instance.primaryFocus != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.chevron_left,
                size: 40,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 80,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Email"),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: showPassword ? false : true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: const Text("Password"),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        if (Platform.isIOS) {
                          HapticFeedback.lightImpact();
                        }
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      child: Icon(showPassword
                          ? CupertinoIcons.eye
                          : CupertinoIcons.eye_slash),
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(
                  height: 250,
                ),
                InkWell(
                  onTap: () => onTap(),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isDarkMode(context) ? Colors.white : darkModeBlack,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                        child: Text(
                      widget.buttonText,
                      style: TextStyle(
                        fontSize: 20,
                        color:
                            isDarkMode(context) ? darkModeBlack : Colors.white,
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
