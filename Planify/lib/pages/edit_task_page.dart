import 'package:flutter/material.dart';

class EditTaskPage extends StatefulWidget {
  final Map<String, dynamic> taskData;
  final Function(Map<String, dynamic>) onSave;

  const EditTaskPage({
    super.key,
    required this.taskData,
    required this.onSave,
  });

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _subjectController;
  late TextEditingController _detailController;
  late TextEditingController _dateController;
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(text: widget.taskData['subject']);
    _detailController = TextEditingController(text: widget.taskData['detail']);
    _dateController = TextEditingController(text: widget.taskData['deadline']);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Edit Tugas",
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
                "Perbarui detail tugasmu ✏️",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF636E72),
                ),
              ),
              const SizedBox(height: 22),

              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Mata Kuliah',
                  prefixIcon: const Icon(Icons.book_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Mata kuliah wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _detailController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Tugas',
                  prefixIcon: const Icon(Icons.description_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Deskripsi wajib diisi' : null,
              ),
              const SizedBox(height: 16),

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

              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text(
                  "Simpan Perubahan",
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
                    widget.onSave({
                      'subject': _subjectController.text,
                      'detail': _detailController.text,
                      'deadline': _dateController.text,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Tugas berhasil diperbarui ✅"),
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
