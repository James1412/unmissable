import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/screens/navigation_screen.dart';
import 'package:unmissable/services/notification_service.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/view_models/dark_mode_view_model.dart';
import 'package:unmissable/view_models/font_size_view_model.dart';
import 'package:unmissable/view_models/notes_view_model.dart';
import 'package:unmissable/view_models/notification_interval_vm.dart';
import 'package:unmissable/view_models/sort_notes_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await NotificationService().initNotification();
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
        ChangeNotifierProvider(
          create: (context) => SortNotesViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationIntervalViewModel(),
        ),
      ],
      child: const BetterFeedback(child: UnmissableApp()),
    ),
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
    ThemeMode themeMode = context.watch<DarkModeViewModel>().darkMode;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: themeMode,
      home: const NavigationScreen(),
    );
  }
}
