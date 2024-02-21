import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/utils/toasts.dart';
import 'package:unmissable/view_models/dark_mode_view_model.dart';
import 'package:unmissable/view_models/font_size_view_model.dart';
import 'package:unmissable/view_models/notes_view_model.dart';
import 'package:unmissable/widgets/cupertino_modal_sheet.dart';

class EditScreen extends StatefulWidget {
  final NoteModel note;
  const EditScreen({super.key, required this.note});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late final TextEditingController _titleController =
      TextEditingController(text: widget.note.title);
  late final TextEditingController _textEditingController =
      TextEditingController(text: widget.note.body);
  late FToast fToast;
  GlobalKey navigatorKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    if (navigatorKey.currentState != null) {
      fToast.init(navigatorKey.currentState!.context);
    } else {
      fToast.init(context);
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void onPop() {
    context.read<NotesViewModel>().updateNote(
          widget.note
            ..title = _titleController.text
            ..body = _textEditingController.text
            ..editedDateTime = DateTime.now(),
          context,
        );
  }

  void onInfoTap() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoModalPopupSheet(
        height: MediaQuery.of(context).size.height * 0.35,
        child: CupertinoListSection.insetGrouped(
          children: [
            CupertinoListTile(
              title: Text(
                "Created DateTime",
                style: TextStyle(
                  color: isDarkMode(context) ? Colors.white : darkModeBlack,
                ),
              ),
              trailing: Material(
                type: MaterialType.transparency,
                child: Text(
                  DateFormat('yyyy-MM-dd hh:mma')
                      .format(widget.note.createdDateTime),
                  style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : darkModeBlack,
                  ),
                ),
              ),
            ),
            CupertinoListTile(
              title: Text(
                "Modified DateTime",
                style: TextStyle(
                  color: isDarkMode(context) ? Colors.white : darkModeBlack,
                ),
              ),
              trailing: Material(
                type: MaterialType.transparency,
                child: Text(
                  DateFormat('yyyy-MM-dd hh:mma')
                      .format(widget.note.editedDateTime),
                  style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : darkModeBlack,
                  ),
                ),
              ),
            ),
            CupertinoListTile(
              title: Text(
                "Characters",
                style: TextStyle(
                  color: isDarkMode(context) ? Colors.white : darkModeBlack,
                ),
              ),
              trailing: Material(
                type: MaterialType.transparency,
                child: Text(
                  _textEditingController.text.length.toString(),
                  style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : darkModeBlack,
                  ),
                ),
              ),
            ),
            CupertinoListTile(
              title: Text(
                "Words",
                style: TextStyle(
                  color: isDarkMode(context) ? Colors.white : darkModeBlack,
                ),
              ),
              trailing: Material(
                type: MaterialType.transparency,
                child: Text(
                  _textEditingController.text.split(' ').length.toString(),
                  style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : darkModeBlack,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDelete() {
    deleteToast(fToast: fToast, note: widget.note);
    context.read<NotesViewModel>().deleteNote(widget.note, context);
    Navigator.pop(context);
  }

  FocusNode titleNode = FocusNode();
  FocusNode bodyNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    double fontSize = context.watch<FontSizeViewModel>().fontSize;
    return PopScope(
      onPopInvoked: (val) => onPop(),
      child: GestureDetector(
        onTap: () {
          if (FocusManager.instance.primaryFocus != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: Scaffold(
          key: GlobalKey(),
          backgroundColor: isDarkMode(context) ? darkModeBlack : Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            shadowColor: isDarkMode(context) ? darkModeBlack : Colors.white,
            surfaceTintColor:
                isDarkMode(context) ? darkModeBlack : Colors.white,
            backgroundColor: isDarkMode(context) ? darkModeBlack : Colors.white,
            actions: [
              CupertinoButton(
                onPressed: onInfoTap,
                child: Icon(
                  Icons.info_outline,
                  color: isDarkMode(context) ? darkModeGrey : Colors.black,
                ),
              ),
              PullDownButton(
                itemBuilder: (context) => [
                  PullDownMenuItem(
                    title: 'Pin',
                    icon: widget.note.isPinned
                        ? CupertinoIcons.pin_fill
                        : CupertinoIcons.pin,
                    onTap: () {
                      context.read<NotesViewModel>().updateNote(
                            widget.note
                              ..title = _titleController.text
                              ..body = _textEditingController.text
                              ..editedDateTime = DateTime.now(),
                            context,
                          );
                      context
                          .read<NotesViewModel>()
                          .togglePin(widget.note, context);
                      pinToast(fToast: fToast, note: widget.note);
                    },
                  ),
                  PullDownMenuItem(
                    title: 'Unmissable',
                    icon: widget.note.isUnmissable
                        ? CupertinoIcons.bell_fill
                        : CupertinoIcons.bell,
                    onTap: () {
                      context.read<NotesViewModel>().updateNote(
                            widget.note
                              ..title = _titleController.text
                              ..body = _textEditingController.text
                              ..editedDateTime = DateTime.now(),
                            context,
                          );
                      context
                          .read<NotesViewModel>()
                          .toggleUnmissable(widget.note, context);
                      unmissableToast(fToast: fToast, note: widget.note);
                    },
                  ),
                  PullDownMenuItem(
                    isDestructive: true,
                    title: 'Delete',
                    icon: CupertinoIcons.trash,
                    onTap: onDelete,
                  ),
                ],
                buttonBuilder: (context, showMenu) => CupertinoButton(
                  onPressed: showMenu,
                  padding: const EdgeInsets.all(15),
                  child: Icon(
                    CupertinoIcons.ellipsis_circle,
                    color: isDarkMode(context) ? darkModeGrey : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextField(
                  focusNode: titleNode,
                  cursorColor: Colors.blue,
                  controller: _titleController,
                  onSubmitted: (val) {
                    FocusScope.of(context).requestFocus(bodyNode);
                  },
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                  decoration:
                      const InputDecoration.collapsed(hintText: 'Title'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    focusNode: bodyNode,
                    cursorColor: Colors.blue,
                    controller: _textEditingController,
                    keyboardType: TextInputType.multiline,
                    autofocus: true,
                    maxLines: null,
                    minLines: 7,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Start typing your note here...',
                      hintStyle: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
