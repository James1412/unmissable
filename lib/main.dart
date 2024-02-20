import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unmissable/screens/home_screen.dart';
import 'package:unmissable/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(
    const UnmissableApp(),
  );
}

class UnmissableApp extends StatefulWidget {
  const UnmissableApp({super.key});

  @override
  State<UnmissableApp> createState() => _UnmissableAppState();
}

class _UnmissableAppState extends State<UnmissableApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
