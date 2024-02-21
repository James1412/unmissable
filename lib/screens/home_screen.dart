import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/screens/edit_screen.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/utils/toasts.dart';
import 'package:unmissable/view_models/dark_mode_view_model.dart';
import 'package:unmissable/view_models/font_size_view_model.dart';
import 'package:unmissable/view_models/notes_view_model.dart';
import 'package:unmissable/widgets/appbar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  late FToast fToast;
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<NoteModel> notes = context.watch<NotesViewModel>().notes;
    double fontSize = context.watch<FontSizeViewModel>().fontSize;
    return GestureDetector(
      onTap: () {
        if (FocusManager.instance.primaryFocus != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: isDarkMode(context) ? darkModeBlack : Colors.white,
        body: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const AppBarWidget(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Scrollbar(
                interactive: true,
                controller: _scrollController,
                child: ListView.separated(
                  controller: _scrollController,
                  itemCount: notes.length,
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      height: 1,
                      color:
                          isDarkMode(context) ? darkModeGrey : Colors.black12,
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
                                .togglePin(notes[index], context);
                            pinToast(fToast: fToast, note: notes[index]);
                          },
                          backgroundColor: Colors.blue,
                          icon: FontAwesomeIcons.thumbtack,
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            context
                                .read<NotesViewModel>()
                                .deleteNote(notes[index].uniqueKey, context);
                            deleteToast(fToast: fToast, note: notes[index]);
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            ),
                          ),
                          additionalInfo: notes[index].isPinned
                              ? FaIcon(
                                  FontAwesomeIcons.thumbtack,
                                  color: Colors.blue.shade700,
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
