import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<Map<String, String>> notes = [
    {
      'title': 'Catatan Rapat Kelompok',
      'content': 'Bahas progres aplikasi Planify, deadline desain UI minggu depan.',
    },
    {
      'title': 'Reminder UTS',
      'content': 'UTS Manajemen Proyek tanggal 21 Oktober. Belajar bab 3–5.',
    },
    {
      'title': 'Ide Fitur Tambahan',
      'content': 'Tambah mode fokus dan kalender mingguan di dashboard.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Catatan',
          style: TextStyle(
            color: Color(0xFF2D3436),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: notes.isEmpty
            ? const Center(
                child: Text(
                  "Belum ada catatan 📝",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              )
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final n = notes[index];
                  return Dismissible(
                    key: Key(n['title']!),
                    background: Container(
                      color: Colors.redAccent,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      setState(() {
                        notes.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${n['title']} dihapus 🗑️"),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            n['title']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            n['content']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF636E72),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddNoteDialog(context);
        },
        backgroundColor: const Color(0xFF6C5CE7),
        label: const Text(
          "Tambah Catatan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    String? newTitle;
    String? newContent;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("Tambah Catatan Baru"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Judul',
                    prefixIcon: Icon(Icons.title),
                  ),
                  onChanged: (value) => newTitle = value,
                ),
                const SizedBox(height: 12),
                TextField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Isi Catatan',
                    prefixIcon: Icon(Icons.notes),
                  ),
                  onChanged: (value) => newContent = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                if ((newTitle ?? "").isNotEmpty && (newContent ?? "").isNotEmpty) {
                  setState(() {
                    notes.add({
                      'title': newTitle!,
                      'content': newContent!,
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Catatan ditambahkan ✅"),
                      backgroundColor: Color(0xFF6C5CE7),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                foregroundColor: Colors.white,
              ),
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }
}
