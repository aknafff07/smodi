import 'package:flutter/material.dart';
import 'package:smodi/core/constants/colors.dart';
import 'dart:async'; // Untuk Timer

class FocusSessionScreen extends StatefulWidget {
  const FocusSessionScreen({super.key});

  @override
  State<FocusSessionScreen> createState() => _FocusSessionScreenState();
}

class _FocusSessionScreenState extends State<FocusSessionScreen> {
  Duration _duration = const Duration(minutes: 25); // Durasi fokus default (25 menit)
  Timer? _timer;
  bool _isRunning = false; // Status sesi berjalan
  Duration _currentDuration = Duration.zero; // Durasi yang sedang berjalan
  bool _isConfiguring = true; // Status konfigurasi awal

  @override
  void initState() {
    super.initState();
    _currentDuration = _duration; // Inisialisasi durasi saat ini dengan durasi default
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _isConfiguring = false; // Setelah mulai, tidak dalam mode konfigurasi lagi
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentDuration.inSeconds == 0) {
        _stopTimer();
        _showCompletionDialog();
      } else {
        setState(() {
          _currentDuration = _currentDuration - const Duration(seconds: 1);
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _currentDuration = _duration; // Reset ke durasi awal yang dipilih
      _isConfiguring = true; // Kembali ke mode konfigurasi
    });
  }

  void _setDuration(Duration newDuration) {
    setState(() {
      _duration = newDuration;
      _currentDuration = newDuration;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Focus Session Completed!'),
          content: const Text('Great job! You completed your focus session.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(color: AppColors.primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
                _resetTimer(); // Reset timer setelah dialog ditutup
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Deep Focus (F1)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isConfiguring)
              Column(
                children: [
                  const Text(
                    'Set Your Focus Duration',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 48, color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        hintText: 'Minutes',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        suffixText: 'min',
                        suffixStyle: TextStyle(fontSize: 24, color: Colors.white.withOpacity(0.7)),
                      ),
                      onSubmitted: (value) {
                        int? minutes = int.tryParse(value);
                        if (minutes != null && minutes > 0) {
                          _setDuration(Duration(minutes: minutes));
                        } else {
                          // Handle invalid input
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a valid number of minutes.'), backgroundColor: AppColors.errorColor),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Pilihan durasi cepat
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDurationChip(15),
                      _buildDurationChip(25),
                      _buildDurationChip(45),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              )
            else // Tampilan saat sesi berjalan atau jeda
              Column(
                children: [
                  Text(
                    'Time Remaining:',
                    style: TextStyle(fontSize: 24, color: Colors.white.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _formatDuration(_currentDuration),
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isRunning) ...[
                  FloatingActionButton.extended(
                    onPressed: _stopTimer,
                    label: const Text('PAUSE', style: TextStyle(fontSize: 20, color: Colors.white)),
                    icon: const Icon(Icons.pause, size: 30, color: Colors.white),
                    backgroundColor: AppColors.warningColor, // Oranye untuk jeda
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton.extended(
                    onPressed: _resetTimer,
                    label: const Text('RESET', style: TextStyle(fontSize: 20, color: Colors.white)),
                    icon: const Icon(Icons.refresh, size: 30, color: Colors.white),
                    backgroundColor: AppColors.errorColor, // Merah untuk reset
                  ),
                ] else ...[
                  FloatingActionButton.extended(
                    onPressed: _currentDuration.inSeconds > 0 ? _startTimer : null, // Hanya bisa mulai jika durasi > 0
                    label: const Text('START', style: TextStyle(fontSize: 20, color: Colors.white)),
                    icon: const Icon(Icons.play_arrow, size: 30, color: Colors.white),
                    backgroundColor: AppColors.successColor, // Hijau untuk mulai
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton.extended(
                    onPressed: _resetTimer,
                    label: const Text('RESET', style: TextStyle(fontSize: 20, color: Colors.white)),
                    icon: const Icon(Icons.refresh, size: 30, color: Colors.white),
                    backgroundColor: AppColors.errorColor, // Merah untuk reset
                  ),
                ],
              ],
            ),
            const SizedBox(height: 40),
            // Tombol Konfigurasi (jika ada lebih banyak konfigurasi selain durasi)
            // ElevatedButton.icon(
            //   onPressed: () {
            //     // Tampilkan dialog atau navigasi ke layar konfigurasi lanjutan
            //     showDialog(
            //       context: context,
            //       builder: (context) => AlertDialog(
            //         backgroundColor: Colors.white,
            //         title: const Text('Advanced Configuration'),
            //         content: const Text('Here you can add more settings for Deep Focus, e.g., soundscapes, notification settings, etc.'),
            //         actions: [
            //           TextButton(
            //             onPressed: () => Navigator.pop(context),
            //             child: const Text('Close', style: TextStyle(color: AppColors.primaryColor)),
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            //   icon: const Icon(Icons.settings, color: Colors.white),
            //   label: const Text('Advanced Settings', style: TextStyle(color: Colors.white)),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: AppColors.primaryColor.withOpacity(0.7), // Sedikit transparan
            //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(30),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationChip(int minutes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ChoiceChip(
        label: Text('$minutes min', style: TextStyle(color: Colors.black),),
        selected: _duration.inMinutes == minutes,
        onSelected: (selected) {
          if (selected) {
            _setDuration(Duration(minutes: minutes));
          }
        },
        selectedColor: AppColors.primaryColor,
        labelStyle: TextStyle(
          color: _duration.inMinutes == minutes ? Colors.white : Colors.white70,
        ),
        backgroundColor: Colors.white.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: _duration.inMinutes == minutes ? AppColors.primaryColor : Colors.white.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}