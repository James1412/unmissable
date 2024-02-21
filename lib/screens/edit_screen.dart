import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/utils/toasts.dart';
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
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
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
              title: const Text("Created DateTime"),
              trailing: Material(
                type: MaterialType.transparency,
                child: Text(
                  DateFormat('yyyy-MM-dd hh:mma')
                      .format(widget.note.createdDateTime),
                ),
              ),
            ),
            CupertinoListTile(
              title: const Text("Modified DateTime"),
              trailing: Material(
                type: MaterialType.transparency,
                child: Text(
                  DateFormat('yyyy-MM-dd hh:mma')
                      .format(widget.note.editedDateTime),
                ),
              ),
            ),
            CupertinoListTile(
              title: const Text("Characters"),
              trailing: Material(
                type: MaterialType.transparency,
                child: Text(
                  _textEditingController.text.length.toString(),
                ),
              ),
            ),
            CupertinoListTile(
              title: const Text("Words"),
              trailing: Material(
                type: MaterialType.transparency,
                child: Text(
                  _textEditingController.text.split(' ').length.toString(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDelete() {
    context.read<NotesViewModel>().deleteNote(widget.note.uniqueKey);
    deleteToast(fToast: fToast, note: widget.note);
    Navigator.pop(context);
  }

  FocusNode titleNode = FocusNode();
  FocusNode bodyNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (val) => onPop(),
      child: GestureDetector(
        onTap: () {
          if (FocusManager.instance.primaryFocus != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            shadowColor: Colors.white,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            actions: [
              CupertinoButton(
                onPressed: onInfoTap,
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.black,
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
                      context.read<NotesViewModel>().togglePin(widget.note);
                      pinToast(fToast: fToast, note: widget.note);
                    },
                  ),
                  PullDownMenuItem(
                    title: 'Unmissable',
                    icon: widget.note.isUnmissable
                        ? CupertinoIcons.bell_fill
                        : CupertinoIcons.bell,
                    onTap: () {
                      context
                          .read<NotesViewModel>()
                          .toggleUnmissable(widget.note);
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
                  child: const Icon(
                    CupertinoIcons.ellipsis_circle,
                    color: Colors.black,
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
                    onChanged: (text) {
                      setState(() {
                        _textEditingController.text = text;
                      });
                    },
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Start typing your note here...',
                      hintStyle: TextStyle(
                        fontSize: 16.0,
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
