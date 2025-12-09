import 'package:flutter/material.dart';
import '../../database/database_helper.dart';

void showDeleteDialog(
  BuildContext context,
  int id,
  Future<void> Function() refresh,
) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Hapus Kegiatan"),
      content: const Text("Yakin ingin menghapus kegiatan ini?"),
      actions: [
        TextButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () async {
            await DatabaseHelper.instance.deleteSchedule(id);
            await refresh();
            Navigator.pop(context);
          },
          child: const Text("Hapus"),
        ),
      ],
    ),
  );
}
