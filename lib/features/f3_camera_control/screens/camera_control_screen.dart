import 'package:flutter/material.dart';
import 'package:smodi/core/constants/colors.dart';
import 'package:smodi/features/f3_camera_control/widgets/camera_feed_display.dart';
// import 'package:focus_forge/features/camera_control/widgets/camera_control_buttons.dart'; // Jika ingin dipisah lebih lanjut

class CameraControlScreen extends StatefulWidget {
  const CameraControlScreen({super.key});

  @override
  State<CameraControlScreen> createState() => _CameraControlScreenState();
}

class _CameraControlScreenState extends State<CameraControlScreen> {
  bool _isCameraActive = false;
  bool _isRecording = false;
  String _cameraStatus = 'Inactive';
  int _snapshotCount = 0; // Dummy count for snapshots

  // Placeholder untuk simulasi camera feed
  String _cameraFeedImage = 'assets/images/camera_placeholder_1.png'; // Ganti dengan gambar dummy
  List<String> _dummyImages = [
    'assets/images/camera_placeholder_1.png',
    'assets/images/camera_placeholder_2.png',
    'assets/images/camera_placeholder_3.png',
  ];
  int _currentImageIndex = 0;

  void _toggleCamera() {
    setState(() {
      _isCameraActive = !_isCameraActive;
      _cameraStatus = _isCameraActive ? 'Active' : 'Inactive';
      if (!_isCameraActive) {
        _isRecording = false; // Stop recording if camera is turned off
      }
      _showSnackbar('Camera ${_isCameraActive ? "Activated" : "Deactivated"}');
    });
  }

  void _toggleRecording() {
    if (!_isCameraActive) {
      _showSnackbar('Please activate camera first!', isError: true);
      return;
    }
    setState(() {
      _isRecording = !_isRecording;
      _cameraStatus = _isRecording ? 'Recording' : 'Active';
      _showSnackbar('Recording ${_isRecording ? "Started" : "Stopped"}');
    });
  }

  void _takeSnapshot() {
    if (!_isCameraActive) {
      _showSnackbar('Please activate camera first!', isError: true);
      return;
    }
    setState(() {
      _snapshotCount++;
      // Simulate changing camera feed image
      _currentImageIndex = (_currentImageIndex + 1) % _dummyImages.length;
      _cameraFeedImage = _dummyImages[_currentImageIndex];
      _showSnackbar('Snapshot taken! Total: $_snapshotCount');
    });
  }

  void _showCameraSettings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text('Camera Settings (Dummy)', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Resolution: 1080p', style: TextStyle(color: Colors.white70)),
                SizedBox(height: 10),
                Text('Frame Rate: 30 FPS', style: TextStyle(color: Colors.white70)),
                SizedBox(height: 10),
                Text('Storage Location: Cloud', style: TextStyle(color: Colors.white70)),
                SizedBox(height: 20),
                Text('More settings coming soon...', style: TextStyle(color: Colors.white54)),
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
            // Tampilan Feed Kamera
            Container(
              height: 250, // Tinggi tetap untuk feed kamera
              decoration: BoxDecoration(
                color: Colors.grey[900], // Warna latar belakang saat tidak aktif
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: _isCameraActive
                    ? CameraFeedDisplay(imageUrl: _cameraFeedImage)
                    : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.videocam_off, size: 60, color: Colors.white30),
                      const SizedBox(height: 10),
                      Text('Camera $_cameraStatus', style: const TextStyle(color: Colors.white54)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Indikator Status Kamera
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isCameraActive ? Icons.fiber_manual_record : Icons.circle,
                  color: _isCameraActive ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Status: $_cameraStatus',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Tombol Kontrol Kamera
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  icon: _isCameraActive ? Icons.videocam_off : Icons.videocam,
                  label: _isCameraActive ? 'Deactivate' : 'Activate',
                  color: _isCameraActive ? AppColors.errorColor : AppColors.successColor,
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
            const SizedBox(height: 30),

            // Informasi Tambahan/Log Snapshots (Dummy)
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
                // Implementasi untuk mengubah mode (misalnya, analisis fokus vs. rekaman biasa)
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
          heroTag: label, // Penting untuk unique tag jika ada banyak FAB
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