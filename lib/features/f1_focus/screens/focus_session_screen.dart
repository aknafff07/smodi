import 'package:flutter/material.dart';
import 'package:smodi/core/constants/colors.dart';
import 'dart:async'; // Untuk Timer
import 'package:camera/camera.dart'; // Untuk CameraController dan CameraImage
import 'package:smodi/main.dart'; // Untuk akses ke daftar 'cameras' global
import 'package:smodi/core/services/ai_service.dart'; // Untuk AI Service kita
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart'; // Untuk kelas Face

import 'package:smodi/core/services/database_helper.dart'; // Impor DatabaseHelper
import 'package:smodi/models/focus_session.dart'; // Impor FocusSession model


class FocusSessionScreen extends StatefulWidget {
  const FocusSessionScreen({super.key});

  @override
  State<FocusSessionScreen> createState() => _FocusSessionScreenState();
}

class _FocusSessionScreenState extends State<FocusSessionScreen> {
  Timer? _timer; // Timer untuk hitung mundur sesi
  int _start = 25 * 60; // Durasi sesi fokus, default 25 menit (dalam detik)
  bool _isRunning = false; // Status apakah sesi sedang berjalan

  final DatabaseHelper _dbHelper = DatabaseHelper();

  DateTime? _sessionStartTime;

  CameraController? _cameraController; // Controller kamera khusus untuk sesi fokus ini
  Future<void>? _initializeControllerFuture; // Future untuk melacak inisialisasi kamera

  // Variabel untuk menyimpan informasi orientasi kamera yang sedang aktif
  CameraLensDirection? _currentCameraLensDirection;
  int? _currentCameraSensorOrientation;

  AIService _aiService = AIService(); // Instance dari AI Service
  bool _isCameraInitializedForFocus = false; // Status inisialisasi kamera untuk fokus
  bool _isUserFocused = false; // Status deteksi fokus oleh AI (true jika wajah terdeteksi)
  int _focusDetectedCount = 0; // Jumlah frame di mana fokus terdeteksi
  int _frameProcessedCount = 0; // Total jumlah frame yang diproses oleh AI

  Timer? _aiProcessingTimer; // Timer untuk throttling pemrosesan AI
  final Duration _processingInterval = const Duration(milliseconds: 500); // Interval pemrosesan AI (setengah detik)

  @override
  void initState() {
    super.initState();
    _initializeCameraForFocusSession(); // Inisialisasi kamera saat layar ini pertama kali dimuat
  }

  // Fungsi untuk menginisialisasi kamera khusus untuk sesi fokus
  Future<void> _initializeCameraForFocusSession() async {
    if (cameras.isEmpty) {
      _showSnackbar('No cameras found for focus session!', isError: true);
      setState(() { _isCameraInitializedForFocus = false; });
      return;
    }

    CameraDescription? selectedCamera;
    try {
      selectedCamera = cameras.firstWhere((desc) => desc.lensDirection == CameraLensDirection.front);
    } catch (e) {
      try {
        selectedCamera = cameras.firstWhere((desc) => desc.lensDirection == CameraLensDirection.back);
        _showSnackbar('Front camera not found, using back camera for focus session.', isError: true);
      } catch (e) {
        _showSnackbar('No suitable camera found for focus session!', isError: true);
        setState(() { _isCameraInitializedForFocus = false; });
        return;
      }
    }

    if (selectedCamera == null) {
      _showSnackbar('No camera found for initialization!', isError: true);
      setState(() { _isCameraInitializedForFocus = false; });
      return;
    }

    // --- PASTIKAN VARIABEL INI DISIMPAN DI SINI ---
    _currentCameraLensDirection = selectedCamera.lensDirection;
    _currentCameraSensorOrientation = selectedCamera.sensorOrientation;
    print('Camera Debug: Selected Camera - Name: ${selectedCamera.name}, '
        'Lens: ${selectedCamera.lensDirection}, Sensor Orientation: ${selectedCamera.sensorOrientation}');

    _cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.low,
      enableAudio: false,
    );

