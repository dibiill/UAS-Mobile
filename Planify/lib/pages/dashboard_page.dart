import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorPrimary = const Color(0xFF6C5CE7);
    final colorText = const Color(0xFF2D3436);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              const Text(
                "Halo, Nabil 👋",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Selamat datang di Planify — rencanakan harimu dengan lebih teratur!",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF636E72),
                ),
              ),
              const SizedBox(height: 24),

              // Ringkasan 3 fitur utama
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSummaryCard(
                    title: "Jadwal Hari Ini",
                    value: "2 Kelas",
                    icon: Icons.calendar_today_outlined,
                    color: Colors.blueAccent,
                  ),
                  _buildSummaryCard(
                    title: "Tugas Aktif",
                    value: "4 Tugas",
                    icon: Icons.assignment_outlined,
                    color: Colors.deepPurpleAccent,
                  ),
                  _buildSummaryCard(
                    title: "Fokus Belajar",
                    value: "45 mnt",
                    icon: Icons.timer_outlined,
                    color: Colors.teal,
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Jadwal Terdekat
              Text(
                "📅 Jadwal Hari Ini",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: colorText,
                ),
              ),
              const SizedBox(height: 12),
              _buildScheduleCard(
                "Pemrograman Web",
                "08:00 - 10:00",
                "Ruang B203",
                colorPrimary,
              ),
              _buildScheduleCard(
                "Manajemen Proyek",
                "13:00 - 15:00",
                "Lab SI",
                Colors.indigoAccent,
              ),
              const SizedBox(height: 28),

              // Tugas Terbaru
              Text(
                "📝 Tugas Aktif",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: colorText,
                ),
              ),
              const SizedBox(height: 12),
              _buildTaskCard(
                "Laporan Praktikum PBO",
                "Deadline: 16 Okt 2025",
                0.8,
                colorPrimary,
              ),
              _buildTaskCard(
                "Makalah Manajemen Proyek",
                "Deadline: 18 Okt 2025",
                0.4,
                Colors.teal,
              ),
              const SizedBox(height: 28),

              // Statistik Belajar
              Text(
                "📈 Statistik Fokus Belajar",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: colorText,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                    const Text(
                      "Total waktu fokus minggu ini",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF636E72),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "3 jam 25 menit",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C5CE7),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: 0.65,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF6C5CE7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "65% dari target mingguan",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF636E72),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget ringkasan (jadwal, tugas, fokus) ---
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 105,
      padding: const EdgeInsets.all(14),
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
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF636E72),
            ),
          ),
        ],
      ),
    );
  }

  // --- Card Jadwal ---
  Widget _buildScheduleCard(
      String matkul, String waktu, String lokasi, Color color) {
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

  // --- Card Tugas ---
  Widget _buildTaskCard(
      String title, String deadline, double progress, Color color) {
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
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF636E72),
            ),
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