import 'package:flutter/material.dart';

class MyNoteView extends StatefulWidget {
  const MyNoteView({ Key? key }) : super(key: key);

  @override
  _MyNoteViewState createState() => _MyNoteViewState();
}

class _MyNoteViewState extends State<MyNoteView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        expands: true,
      ),
    );
  }
}