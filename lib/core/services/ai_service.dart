// lib/services/ai_service.dart

import 'dart:ui'; // Diperlukan untuk kelas Size
import 'package:camera/camera.dart'; // Diperlukan untuk CameraImage dan Plane
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart'; // Untuk FaceDetector dan kelas terkait


class AIService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
      minFaceSize: 0.1,
      performanceMode: FaceDetectorMode.fast, // Coba FaceDetectorMode.accurate jika deteksi masih sulit
    ),
  );

  // Perubahan: Tambahkan parameter `cameraLensDirection` dan `cameraSensorOrientation`
  Future<List<Face>> detectFacesFromImage(
      CameraImage cameraImage,
      CameraLensDirection cameraLensDirection,
      int cameraSensorOrientation,
      ) async {
    final inputImage = _inputImageFromCameraImage(
      cameraImage,
      cameraLensDirection,
      cameraSensorOrientation,
    );
    if (inputImage == null) {
      print('Error: InputImage is null. Cannot process AI detection.');
      return [];
    }

    try {
      final List<Face> faces = await _faceDetector.processImage(inputImage);
      // Tambahkan logging di sini untuk melihat hasil deteksi AI
      if (faces.isNotEmpty) {
        // print('AI Debug: Face DETECTED! Count: ${faces.length}'); // Bisa diaktifkan untuk debugging
      } else {
        // print('AI Debug: No face detected.'); // Bisa diaktifkan untuk debugging
      }
      return faces;
    } catch (e) {
      print('Error processing image with FaceDetector: $e');
      return [];
    }
  }

  // Perubahan: Tambahkan parameter baru
  InputImage _inputImageFromCameraImage(
      CameraImage image,
      CameraLensDirection cameraLensDirection,
      int cameraSensorOrientation,
      ) {
    final planeData = image.planes.map(
          (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final InputImageFormat imageFormat;
    final foundFormat = InputImageFormat.values.firstWhere(
          (element) => element.rawValue == image.format.raw,
      orElse: () => InputImageFormat.nv21, // Default ke NV21 jika format kamera tidak dikenali
    );
    imageFormat = foundFormat;

    // --- Perhitungan Rotasi InputImage yang Benar ---
    final InputImageRotation imageRotation = _rotationFromSensorOrientation(
      cameraSensorOrientation,
      cameraLensDirection,
    );
    // print('AI Debug: Image Rotation calculated: $imageRotation'); // Debugging rotasi

    final inputImageData = InputImageData(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      imageRotation: imageRotation, // Gunakan rotasi yang dihitung
      inputImageFormat: imageFormat,
      planeData: planeData,
    );

    if (image.planes.isEmpty || image.planes[0].bytes == null) {
      print('Error: CameraImage planes or bytes are null.');
      throw Exception('CameraImage planes or bytes are null, cannot create InputImage.');
    }

    return InputImage.fromBytes(bytes: image.planes[0].bytes, inputImageData: inputImageData);
  }

  // Fungsi baru untuk menghitung InputImageRotation yang benar
  InputImageRotation _rotationFromSensorOrientation(int sensorOrientation, CameraLensDirection lensDirection) {
    // Penjelasan di sini sedikit lebih rinci:
    // sensorOrientation: Ini adalah orientasi sensor kamera dalam derajat (0, 90, 180, 270) relatif terhadap orientasi default perangkat.
    // lensDirection: Kamera depan (front) atau belakang (back).
    // ML Kit mengharapkan gambar dalam orientasi potret (portrait). Jika sensor kamera diatur ke lanskap (landscape),
    // kita perlu memutar gambar sebelum diberikan ke ML Kit.

    // Untuk kamera belakang, rotasi biasanya sama dengan orientasi sensor.
    // Untuk kamera depan, gambar sering kali dicerminkan secara horizontal oleh hardware,
    // jadi kita perlu rotasi tambahan untuk mengkompensasi pencerminan ini agar wajah tidak terbalik.
    // Nilai `+270` atau `+90` sering digunakan, tergantung perangkat dan bagaimana gambar diproses.

    int rotationCompensation = sensorOrientation;

    if (lensDirection == CameraLensDirection.front) {
      // Ini adalah heuristik yang paling sering berhasil untuk kamera depan.
      // Jika masih bermasalah, Anda mungkin perlu bereksperimen dengan
      // (sensorOrientation + 90) % 360, (sensorOrientation + 180) % 360, atau (sensorOrientation + 0) % 360.
      rotationCompensation = (sensorOrientation + 270) % 360;
    }

    // Konversi derajat rotasi menjadi enum InputImageRotation
    switch (rotationCompensation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        print('Warning: Unexpected sensor orientation ($sensorOrientation). Defaulting to 0deg.');
        return InputImageRotation.rotation0deg;
    }
  }

  void dispose() {
    _faceDetector.close();
  }
}