import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraService with ChangeNotifier {
  List<CameraDescription>? _cameras;
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isMonitoring = false;

  List<CameraDescription>? get cameras => _cameras;
  CameraController? get controller => _controller;
  bool get isCameraInitialized => _isCameraInitialized;
  bool get isMonitoring => _isMonitoring;

  Future<void> initializeCameras() async {
    debugPrint('CameraService: Memulai inisialisasi kamera...');
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) { // Tambahkan null check
        debugPrint('CameraService: ERROR - Tidak ada kamera yang tersedia di perangkat ini.');
        _isCameraInitialized = false; // Pastikan status tetap false
        notifyListeners();
        return;
      }
      debugPrint('CameraService: Kamera ditemukan: ${_cameras!.length}');
      _isCameraInitialized = true;
      notifyListeners();
    } on CameraException catch (e) {
      debugPrint('CameraService: FATAL ERROR in initializeCameras: ${e.code}: ${e.description}');
      _isCameraInitialized = false; // Pastikan status tetap false
      notifyListeners();
    } catch (e) {
      debugPrint('CameraService: UNEXPECTED ERROR in initializeCameras: $e');
      _isCameraInitialized = false; // Pastikan status tetap false
      notifyListeners();
    }
  }

  Future<void> startCamera(CameraLensDirection direction) async {
    debugPrint('CameraService: Memulai startCamera untuk arah: $direction');
    if (_cameras == null || _cameras!.isEmpty) {
      debugPrint('CameraService: Kamera belum terinisialisasi. Mencoba menginisialisasi ulang.');
      await initializeCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        debugPrint('CameraService: Gagal memulai kamera: Tidak ada kamera tersedia setelah inisialisasi ulang.');
        return;
      }
    }

    CameraDescription? cameraDescription;
    try {
      cameraDescription = _cameras!.firstWhere(
            (camera) => camera.lensDirection == direction,
        orElse: () {
          debugPrint('CameraService: Kamera dengan arah $direction tidak ditemukan. Menggunakan kamera pertama yang tersedia.');
          return _cameras!.first; // Fallback ke kamera pertama jika tidak ditemukan
        },
      );
    } catch (e) {
      debugPrint('CameraService: Error saat mencari kamera: $e');
      debugPrint('CameraService: Daftar kamera yang tersedia: ${_cameras?.map((c) => c.lensDirection).toList()}');
      _isMonitoring = false;
      notifyListeners();
      return; // Keluar dari fungsi jika tidak ada kamera yang ditemukan
    }


    if (_controller != null) {
      debugPrint('CameraService: Controller lama ditemukan, membuang...');
      await _controller!.dispose();
    }

    _controller = CameraController(
      cameraDescription!, // Pastikan cameraDescription tidak null di sini
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      debugPrint('CameraService: Mencoba menginisialisasi controller...');
      await _controller!.initialize();
      debugPrint('CameraService: Controller berhasil diinisialisasi.');
      _isMonitoring = true;
      notifyListeners();
    } on CameraException catch (e) {
      debugPrint('CameraService: ERROR starting camera: ${e.code}: ${e.description}');
      _isMonitoring = false;
      notifyListeners();
    } catch (e) {
      debugPrint('CameraService: UNEXPECTED ERROR starting camera: $e');
      _isMonitoring = false;
      notifyListeners();
    }
  }

  Future<void> stopCamera() async {
    debugPrint('CameraService: Memulai stopCamera...');
    if (_controller != null) {
      try {
        await _controller!.dispose();
        _controller = null;
        _isMonitoring = false;
        debugPrint('CameraService: Kamera berhasil dihentikan.');
      } on CameraException catch (e) {
        debugPrint('CameraService: ERROR stopping camera: ${e.code}: ${e.description}');
      } finally {
        notifyListeners();
      }
    } else {
      debugPrint('CameraService: Controller sudah null, tidak perlu dihentikan.');
    }
  }

  @override
  void dispose() {
    debugPrint('CameraService: Membuang CameraService...');
    _controller?.dispose();
    super.dispose();
  }
}