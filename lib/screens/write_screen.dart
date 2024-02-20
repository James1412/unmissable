import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _titleController = TextEditingController(
    text: "New Note",
  );

  @override
  void dispose() {
    _textEditingController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void onClear() {
    _textEditingController.clear();
    _titleController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusManager.instance.primaryFocus != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: TextField(
            cursorColor: Colors.blue,
            controller: _titleController,
            style: const TextStyle(fontSize: 25),
            decoration: const InputDecoration.collapsed(hintText: 'Title'),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                if (Platform.isIOS) {
                  HapticFeedback.lightImpact();
                }
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () {},
                        isDefaultAction: true,
                        child: const Text(
                          "Create as unmissable",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () {},
                        child: const Text(
                          "Create",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      CupertinoActionSheetAction(
                        isDestructiveAction: true,
                        onPressed: onClear,
                        child: const Text(
                          "Clear",
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Done",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
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
      ),
    );
  }
}
