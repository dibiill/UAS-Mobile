import 'package:flutter/material.dart';
import 'pages/notes/notes_page.dart'; // SESUAIKAN PATH FOLDER MU

void main() {
  runApp(const TestNotesApp());
}

class TestNotesApp extends StatelessWidget {
  const TestNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NotesPage(),
    );
  }
}
