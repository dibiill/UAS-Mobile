import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/task_table.dart';
import '../models/task_model.dart';
import '../../database/database_helper.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String userName = "Pengguna";
  List<TaskModel> tasks = [];
  int activeTaskCount = 0;

  List<Map<String, dynamic>> todaySchedules = [];

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadTasks();
    _loadTodaySchedules();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('userName') ?? "Pengguna";
    if (mounted) {
      setState(() {
        userName = name;
      });
    }
  }

  Future<void> _loadTasks() async {
    final data = await TaskTable.getAll();
    if (mounted) {
      setState(() {
        tasks = data;
        activeTaskCount = data.length;
      });
    }
  }

  String todayKey() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  Future<void> _loadTodaySchedules() async {
    final allSchedules = await DatabaseHelper.instance.getAllSchedules();
    final String today = todayKey();

    final todayList = allSchedules.where((s) => s['date'] == today).toList();

    if (mounted) {
      setState(() {
        todaySchedules = todayList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorPrimary = const Color(0xFF6C5CE7);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Halo, $userName",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Selamat datang di Planify — rencanakan harimu dengan lebih teratur!",
                style: TextStyle(fontSize: 14, color: Color(0xFF636E72)),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSummaryCard(
                    title: "Jadwal Hari Ini",
                    value: todaySchedules.isEmpty
                        ? "0 Kegiatan"
                        : "${todaySchedules.length} Kegiatan",
                    icon: Icons.calendar_today_outlined,
                    color: Colors.blueAccent,
                  ),
                  _buildSummaryCard(
                    title: "Tugas Aktif",
                    value: "$activeTaskCount Tugas",
                    icon: Icons.assignment_outlined,
                    color: Colors.deepPurpleAccent,
                  ),
                ],
              ),
              const SizedBox(height: 30),

              const Text(
                "Jadwal Hari Ini",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 12),

              todaySchedules.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Tidak ada jadwal hari ini",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    )
                  : Column(
                      children: todaySchedules.map((item) {
                        final Color color = item["color"] != null
                            ? Color(item["color"])
                            : colorPrimary;

                        return _buildScheduleCard(
                          item["title"] ?? "Tanpa Judul",
                          item["time"] ?? "-",
                          item["room"] ?? "Lokasi tidak diketahui",
                          color,
                        );
                      }).toList(),
                    ),

              const SizedBox(height: 28),

              const Text(
                "Tugas Aktif",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 12),

              tasks.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Belum ada tugas",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : Column(
                      children: tasks.take(3).map((task) {
                        return _buildTaskCard(
                          task.title,
                          "Deadline: ${task.deadline}",
                          task.progress,
                          Color(task.color),
                        );
                      }).toList(),
                    ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 160,
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
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Color(0xFF636E72)),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(
    String matkul,
    String waktu,
    String lokasi,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.class_outlined, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  matkul,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$waktu • $lokasi",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF636E72),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(
    String title,
    String deadline,
    double progress,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assignment_outlined, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3436),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            deadline,
            style: const TextStyle(fontSize: 13, color: Color(0xFF636E72)),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
