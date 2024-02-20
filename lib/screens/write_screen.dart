import 'dart:ui';

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
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: TextField(
            cursorColor: Colors.blue,
            controller: _titleController,
            style: const TextStyle(fontSize: 25),
            decoration: const InputDecoration.collapsed(hintText: 'Title'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            cursorColor: Colors.blue,
            controller: _textEditingController,
            keyboardType: TextInputType.multiline,
            autofocus: true,
            maxLines: null,
            onChanged: (text) {
              setState(() {
                _textEditingController.text = text;
              });
            },
            style: const TextStyle(
              fontSize: 16.0, // Normal font size for subsequent lines
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
