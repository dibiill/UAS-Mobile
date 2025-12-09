import 'package:flutter/material.dart';
import '../database/task_table.dart';
import '../models/task_model.dart';

class EditTaskPage extends StatefulWidget {
  final TaskModel task;

  const EditTaskPage({super.key, required this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final statusList = ["Baru Dimulai", "Dalam Proses", "Hampir Selesai"];

  late TextEditingController titleC;
  late TextEditingController deadlineC;
  late String selectedStatus;
  late double progressValue;
  late Color selectedColor;

  @override
  void initState() {
    super.initState();

    titleC = TextEditingController(text: widget.task.title);
    deadlineC = TextEditingController(text: widget.task.deadline);
    selectedStatus = widget.task.status;
    progressValue = widget.task.progress;
    selectedColor = Color(widget.task.color);
  }

  @override
  void dispose() {
    titleC.dispose();
    deadlineC.dispose();
    super.dispose();
  }

  // UPDATE DATABASE
  void updateTask() async {
    if (titleC.text.isEmpty || deadlineC.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua field wajib diisi")));
      return;
    }

    final updated = TaskModel(
      id: widget.task.id,
      title: titleC.text,
      deadline: deadlineC.text,
      progress: progressValue,
      status: selectedStatus,
      color: selectedColor.value,
    );

    await TaskTable.update(updated);

    Navigator.pop(context);
  }

  // COLOR PICKER
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

  // BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text("Edit Tugas"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: updateTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Simpan Perubahan",
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
