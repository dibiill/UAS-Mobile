import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import 'note_detail_page.dart';
import 'note_form_dialog.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Map<String, dynamic>> notes = [];
  Map<int, String> scheduleNames = {};

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final db = DatabaseHelper.instance;
    final n = await db.getNotes();
    final schedules = await db.getAllSchedules();

    scheduleNames = {
      for (var s in schedules) s["id"]: "${s["title"]} (${s["date"]})",
    };

    setState(() => notes = n);
  }

  String preview(String t) => t.length <= 90 ? t : "${t.substring(0, 90)}…";

  void showDeleteNoteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Hapus Catatan"),
        content: const Text("Yakin ingin menghapus catatan ini?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await DatabaseHelper.instance.deleteNote(id);
              Navigator.pop(context); // tutup dialog
              _loadNotes(); // refresh list
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Catatan",
          style: TextStyle(
            color: Color(0xFF2D3436),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6C5CE7),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Tambah Catatan",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          if (await showNoteFormDialog(context) == true) _loadNotes();
        },
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: notes.isEmpty
            ? const Center(
                child: Text(
                  "Belum ada catatan",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (_, i) {
                  final item = notes[i];
                  final related = scheduleNames[item["scheduleId"]];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 6),
                      ],
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final changed = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NoteDetailPage(
                                    note: item,
                                    scheduleTitle: related,
                                  ),
                                ),
                              );
                              if (changed == true) _loadNotes();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["title"],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                Text(
                                  preview(item["content"]),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF636E72),
                                  ),
                                ),

                                if (related != null) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.event_note,
                                        size: 16,
                                        color: Color(0xFF6C5CE7),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          "Terkait: $related",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF6C5CE7),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            showDeleteNoteDialog(context, item["id"]);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
