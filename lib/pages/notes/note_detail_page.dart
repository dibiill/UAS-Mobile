import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import 'note_form_dialog.dart';

class NoteDetailPage extends StatelessWidget {
  final Map<String, dynamic> note;
  final String? scheduleTitle;

  const NoteDetailPage({
    super.key,
    required this.note,
    this.scheduleTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note["title"]),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final changed = await showNoteFormDialog(
                context,
                existing: note,
              );
              if (changed == true) Navigator.pop(context, true);
            },
          ),

          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Hapus Catatan?"),
                  content: const Text("Catatan ini akan dihapus secara permanen."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Batal"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Hapus"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await DatabaseHelper.instance.deleteNote(note["id"]);
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (scheduleTitle != null) ...[
              Row(
                children: [
                  const Icon(Icons.event, color: Color(0xFF6C5CE7)),
                  const SizedBox(width: 6),
                  Text(
                    "Terkait: $scheduleTitle",
                    style: const TextStyle(
                      color: Color(0xFF6C5CE7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            Text(
              note["content"],
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
