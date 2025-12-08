import 'package:flutter/material.dart';
import '../database/task_table.dart';
import '../models/task_model.dart';
import 'add_task_page.dart';
import 'edit_task_page.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<TaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  // LOAD DATA DARI DATABASE
  void loadTasks() async {
    final data = await TaskTable.getTasks();
    setState(() => tasks = data);
  }

  // HAPUS DATA
  void deleteTask(int id, String title) async {
    await TaskTable.deleteTask(id);
    loadTasks();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Tugas "$title" berhasil dihapus')));
  }

  // POPUP KONFIRMASI
  void confirmDelete(TaskModel task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Tugas"),
        content: const Text("Yakin ingin menghapus tugas ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteTask(task.id!, task.title);
            },
            child: const Text("Yakin"),
          ),
        ],
      ),
    );
  }

  // BOTTOM SHEET EDIT / HAPUS
  void showTaskOptions(TaskModel task) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text("Edit Tugas"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditTaskPage(task: task)),
                  ).then((_) => loadTasks());
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Hapus Tugas"),
                onTap: () {
                  Navigator.pop(context);
                  confirmDelete(task);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // UI CARD TUGAS
  Widget buildTaskCard(TaskModel t) {
    return GestureDetector(
      onTap: () => showTaskOptions(t),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(t.color).withOpacity(0.3)),
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
            Row(
              children: [
                Icon(
                  Icons.assignment_turned_in,
                  size: 28,
                  color: Color(t.color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    t.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
                const SizedBox(width: 6),
                Text(
                  "Deadline: ${t.deadline}",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),

            const SizedBox(height: 12),

            LinearProgressIndicator(
              value: t.progress,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Color(t.color)),
            ),

            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t.status, style: const TextStyle(fontSize: 13)),
                Text(
                  "${(t.progress * 100).round()}%",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // MAIN BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Daftar Tugas",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
      ),

      body: tasks.isEmpty
          ? const Center(
              child: Text(
                "Belum ada tugas",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: tasks.length,
              itemBuilder: (context, index) => buildTaskCard(tasks[index]),
            ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6C5CE7),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Tambah Tugas",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskPage()),
          ).then((_) => loadTasks());
        },
      ),
    );
  }
}
