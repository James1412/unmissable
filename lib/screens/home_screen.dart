import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/repos/firebase_auth.dart';
import 'package:unmissable/repos/notes_repository.dart';
import 'package:unmissable/screens/edit_screen.dart';
import 'package:unmissable/utils/hive_box_names.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/view_models/font_size_view_model.dart';
import 'package:unmissable/view_models/notes_view_model.dart';
import 'package:unmissable/widgets/app_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  String appGroupId = 'group.unmissable_app_group';
  String iOSWidgetName = 'HomeScreenWidget';

  @override
  void initState() {
    super.initState();
    FirebaseAuthentication().initAuth();
    HomeWidget.setAppGroupId(appGroupId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    List<NoteModel> notes = context.watch<NotesViewModel>().notes;
    double fontSize = context.watch<FontSizeViewModel>().fontSize;
    if (notes.isNotEmpty) {
      HomeWidget.saveWidgetData<String>('title', notes.first.title);
      HomeWidget.saveWidgetData<String>('description', notes.first.body);
      HomeWidget.updateWidget(iOSName: iOSWidgetName);
    }

    return GestureDetector(
      onTap: () async {
        if (FocusManager.instance.primaryFocus != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const SizedBox(
              height: 20,
            ),
            const AppBarWidget(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Scrollbar(
                interactive: true,
                controller: _scrollController,
                child: StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        notes = HiveNoteRepository().getNotes(context);
                      } else if (snapshot.hasData) {
                        context
                            .read<NotesViewModel>()
                            .notificationOnHelper(context);
                      }
                      return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection(notesBoxName)
                              .snapshots(),
                          builder: (context, snapshot) {
                            // If user exists and firebase data exists
                            if (snapshot.hasData &&
                                FirebaseAuth.instance.currentUser != null) {
                              List<NoteModel> streamNotes = [];
                              snapshot.data!.docs
                                  .where((element) =>
                                      element['uid'] ==
                                      FirebaseAuth.instance.currentUser!.uid)
                                  .forEach((element) {
                                NoteModel note = NoteModel.fromJson(
                                    element.data() as Map<String, dynamic>);
                                streamNotes.add(note);
                              });
                              notes = sortNotes(context, streamNotes);
                              context.watch<NotesViewModel>().notes = notes;
                            } else {
                              notes = HiveNoteRepository().getNotes(context);
                              context.watch<NotesViewModel>().notes = notes;
                            }
                            return ListView.separated(
                              controller: _scrollController,
                              itemCount: notes.length,
                              separatorBuilder: (context, index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  height: 1,
                                  color: isDarkMode(context)
                                      ? darkModeGrey
                                      : Colors.black12,
                                  width: double.maxFinite,
                                ),
                              ),
                              itemBuilder: (context, index) => Slidable(
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        if (Platform.isIOS) {
                                          HapticFeedback.lightImpact();
                                        }
                                        context
                                            .read<NotesViewModel>()
                                            .toggleUnmissable(
                                                notes[index], context);
                                      },
                                      backgroundColor: Colors.amber,
                                      icon: CupertinoIcons.bell_fill,
                                      foregroundColor: Colors.white,
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        if (Platform.isIOS) {
                                          HapticFeedback.lightImpact();
                                        }
                                        context
                                            .read<NotesViewModel>()
                                            .togglePin(notes[index], context);
                                      },
                                      backgroundColor: Colors.blue,
                                      icon: FontAwesomeIcons.thumbtack,
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        if (Platform.isIOS) {
                                          HapticFeedback.lightImpact();
                                        }
                                        NoteModel note = notes[index];
                                        context
                                            .read<NotesViewModel>()
                                            .deleteNote(note, context);
                                      },
                                      backgroundColor: Colors.red,
                                      icon: FontAwesomeIcons.trash,
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditScreen(
                                          note: notes[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: CupertinoListTile(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                        horizontal: 5,
                                      ),
                                      title: Text(
                                        notes[index].title,
                                        style: TextStyle(
                                          color: isDarkMode(context)
                                              ? Colors.white
                                              : darkModeBlack,
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      additionalInfo: notes[index].isPinned &&
                                              notes[index].isUnmissable
                                          ? Row(
                                              children: [
                                                Icon(
                                                  Icons.notifications,
                                                  color: Colors.yellow.shade700,
                                                  size: 19,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                FaIcon(
                                                  FontAwesomeIcons.thumbtack,
                                                  color: Colors.blue.shade700,
                                                  size: 15,
                                                ),
                                              ],
                                            )
                                          : notes[index].isUnmissable
                                              ? Icon(
                                                  Icons.notifications,
                                                  color: Colors.yellow.shade700,
                                                  size: 19,
                                                )
                                              : notes[index].isPinned
                                                  ? FaIcon(
                                                      FontAwesomeIcons
                                                          .thumbtack,
                                                      color:
                                                          Colors.blue.shade700,
                                                      size: 15,
                                                    )
                                                  : null,
                                      subtitle: Text(
                                        notes[index].body.replaceAll('\n', ''),
                                        style: TextStyle(
                                          color: darkModeGrey,
                                          fontSize: fontSize - 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
