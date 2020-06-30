import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mzefyr/image_delegator.dart';
import 'package:mzefyr/mtoolbar.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class EditorPage extends StatefulWidget {
  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Here we must load the document and pass it to Zefyr controller.
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    // Note that the editor requires special `ZefyrScaffold` widget to be
    // one of its parents.
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Editor page"),
        actions: [
          FlatButton.icon(
              onPressed: () {
                _saveDocument(context);
              },
              icon: Icon(Icons.save),
              label: Text('Lable'))
        ],
      ),
      body: Builder(
        builder: (context) {
          return ZefyrScaffold(
            child: ZefyrEditor(
              toolbarDelegate: MDZefyrToolbarDelegate(),
              padding: EdgeInsets.all(16),
              controller: _controller,
              focusNode: _focusNode,
              imageDelegate: const MyAppZefyrImageDelegate(),
            ),
          );
        },
      ),
    );
  }

  /// Loads the document to be edited in Zefyr.
  NotusDocument _loadDocument() {
    // For simplicity we hardcode a simple document with one line of text
    // saying "Zefyr Quick Start".
    // (Note that delta must always end with newline.)
    final Delta delta = Delta()..insert("Zefyr Quick Start\n");
    return NotusDocument.fromDelta(delta);
  }

  void _saveDocument(BuildContext context) {
    // Notus documents can be easily serialized to JSON by passing to
    // `jsonEncode` directly
    final contents = jsonEncode(_controller.document);
    // For this example we save our document to a temporary file.
    // And show a snack bar on success.
    print(contents);
    final file = File(Directory.systemTemp.path + "/quick_start.json");
    // And show a snack bar on success.
    file.writeAsString(contents);
  }
}