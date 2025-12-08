import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool darkMode = false;

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
            const Text(
              "Nabiilll",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Mahasiswa Sistem Informasi",
              style: TextStyle(fontSize: 14, color: Color(0xFF636E72)),
            ),
            const SizedBox(height: 30),

            // --- Informasi Akun ---
            _buildInfoTile(
              icon: Icons.email_outlined,
              title: "Email",
              value: "biilll@planify.com",
            ),
            _buildInfoTile(
              icon: Icons.phone_android,
              title: "Nomor Telepon",
              value: "+62 812-3456-7890",
            ),
            _buildInfoTile(
              icon: Icons.school_outlined,
              title: "Universitas",
              value: "Universitas Singaperbangsa Karawang",
            ),
            _buildInfoTile(
              icon: Icons.badge_outlined,
              title: "NIM",
              value: "231063125001",
            ),
            const SizedBox(height: 25),

            // --- Pengaturan Aplikasi ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Pengaturan Aplikasi",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text(
                "Mode Gelap",
                style: TextStyle(color: Color(0xFF2D3436)),
              ),
              value: darkMode,
              onChanged: (val) {
                setState(() => darkMode = val);
              },
              secondary: const Icon(Icons.dark_mode_outlined),
              activeColor: const Color(0xFF6C5CE7),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("Bantuan & Panduan"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
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
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Berhasil keluar dari akun")),
                );
              },
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
