import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Variabel untuk menampung data dinamis
  String _userName = "Pengguna";
  String _userEmail = "email@example.com";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Mengambil data Nama dan Email yang disimpan saat Login/Register
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? "Nama Tidak Dikenal";
      _userEmail = prefs.getString('userEmail') ?? "Belum ada email";
    });
  }

  // Fungsi Logout
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus sesi login

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil keluar dari akun")),
      );
      // Kembali ke halaman login dan hapus riwayat navigasi
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
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
          'Profil Saya',
          style: TextStyle(
            color: Color(0xFF2D3436),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- Foto Profil ---
            const CircleAvatar(
              radius: 55,
              backgroundImage: AssetImage('assets/images/profile.png'),
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 16),
            
            // --- Nama User (Dinamis) ---
            Text(
              _userName, 
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            
            // --- Role (Statis) ---
            const Text(
              "Member Planify", 
              style: TextStyle(fontSize: 14, color: Color(0xFF636E72)),
            ),
            const SizedBox(height: 30),

            // --- Informasi Akun ---
            _buildInfoTile(
              icon: Icons.email_outlined,
              title: "Email",
              value: _userEmail, // Menggunakan variabel dinamis
            ),
            _buildInfoTile(
              icon: Icons.school_outlined,
              title: "Instansi / Sekolah",
              value: "Universitas Singaperbangsa Karawang", 
            ),
            
            const SizedBox(height: 25),

            // --- Pengaturan Aplikasi ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Lainnya",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 10),  
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("Bantuan & Panduan"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Tambahkan navigasi ke halaman bantuan nanti
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("Tentang Planify"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: "Planify",
                  applicationVersion: "1.0.0",
                );
              },
            ),
            const SizedBox(height: 30),

            // --- Tombol Logout ---
            ElevatedButton.icon(
              onPressed: _logout, // Memanggil fungsi logout
              icon: const Icon(Icons.logout),
              label: const Text(
                "Keluar",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk membuat kotak info
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6C5CE7), size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF636E72),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3436),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}