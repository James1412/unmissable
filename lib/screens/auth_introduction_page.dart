import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unmissable/screens/signup_login_page.dart';
import 'package:unmissable/utils/themes.dart';

class SignupLoginScreen extends StatefulWidget {
  const SignupLoginScreen({super.key});

  @override
  State<SignupLoginScreen> createState() => _SignupLoginScreenState();
}

class _SignupLoginScreenState extends State<SignupLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
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
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sync notes \nacross devices",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Sign up or Log in to connect to other devices",
                        style: TextStyle(fontSize: 15),
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
                    height: 80,
                  ),
                  authButton(
                    context: context,
                    containerColor: null,
                    border: Border.all(
                      color: isDarkMode(context) ? Colors.white : darkModeBlack,
                    ),
                    icon: FontAwesomeIcons.at,
                    textIconColor: null,
                    text: "Sign up with Email",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(
                              buttonText: "Create",
                              title: "Sign up",
                              type: SignUpLogin.signUp,
                            ),
                          ));
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  authButton(
                    context: context,
                    containerColor:
                        isDarkMode(context) ? Colors.white : darkModeBlack,
                    border: null,
                    icon: FontAwesomeIcons.at,
                    textIconColor:
                        isDarkMode(context) ? darkModeBlack : Colors.white,
                    text: "Log in with Email",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(
                              buttonText: "Log in",
                              title: "Log in",
                              type: SignUpLogin.logIn,
                            ),
                          ));
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget authButton({
  required BuildContext context,
  Color? containerColor,
  Border? border,
  required IconData icon,
  Color? textIconColor,
  required String text,
  required Function onTap,
}) {
  return InkWell(
    onTap: () => onTap(),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: 50,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(5),
        border: border,
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10,
            top: 12,
            child: FaIcon(
              icon,
              color: textIconColor,
            ),
          ),
          Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: textIconColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
