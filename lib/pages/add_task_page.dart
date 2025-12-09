import 'package:flutter/material.dart';
import '../database/task_table.dart';
import '../models/task_model.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final titleC = TextEditingController();
  final deadlineC = TextEditingController();
  final statusList = ["Baru Dimulai", "Dalam Proses", "Hampir Selesai"];

  String selectedStatus = "Baru Dimulai";
  double progressValue = 0.0;
  Color selectedColor = Colors.indigoAccent;

  @override
  void dispose() {
    titleC.dispose();
    deadlineC.dispose();
    super.dispose();
  }

  // SIMPAN KE DATABASE
  void saveTask() async {
    if (titleC.text.isEmpty || deadlineC.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua field wajib diisi")));
      return;
    }

    final task = TaskModel(
      title: titleC.text,
      deadline: deadlineC.text,
      progress: progressValue,
      status: selectedStatus,
      color: selectedColor.value,
    );

    await TaskTable.insert(task);


    Navigator.pop(context);
  }

  // WIDGET COLOR PICKER
  Widget colorOption(Color color) {
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            width: selectedColor == color ? 3 : 1,
            color: selectedColor == color ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Tugas"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFFF8F9FB),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // JUDUL TUGAS
            const Text(
              "Judul Tugas",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: titleC,
              decoration: inputStyle("Masukkan judul tugas"),
            ),
            const SizedBox(height: 16),

            // DEADLINE
            const Text(
              "Deadline",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: deadlineC,
              decoration: inputStyle("Contoh: 20 Okt 2025"),
            ),
            const SizedBox(height: 16),

            // STATUS
            const Text("Status", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            DropdownButtonFormField(
              initialValue: selectedStatus,
              decoration: inputStyle(""),
              items: statusList
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => selectedStatus = v!),
            ),
            const SizedBox(height: 20),

            // PROGRESS
            const Text(
              "Progress",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Slider(
              value: progressValue,
              min: 0,
              max: 1,
              divisions: 10,
              label: "${(progressValue * 100).round()}%",
              activeColor: selectedColor,
              onChanged: (v) => setState(() => progressValue = v),
            ),
            const SizedBox(height: 20),

            // PICK COLOR
            const Text(
              "Warna Label",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                colorOption(Colors.indigoAccent),
                colorOption(Colors.teal),
                colorOption(Colors.orangeAccent),
                colorOption(Colors.redAccent),
                colorOption(Colors.green),
              ],
            ),

            const SizedBox(height: 40),

            // BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Simpan Tugas",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // INPUT DECORATION
  InputDecoration inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}
