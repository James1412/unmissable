import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/screens/navigation_screen.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/view_models/dark_mode_view_model.dart';
import 'package:unmissable/view_models/font_size_view_model.dart';
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
        ChangeNotifierProvider(
          create: (context) => DarkModeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => FontSizeViewModel(),
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
    ThemeMode themeMode = context.watch<DarkModeViewModel>().darkMode;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: themeMode,
      builder: FToastBuilder(),
      navigatorKey: navigatorKey,
      home: const NavigationScreen(),
    );
  }
}
