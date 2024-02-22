import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unmissable/utils/themes.dart';

class SignupLoginScreen extends StatefulWidget {
  const SignupLoginScreen({super.key});

  @override
  State<SignupLoginScreen> createState() => _SignupLoginScreenState();
}

class _SignupLoginScreenState extends State<SignupLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              FontAwesomeIcons.x,
              size: 20,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sync notes \nacross devices",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Sign up or Log in to connect to other devices",
                      style: TextStyle(fontSize: 19),
                    ),
                  ],
                ),
                SizedBox(
                  width: 300,
                  child: Image.asset(
                    'assets/signup.jpeg',
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDarkMode(context) ? Colors.white : darkModeBlack,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Stack(
                    children: [
                      Positioned(
                        left: 20,
                        top: 12,
                        height: double.maxFinite,
                        child: FaIcon(FontAwesomeIcons.at),
                      ),
                      Center(
                        child: Text(
                          "Sign up with Email",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isDarkMode(context) ? Colors.white : darkModeBlack,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 20,
                        top: 12,
                        height: double.maxFinite,
                        child: FaIcon(
                          FontAwesomeIcons.at,
                          color: isDarkMode(context)
                              ? darkModeBlack
                              : Colors.white,
                        ),
                      ),
                      Center(
                        child: Text(
                          "Log in with Email",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode(context)
                                  ? darkModeBlack
                                  : Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Stack(
                    children: [
                      Positioned(
                        left: 20,
                        top: 12,
                        height: double.maxFinite,
                        child: FaIcon(
                          FontAwesomeIcons.google,
                          color: Colors.white,
                        ),
                      ),
                      Center(
                        child: Text(
                          "Continue with google",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
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
