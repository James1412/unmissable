import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/models/note_model.dart';
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

  void showToast(
      {required String message, required IconData icon, required Color color}) {
    fToast.showToast(
      toastDuration: const Duration(seconds: 1),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: color,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(
              width: 12.0,
            ),
            Text(message),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<NoteModel> notes = context.watch<NotesViewModel>().notes;
    return GestureDetector(
      onTap: () {
        if (FocusManager.instance.primaryFocus != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
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
                  separatorBuilder: (context, index) => Opacity(
                    opacity: 0.15,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: 1,
                        color: Colors.black,
                        width: double.maxFinite,
                      ),
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
                                .togglePin(notes[index]);
                            showToast(
                                message: notes[index].isPinned
                                    ? "Pinned"
                                    : "Unpinned",
                                icon: Icons.check,
                                color: Colors.greenAccent);
                          },
                          backgroundColor: Colors.blue,
                          icon: FontAwesomeIcons.thumbtack,
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            context
                                .read<NotesViewModel>()
                                .deleteNote(notes[index].uniqueKey);
                            showToast(
                                message: "Deleted",
                                icon: Icons.delete,
                                color: Colors.redAccent);
                          },
                          backgroundColor: Colors.red,
                          icon: FontAwesomeIcons.trash,
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: CupertinoListTile(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 5,
                          ),
                          title: Text(
                            notes[index].title,
                          ),
                          additionalInfo: notes[index].isPinned
                              ? FaIcon(
                                  FontAwesomeIcons.thumbtack,
                                  color: Colors.blue.shade700,
                                  size: 15,
                                )
                              : null,
                          subtitle: Text(notes[index].body),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
