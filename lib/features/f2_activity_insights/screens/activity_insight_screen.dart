// lib/features/activity/screens/activity_insights_screen.dart

import 'package:flutter/material.dart';
import 'package:smodi/core/constants/colors.dart';
import 'package:smodi/models/focus_session.dart';
import 'package:smodi/core/services/database_helper.dart';
import 'package:intl/intl.dart'; // Tambahkan ini di pubspec.yaml jika belum: intl: ^0.19.0

class ActivityInsightsScreen extends StatefulWidget {
  const ActivityInsightsScreen({super.key});

  @override
  State<ActivityInsightsScreen> createState() => _ActivityInsightsScreenState();
}

class _ActivityInsightsScreenState extends State<ActivityInsightsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<FocusSession> _sessions = []; // Daftar sesi fokus
  bool _isLoading = true; // Status loading data

  @override
  void initState() {
    super.initState();
    _loadSessions(); // Muat data sesi saat layar dibuka
  }

  // Fungsi untuk memuat semua sesi dari database
  Future<void> _loadSessions() async {
    setState(() {
      _isLoading = true; // Set loading true saat memulai
    });
    try {
      final sessions = await _dbHelper.getSessions();
      setState(() {
        _sessions = sessions;
      });
    } catch (e) {
      print('Error loading sessions: $e');
      _showSnackbar('Failed to load activity data.', isError: true);
    } finally {
      setState(() {
        _isLoading = false; // Set loading false setelah selesai
      });
    }
  }

  // Helper untuk memformat durasi menjadi HH:MM:SS atau MM:SS
  String _formatDuration(int seconds) {
    if (seconds < 0) return '00:00';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(seconds ~/ 60);
    String twoDigitSeconds = twoDigits(seconds % 60);
    if (seconds >= 3600) {
      String twoDigitHours = twoDigits(seconds ~/ 3600);
      return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  // Helper untuk menampilkan Snackbar
  void _showSnackbar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.errorColor : AppColors.successColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Activity Insights (F2)', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadSessions, // Tombol refresh data
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      )
          : _sessions.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 80, color: Colors.white54),
            SizedBox(height: 20),
            Text(
              'No focus sessions yet!',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            Text(
              'Start a session in "Deep Focus" to see your progress here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _sessions.length,
        itemBuilder: (context, index) {
          final session = _sessions[index];
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${DateFormat('EEEE, MMM d, yyyy').format(session.startTime)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    '${DateFormat('HH:mm').format(session.startTime)} - ${DateFormat('HH:mm').format(session.endTime)}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const Divider(color: Colors.white12, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Duration', style: TextStyle(color: Colors.white54, fontSize: 12)),
                          Text(
                            _formatDuration(session.totalDurationSeconds),
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Focused Time', style: TextStyle(color: Colors.white54, fontSize: 12)),
                          Text(
                            _formatDuration(session.focusedDurationSeconds),
                            style: const TextStyle(color: AppColors.successColor, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Distracted Time', style: TextStyle(color: Colors.white54, fontSize: 12)),
                          Text(
                            _formatDuration(session.distractedDurationSeconds),
                            style: const TextStyle(color: AppColors.errorColor, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Focus %', style: TextStyle(color: Colors.white54, fontSize: 12)),
                          Text(
                            '${session.focusPercentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: session.focusPercentage > 70 ? AppColors.successColor : (session.focusPercentage > 40 ? AppColors.warningColor : AppColors.errorColor),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
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