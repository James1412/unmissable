import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/screens/home_screen.dart';
import 'package:unmissable/themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: const [],
      child: const UnmissableApp(),
    ),
  );
}

class UnmissableApp extends StatelessWidget {
  const UnmissableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      home: const HomeScreen(),
    );
  }
}
