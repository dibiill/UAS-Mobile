import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import 'add_schedule.dart';
import 'edit_schedule.dart';
import 'delete_schedule.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> schedules = [];
  List<String> availableDates = [];

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  String dateKey(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  String displayDate(DateTime d) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "Mei",
      "Jun",
      "Jul",
      "Agu",
      "Sep",
      "Okt",
      "Nov",
      "Des",
    ];
    return "${d.day} ${months[d.month - 1]} ${d.year}";
  }

  Future<void> _loadSchedule({DateTime? forDate}) async {
    final date = forDate ?? selectedDate;

    final db = DatabaseHelper.instance;
    final data = await db.getSchedulesByDate(dateKey(date));
    final dates = await db.getAllScheduleDates();

    setState(() {
      selectedDate = date;
      schedules = data;
      availableDates = dates;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Jadwal Kegiatan",
          style: TextStyle(
            color: Color(0xFF2D3436),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C5CE7),
        child: const Icon(Icons.add),
        onPressed: () {
          showAddSchedule(context, selectedDate, () async {
            await _loadSchedule();
          });
        },
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          if (availableDates.isNotEmpty) ...[
            _buildDatePicker(),
            const SizedBox(height: 10),
          ],

          Expanded(child: _buildScheduleList()),
        ],
      ),
    );
  }

  Widget _buildScheduleList() {
    if (schedules.isEmpty) {
      return const Center(
        child: Text(
          "Belum ada kegiatan",
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (_, i) {
        final item = schedules[i];
        final date = DateTime.parse(item["date"]);

        final Color color = item["color"] != null
            ? Color(item["color"])
            : const Color(0xFF6C5CE7);

        return GestureDetector(
          onTap: () {
            showEditSchedule(context, item, () async => _loadSchedule());
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 65,
                  decoration: BoxDecoration(
                    color: color, //
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayDate(date),
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        item["title"],
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        item["time"],
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 2),

                      Text(
                        "${item["room"]} • ${item["detail"]}",
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    showDeleteDialog(
                      context,
                      item["id"],
                      () async => _loadSchedule(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDatePicker() {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "Mei",
      "Jun",
      "Jul",
      "Agu",
      "Sep",
      "Okt",
      "Nov",
      "Des",
    ];
    const days = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: availableDates.length,
        itemBuilder: (context, index) {
          final key = availableDates[index];
          final date = DateTime.parse(key);

          final sel =
              date.day == selectedDate.day &&
              date.month == selectedDate.month &&
              date.year == selectedDate.year;

          return GestureDetector(
            onTap: () => _loadSchedule(forDate: date),
            child: Container(
              margin: const EdgeInsets.only(left: 14),
              padding: const EdgeInsets.all(12),
              width: 75,
              decoration: BoxDecoration(
                color: sel ? const Color(0xFF6C5CE7) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: sel ? const Color(0xFF6C5CE7) : Colors.grey,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    days[date.weekday - 1],
                    style: TextStyle(
                      color: sel ? Colors.white : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    "${date.day}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: sel ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    months[date.month - 1],
                    style: TextStyle(
                      color: sel ? Colors.white : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
