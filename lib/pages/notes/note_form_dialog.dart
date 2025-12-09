import 'package:flutter/material.dart';
import '../../database/database_helper.dart';

Future<bool?> showNoteFormDialog(
  BuildContext context, {
  Map<String, dynamic>? existing,
}) {
  final titleC = TextEditingController(text: existing?["title"] ?? "");
  final contentC = TextEditingController(text: existing?["content"] ?? "");
  int? scheduleId = existing?["scheduleId"];

  return showDialog<bool>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              existing == null ? "Tambah Catatan" : "Edit Catatan",
            ),

            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleC,
                    decoration: const InputDecoration(
                      labelText: "Judul",
                      prefixIcon: Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: contentC,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: "Isi Catatan",
                      prefixIcon: Icon(Icons.notes),
                    ),
                  ),
                  const SizedBox(height: 20),

                  FutureBuilder(
                    future: DatabaseHelper.instance.getAllSchedules(),
                    builder: (context, snap) {
                      final schedules = snap.data ?? [];

                      return DropdownButtonFormField<int?>(
                        value: scheduleId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: "Terkait Jadwal (opsional)",
                          prefixIcon: Icon(Icons.event),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text("Tidak terkait"),
                          ),
                          ...schedules.map(
                            (s) => DropdownMenuItem(
                              value: s["id"],
                              child: Text(
                                "${s["title"]} (${s["date"]})",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (v) =>
                            setStateDialog(() => scheduleId = v),
                      );
                    },
                  ),
                ],
              ),
            ),

            actions: [
              TextButton(
                child: const Text("Batal"),
                onPressed: () => Navigator.pop(context, false),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Simpan"),
                onPressed: () async {
                  if (titleC.text.trim().isEmpty ||
                      contentC.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Judul & isi tidak boleh kosong!"),
                      ),
                    );
                    return;
                  }

                  final data = {
                    "title": titleC.text.trim(),
                    "content": contentC.text.trim(),
                    "scheduleId": scheduleId,
                  };

                  if (existing == null) {
                    await DatabaseHelper.instance.insertNote(data);
                  } else {
                    await DatabaseHelper.instance
                        .updateNote(existing["id"], data);
                  }

                  if (context.mounted) Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
    },
  );
}
