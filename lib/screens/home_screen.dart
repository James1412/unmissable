import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/screens/edit_screen.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/view_models/dark_mode_view_model.dart';
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
  final TextEditingController _textEditingController = TextEditingController();
  late List<NoteModel> searchResults = [];
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void onQueryChanged() {
    setState(() {
      searchResults = Provider.of<NotesViewModel>(context, listen: false)
          .notes
          .where((element) => (element.title + element.body)
              .toLowerCase()
              .contains(_textEditingController.text))
          .toList();
    });
  }

  void deleteSearchResult(NoteModel note) {
    searchResults.remove(note);
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    List<NoteModel> notes = context.watch<NotesViewModel>().notes;
    double fontSize = context.watch<FontSizeViewModel>().fontSize;
    if (focusNode.hasPrimaryFocus) {
      notes = searchResults;
    }
    if (_textEditingController.text.isEmpty ||
        _textEditingController.text == "") {
      notes = context.watch<NotesViewModel>().notes;
    }
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
            const SizedBox(
              height: 20,
            ),
            AppBarWidget(
              focusNode: focusNode,
              onQueryChanged: onQueryChanged,
              textEditingController: _textEditingController,
            ),
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
                                .toggleUnmissable(notes[index], context);
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
                            context
                                .read<NotesViewModel>()
                                .deleteNote(notes[index], context);
                            deleteSearchResult(notes[index]);
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
                              deleteSearch: deleteSearchResult,
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          additionalInfo:
                              notes[index].isPinned && notes[index].isUnmissable
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
