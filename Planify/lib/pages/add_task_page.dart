import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();

  String? _subject;
  String? _taskDetail;
  DateTime? _deadline;

  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Tambah Tugas",
          style: TextStyle(
            color: Color(0xFF2D3436),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2D3436)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Isi detail tugas dengan lengkap ✏️",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF636E72),
                ),
              ),
              const SizedBox(height: 22),

              // Mata Kuliah
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Mata Kuliah',
                  prefixIcon: const Icon(Icons.book_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mata kuliah tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) => _subject = value,
              ),
              const SizedBox(height: 16),

              // Detail Tugas
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Deskripsi Tugas',
                  prefixIcon: const Icon(Icons.description_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tugas wajib diisi';
                  }
                  return null;
                },
                onSaved: (value) => _taskDetail = value,
              ),
              const SizedBox(height: 16),

              // Deadline
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Deadline',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih tanggal deadline';
                  }
                  return null;
                },
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _deadline = selectedDate;
                      _dateController.text =
                          "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
                    });
                  }
                },
              ),
              const SizedBox(height: 28),

              // Tombol Simpan
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text(
                  "Simpan Tugas",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // simulasi proses simpan
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Tugas berhasil ditambahkan ✅"),
                        backgroundColor: colorScheme.primary,
                      ),
                    );

                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}