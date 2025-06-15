import 'package:flutter/material.dart';

class CameraControlButtons extends StatelessWidget {
  final VoidCallback onStartMonitoring;
  final VoidCallback onStopMonitoring;
  final bool isMonitoring;

  const CameraControlButtons({
    super.key,
    required this.onStartMonitoring,
    required this.onStopMonitoring,
    required this.isMonitoring,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: isMonitoring ? null : onStartMonitoring, // Nonaktifkan jika sedang memantau
          icon: const Icon(Icons.play_arrow, color: Colors.white),
          label: Text(isMonitoring ? 'Memantau...' : 'Mulai Pemantauan', style: const TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: isMonitoring ? Colors.grey : const Color(0xFF4CAF50), // Warna hijau saat tidak aktif
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: isMonitoring ? onStopMonitoring : null, // Aktifkan jika sedang memantau
          icon: const Icon(Icons.stop, color: Colors.white),
          label: const Text('Hentikan Pemantauan', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: isMonitoring ? Colors.red : Colors.grey, // Warna merah saat aktif
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}