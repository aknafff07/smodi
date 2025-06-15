import 'package:flutter/material.dart';
import 'package:smodi/core/constants/colors.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'dart:io';

// Import daftar kamera global dari main.dart
import 'package:smodi/main.dart'; // Tetap impor ini untuk akses 'cameras'

class CameraControlScreen extends StatefulWidget {
  const CameraControlScreen({super.key});

  @override
  State<CameraControlScreen> createState() => _CameraControlScreenState();
}

class _CameraControlScreenState extends State<CameraControlScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  bool _isCameraInitialized = false;
  bool _isRecording = false;
  String _cameraStatus = 'Inactive';
  int _snapshotCount = 0;

  // Variabel baru untuk melacak arah lensa yang sedang aktif
  CameraLensDirection _currentLensDirection = CameraLensDirection.back; // Default ke belakang

  @override
  void initState() {
    super.initState();
    // Coba inisialisasi kamera depan terlebih dahulu
    _initializeCamera(CameraLensDirection.front); // Panggil dengan kamera depan
  }

  // Ubah fungsi inisialisasi untuk menerima arah lensa
  Future<void> _initializeCamera(CameraLensDirection preferredDirection) async {
    // Dispose controller yang sudah ada jika ada
    if (_controller != null) {
      await _controller!.dispose();
    }

    if (cameras.isEmpty) {
      _showSnackbar('No cameras found on this device!', isError: true);
      setState(() {
        _isCameraInitialized = false;
        _cameraStatus = 'No Camera';
      });
      return;
    }

    CameraDescription? selectedCamera;
    try {
      selectedCamera = cameras.firstWhere(
            (description) => description.lensDirection == preferredDirection,
        // Jika kamera depan tidak ditemukan, gunakan kamera belakang sebagai fallback
        // HATI-HATI: .firstWhere akan error jika tidak ditemukan tanpa orElse
        // Jadi, kita akan cek nanti atau menggunakan try-catch di sini
      );
    } catch (e) {
      // Jika kamera depan tidak ditemukan, coba cari kamera belakang
      try {
        selectedCamera = cameras.firstWhere(
              (description) => description.lensDirection == CameraLensDirection.back,
        );
        _showSnackbar('Front camera not found, using back camera.', isError: true);
      } catch (e) {
        _showSnackbar('No suitable camera found (front or back)!', isError: true);
        setState(() {
          _isCameraInitialized = false;
          _cameraStatus = 'Error';
        });
        return;
      }
    }

    if (selectedCamera == null) {
      _showSnackbar('No camera found for initialization!', isError: true);
      setState(() {
        _isCameraInitialized = false;
        _cameraStatus = 'No Camera';
      });
      return;
    }

    _controller = CameraController(
      selectedCamera, // Gunakan kamera yang terpilih
      ResolutionPreset.medium,
      enableAudio: false, // Mungkin tidak perlu audio untuk analisis fokus
    );

    _initializeControllerFuture = _controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isCameraInitialized = true;
        _isRecording = false; // Pastikan status rekaman false saat inisialisasi
        _cameraStatus = 'Previewing';
        _currentLensDirection = preferredDirection; // Set arah lensa yang berhasil diinisialisasi
      });
      _showSnackbar('${_currentLensDirection == CameraLensDirection.front ? "Front" : "Back"} Camera Activated');
    }).catchError((e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            _showSnackbar('Camera access denied. Please grant permission in app settings.', isError: true);
            break;
          default:
            _showSnackbar('Error initializing camera: ${e.description}', isError: true);
            break;
        }
      }
      setState(() {
        _isCameraInitialized = false;
        _cameraStatus = 'Error';
      });
    });
  }

  void _toggleCamera() async {
    // Logika ini sekarang akan menghentikan kamera dan meminta inisialisasi ulang
    // dengan arah lensa yang sama. Untuk switch depan/belakang, lihat _switchCameraLens()
    if (_isCameraInitialized) {
      await _controller!.dispose();
      setState(() {
        _isCameraInitialized = false;
        _isRecording = false;
        _cameraStatus = 'Inactive';
        _showSnackbar('Camera Deactivated');
        _controller = null; // Set controller to null after dispose
      });
    } else {
      await _initializeCamera(_currentLensDirection); // Aktifkan kamera dengan arah lensa saat ini
    }
  }

  // Fungsi baru untuk beralih kamera depan/belakang
  void _switchCameraLens() async {
    if (cameras.length < 2) {
      _showSnackbar('Only one camera found on this device.', isError: true);
      return;
    }

    CameraLensDirection newDirection = _currentLensDirection == CameraLensDirection.front
        ? CameraLensDirection.back
        : CameraLensDirection.front;

    // Inisialisasi kamera dengan arah lensa yang baru
    await _initializeCamera(newDirection);
  }


  void _toggleRecording() async {
    if (!_isCameraInitialized || _controller == null || !_controller!.value.isInitialized) {
      _showSnackbar('Please activate camera first!', isError: true);
      return;
    }

    if (_controller!.value.isRecordingVideo) {
      try {
        await _controller!.stopVideoRecording();
        setState(() {
          _isRecording = false;
          _cameraStatus = 'Previewing';
          _showSnackbar('Recording Stopped');
        });
      } catch (e) {
        _showSnackbar('Error stopping recording: $e', isError: true);
      }
    } else {
      try {
        await _controller!.startVideoRecording();
        setState(() {
          _isRecording = true;
          _cameraStatus = 'Recording';
          _showSnackbar('Recording Started');
        });
      } catch (e) {
        _showSnackbar('Error starting recording: $e', isError: true);
      }
    }
  }

  void _takeSnapshot() async {
    if (!_isCameraInitialized || _controller == null || !_controller!.value.isInitialized) {
      _showSnackbar('Please activate camera first!', isError: true);
      return;
    }

    try {
      final XFile file = await _controller!.takePicture();
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String filePath = join(appDir.path, '${DateTime.now().millisecondsSinceEpoch}.png');
      await file.saveTo(filePath);

      setState(() {
        _snapshotCount++;
        _showSnackbar('Snapshot taken and saved to $filePath! Total: $_snapshotCount');
      });
    } catch (e) {
      _showSnackbar('Error taking snapshot: $e', isError: true);
      print('Snapshot error: $e');
    }
  }

  void _showCameraSettings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text('Camera Settings', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Resolution: ${_controller?.resolutionPreset.name ?? 'N/A'}',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                // Text(
                //   'FPS: ${_controller?.value.fps.toStringAsFixed(0) ?? 'N/A'}',
                //   style: TextStyle(color: Colors.white70),
                // ),
                const SizedBox(height: 10),
                Text(
                  'Facing: ${_controller?.description.lensDirection.name ?? 'N/A'}',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                const Text('More settings coming soon...', style: TextStyle(color: Colors.white54)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close', style: TextStyle(color: AppColors.primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.errorColor : AppColors.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
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
        title: const Text('Camera Control (F3)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: _showCameraSettings,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (_isCameraInitialized && _controller != null && _controller!.value.isInitialized) {
                          return CameraPreview(_controller!);
                        } else {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.videocam_off, size: 60, color: Colors.white30),
                                const SizedBox(height: 10),
                                Text(
                                  'Camera $_cameraStatus',
                                  style: const TextStyle(color: Colors.white54),
                                ),
                                if (snapshot.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Error: ${snapshot.error}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.red[300], fontSize: 12),
                                    ),
                                  ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Tap "Activate" or "Switch Camera" to try again, or check app permissions.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white54, fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isCameraInitialized ? Icons.fiber_manual_record : Icons.circle,
                  color: _isCameraInitialized ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Status: $_cameraStatus',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(width: 15),
                Icon(
                  _currentLensDirection == CameraLensDirection.front ? Icons.face : Icons.camera_alt,
                  color: Colors.white54,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  'Facing: ${_currentLensDirection == CameraLensDirection.front ? "Front" : "Back"}',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  icon: _isCameraInitialized ? Icons.videocam_off : Icons.videocam,
                  label: _isCameraInitialized ? 'Deactivate' : 'Activate',
                  color: _isCameraInitialized ? AppColors.errorColor : AppColors.successColor,
                  onPressed: _toggleCamera,
                ),
                _buildControlButton(
                  icon: _isRecording ? Icons.stop : Icons.fiber_manual_record,
                  label: _isRecording ? 'Stop Rec' : 'Start Rec',
                  color: _isRecording ? AppColors.warningColor : AppColors.primaryColor,
                  onPressed: _toggleRecording,
                ),
                _buildControlButton(
                  icon: Icons.camera_alt,
                  label: 'Snapshot',
                  color: AppColors.accentColor,
                  onPressed: _takeSnapshot,
                ),
              ],
            ),
            const SizedBox(height: 20), // Tambahkan sedikit jarak

            // Tombol Switch Camera
            Center( // Posisikan di tengah
              child: ElevatedButton.icon(
                onPressed: _switchCameraLens,
                icon: const Icon(Icons.switch_camera_outlined, color: Colors.white),
                label: Text(
                  _currentLensDirection == CameraLensDirection.front ? 'Switch to Back Camera' : 'Switch to Front Camera',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[700], // Warna yang berbeda
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30), // Jarak ke bawah

            // Informasi Tambahan/Log Snapshots (tetap di bawah)
            const Text(
              'Recent Snapshots:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _snapshotCount > 0
                    ? 'You have taken $_snapshotCount snapshot(s) today.'
                    : 'No snapshots taken yet.',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),

            // Mode Pengambilan Gambar/Video (Contoh dummy)
            ElevatedButton.icon(
              onPressed: () {
                _showSnackbar('Changing capture mode (Coming Soon)!');
              },
              icon: const Icon(Icons.video_camera_back_outlined, color: Colors.white),
              label: const Text('Change Capture Mode', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor.withOpacity(0.7),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: label, // Penting untuk unique tag jika ada beberapa FAB
          onPressed: onPressed,
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: Icon(icon, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}