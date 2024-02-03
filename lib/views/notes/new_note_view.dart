import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Note',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Text('Write your note here . . .'),
    );
  }
}
