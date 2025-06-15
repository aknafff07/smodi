import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Import CameraController

class CameraFeedDisplay extends StatelessWidget {
  // Ubah tipe data dari String imageUrl menjadi CameraController? controller
  final CameraController? controller;

  const CameraFeedDisplay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Periksa apakah controller tidak null dan sudah diinisialisasi
    if (controller == null || !controller!.value.isInitialized) {
      // Tampilkan indikator loading atau pesan jika kamera belum siap
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 10),
            Text('Memuat feed kamera...', style: TextStyle(color: Colors.white70)),
          ],
        ),
      );
    }
    // Jika kamera sudah siap, tampilkan preview
    return ClipRRect(
      borderRadius: BorderRadius.circular(15), // Pastikan border radius diterapkan pada preview
      child: AspectRatio(
        aspectRatio: controller!.value.aspectRatio,
        child: CameraPreview(controller!),
      ),
    );
  }
}