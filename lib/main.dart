import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:unmissable/firebase_options.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/screens/navigation_screen.dart';
import 'package:unmissable/services/notification_service.dart';
import 'package:unmissable/utils/enums.dart';
import 'package:unmissable/utils/hive_box_names.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/view_models/deleted_notes_vm.dart';
import 'package:unmissable/view_models/font_size_view_model.dart';
import 'package:unmissable/view_models/notes_view_model.dart';
import 'package:unmissable/view_models/notification_interval_vm.dart';
import 'package:unmissable/view_models/sort_notes_view_model.dart';

Future<void> initApp() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();
  Hive.registerAdapter(SortNotesAdapter());
  Hive.registerAdapter(NoteModelAdapter());
  await Hive.openBox(fontSizeBoxName);
  await Hive.openBox(sortNotesBoxName);
  await Hive.openBox<NoteModel>(deletedNotesBoxName);
  await Hive.openBox<NoteModel>(notesBoxName);
  await Hive.openBox(notificationIntervalBoxName);
  await Hive.openBox(firstTimeBoxName);
  await NotificationService().initNotification();
  await Purchases.configure(_configuration);
}

final _configuration =
    PurchasesConfiguration('appl_jTcHeUOlRTKwrlMMDSOFYVTajaU');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FontSizeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SortNotesViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationIntervalViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DeletedNotesViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotesViewModel(context: context),
        ),
      ],
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
      themeMode: ThemeMode.system,
      home: const NavigationScreen(),
    );
  }
}
