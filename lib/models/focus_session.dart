// lib/models/focus_session.dart

class FocusSession {
  final int? id; // ID unik untuk setiap sesi (auto-increment di DB)
  final DateTime startTime; // Waktu mulai sesi
  final DateTime endTime;   // Waktu selesai sesi
  final int totalDurationSeconds; // Durasi total sesi dalam detik
  final int focusedDurationSeconds; // Durasi fokus yang terdeteksi dalam detik
  final int distractedDurationSeconds; // Durasi distraksi yang terdeteksi dalam detik (total - focused)
  final double focusPercentage; // Persentase fokus (focusedDuration / totalDuration * 100)

  FocusSession({
    this.id,
    required this.startTime,
    required this.endTime,
    required this.totalDurationSeconds,
    required this.focusedDurationSeconds,
    required this.distractedDurationSeconds,
    required this.focusPercentage,
  });

  // Konversi FocusSession menjadi Map agar bisa disimpan ke database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(), // Simpan sebagai string ISO 8601
      'endTime': endTime.toIso8601String(),
      'totalDurationSeconds': totalDurationSeconds,
      'focusedDurationSeconds': focusedDurationSeconds,
      'distractedDurationSeconds': distractedDurationSeconds,
      'focusPercentage': focusPercentage,
    };
  }

  // Konversi Map dari database menjadi objek FocusSession
  factory FocusSession.fromMap(Map<String, dynamic> map) {
    return FocusSession(
      id: map['id'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      totalDurationSeconds: map['totalDurationSeconds'],
      focusedDurationSeconds: map['focusedDurationSeconds'],
      distractedDurationSeconds: map['distractedDurationSeconds'],
      focusPercentage: map['focusPercentage'],
    );
  }
}