    _initializeControllerFuture = _cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isCameraInitializedForFocus = true;
      });
      _showSnackbar('Camera ready for focus session.');
    }).catchError((e) {
      if (e is CameraException) {
        _showSnackbar('Error initializing camera for focus: ${e.description}', isError: true);
      }
      setState(() {
        _isCameraInitializedForFocus = false;
      });
    });
  }

  // Fungsi untuk memulai sesi fokus dan streaming gambar ke AI
  void startTimer() async {
    if (!_isCameraInitializedForFocus || _cameraController == null || !_cameraController!.value.isInitialized) {
      _showSnackbar('Camera is not ready yet. Please wait.', isError: true);
      return;
    }

    // Pastikan orientasi kamera sudah ada sebelum memulai stream
    if (_currentCameraLensDirection == null || _currentCameraSensorOrientation == null) {
      _showSnackbar('Camera orientation data is missing. Cannot start AI.', isError: true);
      return;
    }

    if (!_cameraController!.value.isStreamingImages) {
      await _cameraController!.startImageStream((CameraImage image) async {
        if (_aiProcessingTimer == null || !_aiProcessingTimer!.isActive) {
          _aiProcessingTimer = Timer(_processingInterval, () async {
            _frameProcessedCount++;

            // --- PASTIKAN PARAMETER INI DITERUSKAN KE AIService ---
            final List<Face> faces = await _aiService.detectFacesFromImage(
              image,
              _currentCameraLensDirection!, // Pass lens direction
              _currentCameraSensorOrientation!, // Pass sensor orientation
            );
            final bool focused = faces.isNotEmpty;

            if (focused) {
              _focusDetectedCount++;
            }

            setState(() {
              _isUserFocused = focused;
            });
            _aiProcessingTimer?.cancel();
          });
        }
      });
    }

    _sessionStartTime = DateTime.now(); // Catat waktu mulai sesi di sini


    _timer?.cancel();
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_start < 1) {
          timer.cancel();
          _isRunning = false;
          _showSessionCompletionDialog();
          _stopImageStreamAndDisposeCamera();
        } else {
          _start--;
        }
      });
    });
    _showSnackbar('Focus session started!');
  }

  // ... (sisa kode pauseTimer, resetTimer, _showSessionCompletionDialog, _formatDuration, _showSnackbar, _stopImageStreamAndDisposeCamera, dispose, build, _buildDurationChip - TETAP SAMA) ...

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    _stopImageStreamAndDisposeCamera();
    _showSnackbar('Focus session paused.');
  }

  void resetTimer() {
    _timer?.cancel();
    _isRunning = false;
    setState(() {
      _start = 25 * 60;
      _isUserFocused = false;
      _focusDetectedCount = 0;
      _frameProcessedCount = 0;
    });
    _stopImageStreamAndDisposeCamera();
    _showSnackbar('Focus session reset.');
  }

  void _showSessionCompletionDialog() {
    final DateTime sessionEndTime = DateTime.now(); // Waktu selesai sesi

    // Hitung persentase fokus
    final double focusPercentage = _frameProcessedCount > 0
        ? (_focusDetectedCount / _frameProcessedCount) * 100
        : 0.0;

    // Hitung durasi fokus dan distraksi
    final int totalSessionDuration = (25 * 60) - _start; // Total durasi yang dihabiskan
    final int actualFocusedDuration = (_focusDetectedCount * _processingInterval.inMilliseconds / 1000).round(); // Fokus dalam detik
    final int actualDistractedDuration = totalSessionDuration - actualFocusedDuration;

    // Pastikan _sessionStartTime tidak null
    if (_sessionStartTime == null) {
      print('Error: Session start time is null. Cannot save session.');
      _showSnackbar('Failed to save session data.', isError: true);
      return;
    }

    // Buat objek FocusSession
    final FocusSession newSession = FocusSession(
      startTime: _sessionStartTime!, // Gunakan ! karena kita sudah cek null
      endTime: sessionEndTime,
      totalDurationSeconds: totalSessionDuration,
      focusedDurationSeconds: actualFocusedDuration,
      distractedDurationSeconds: actualDistractedDuration,
      focusPercentage: focusPercentage,
    );

    // Simpan sesi ke database
    _dbHelper.insertSession(newSession).then((id) {
      _showSnackbar('Session saved! ID: $id');
      print('Session saved with ID: $id');
    }).catchError((e) {
      _showSnackbar('Failed to save session: $e', isError: true);
      print('Error saving session: $e');
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Session Completed!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, color: AppColors.successColor, size: 60),
              const SizedBox(height: 15),
              Text(
                'Great job! You completed a ${_formatDuration(totalSessionDuration)} focus session.', // Menampilkan durasi aktual
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Focus detected in: ${focusPercentage.toStringAsFixed(1)}% of frames.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              // Tambahkan info durasi fokus/distraksi
              Text(
                'Focused: ${_formatDuration(actualFocusedDuration)} | Distracted: ${_formatDuration(actualDistractedDuration)}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(color: AppColors.primaryColor, fontSize: 18)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(int seconds) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(seconds ~/ 60);
    String twoDigitSeconds = twoDigits(seconds % 60);
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

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

  Future<void> _stopImageStreamAndDisposeCamera() async {
    _aiProcessingTimer?.cancel();
    if (_cameraController != null) {
      if (_cameraController!.value.isStreamingImages) {
        await _cameraController!.stopImageStream();
      }
      await _cameraController!.dispose();
    }
    setState(() {
      _isCameraInitializedForFocus = false;
      _cameraController = null;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _aiService.dispose();
    _stopImageStreamAndDisposeCamera();
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
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _isUserFocused ? AppColors.successColor : AppColors.errorColor,
                        width: 3,
                      ),
                    ),
                    child: _isCameraInitializedForFocus && _cameraController != null && _cameraController!.value.isInitialized
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: _cameraController!.value.aspectRatio,
                        child: CameraPreview(_cameraController!),
                      ),
                    )
                        : Center(
                      child: Icon(
                        _isCameraInitializedForFocus ? Icons.videocam : Icons.videocam_off,
                        color: _isCameraInitializedForFocus ? AppColors.primaryColor : Colors.white54,
                        size: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isUserFocused ? 'FOCUSED' : 'DISTRACTED',
                    style: TextStyle(
                      color: _isUserFocused ? AppColors.successColor : AppColors.errorColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Frames Processed: $_frameProcessedCount | Focused: $_focusDetectedCount',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    _formatDuration(_start),
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        heroTag: 'resetBtn',
                        onPressed: resetTimer,
                        backgroundColor: AppColors.warningColor,
                        child: const Icon(Icons.refresh, color: Colors.white),
                      ),
                      const SizedBox(width: 20),
                      FloatingActionButton(
                        heroTag: 'startPauseBtn',
                        onPressed: _isRunning ? pauseTimer : startTimer,
                        backgroundColor: _isRunning ? AppColors.errorColor : AppColors.primaryColor,
                        child: Icon(_isRunning ? Icons.pause : Icons.play_arrow, color: Colors.white),
                      ),
                      const SizedBox(width: 20),
                      FloatingActionButton(
                        heroTag: 'skipBtn',
                        onPressed: () {
                          setState(() {
                            _start = 0;
                          });
                        },
                        backgroundColor: Colors.blueGrey,
                        child: const Icon(Icons.skip_next, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Wrap(
                    spacing: 10.0,
                    children: [
                      _buildDurationChip(25),
                      _buildDurationChip(45),
                      _buildDurationChip(60),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryColor),
                  SizedBox(height: 20),
                  Text('Initializing camera...', style: TextStyle(color: Colors.white70)),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildDurationChip(int minutes) {
    return ActionChip(
      label: Text(
        '$minutes min',
        style: TextStyle(color: _start == minutes * 60 ? Colors.black : Colors.white),
      ),
      backgroundColor: _start == minutes * 60 ? AppColors.accentColor : Colors.white.withOpacity(0.1),
      onPressed: () {
        setState(() {
          _start = minutes * 60;
          if (_isRunning) {
            pauseTimer();
          }
        });
      },
    );
  }
}