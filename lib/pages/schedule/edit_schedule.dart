import 'package:flutter/material.dart';
import '../../database/database_helper.dart';

Future<void> showEditSchedule(
  BuildContext context,
  Map item,
  Future<void> Function() refresh,
) async {
  final titleC = TextEditingController(text: item["title"]);
  final timeC = TextEditingController(text: item["time"]);
  final roomC = TextEditingController(text: item["room"]);
  final detailC = TextEditingController(text: item["detail"]);

  DateTime pickedDate = DateTime.parse(item["date"]);

  final List<Color> colorOptions = [
    Colors.indigoAccent,
    Colors.teal,
    Colors.orangeAccent,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.purpleAccent,
  ];

  Color selectedColor = Color(item["color"] ?? Colors.indigoAccent.value);

  String dateKey(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}";

  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setDialog) {
        return AlertDialog(
          title: const Text("Edit Kegiatan"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: pickedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2035),
                    );
                    if (d != null) setDialog(() => pickedDate = d);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(
                      "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}",
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                TextField(controller: titleC, decoration: const InputDecoration(labelText: "Judul")),
                TextField(controller: timeC, decoration: const InputDecoration(labelText: "Jam")),
                TextField(controller: roomC, decoration: const InputDecoration(labelText: "Tempat")),
                TextField(controller: detailC, decoration: const InputDecoration(labelText: "Detail")),
                const SizedBox(height: 20),

                // PILIH WARNA
                const Text("Pilih Warna:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                Wrap(
                  spacing: 10,
                  children: List.generate(colorOptions.length, (i) {
                    final c = colorOptions[i];
                    return GestureDetector(
                      onTap: () => setDialog(() => selectedColor = c),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == c ? Colors.black : Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.instance.updateSchedule(
                  item["id"],
                  {
                    "title": titleC.text,
                    "time": timeC.text,
                    "room": roomC.text,
                    "detail": detailC.text,
                    "date": dateKey(pickedDate),
                    "color": selectedColor.value, // UPDATE WARNA
                  },
                );

                await refresh();
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    ),
  );
}
