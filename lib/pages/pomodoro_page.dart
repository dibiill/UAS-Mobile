import 'dart:async';
import 'package:flutter/material.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  static const int focusTime = 25 * 60; // 25 menit
  static const int breakTime = 5 * 60; // 5 menit
  int remainingSeconds = focusTime;
  bool isRunning = false;
  bool isFocusMode = true;
  Timer? timer;

  void _startTimer() {
    if (timer != null && timer!.isActive) return;
    setState(() => isRunning = true);

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        _switchMode();
      }
    });
  }

  void _pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  void _resetTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      remainingSeconds = isFocusMode ? focusTime : breakTime;
    });
  }

  void _switchMode() {
    timer?.cancel();
    setState(() {
      isFocusMode = !isFocusMode;
      remainingSeconds = isFocusMode ? focusTime : breakTime;
      isRunning = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFocusMode ? "Waktunya fokus lagi 🎯" : "Istirahat dulu sebentar ☕",
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    final total = isFocusMode ? focusTime : breakTime;
    final progress = (total - remainingSeconds) / total;
    final circleValue = isFocusMode ? (1 - progress) : progress;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          "Timer Belajar",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isFocusMode ? "Sesi Fokus" : "Waktu Istirahat",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: isFocusMode
                      ? const Color(0xFF6C5CE7)
                      : const Color(0xFF00B894),
                ),
              ),
              const SizedBox(height: 40),

              // Lingkaran Timer
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: circleValue,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isFocusMode
                            ? const Color(0xFF6C5CE7)
                            : const Color(0xFF00B894),
                      ),
                    ),
                  ),
                  Text(
                    _formatTime(remainingSeconds),
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Tombol Kontrol
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: isRunning ? _pauseTimer : _startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRunning
                          ? Colors.orangeAccent
                          : const Color(0xFF6C5CE7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                    label: Text(isRunning ? "Pause" : "Mulai"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _resetTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reset"),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Switch Mode Manual
              TextButton.icon(
                onPressed: _switchMode,
                icon: const Icon(Icons.swap_horiz),
                label: Text(
                  isFocusMode
                      ? "Ganti ke Mode Istirahat"
                      : "Ganti ke Mode Fokus",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
