import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/screens/navigation_screen.dart';
import 'package:unmissable/themes.dart';
import 'package:unmissable/view_models/notes_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NotesViewModel(),
        ),
      ],
      child: const UnmissableApp(),
    ),
  );
}

class UnmissableApp extends StatefulWidget {
  const UnmissableApp({super.key});

  @override
  State<UnmissableApp> createState() => _UnmissableAppState();
}

class _UnmissableAppState extends State<UnmissableApp> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,
      builder: FToastBuilder(),
      navigatorKey: navigatorKey,
      home: const NavigationScreen(),
    );
  }
}
