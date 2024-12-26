import 'package:attendance_ktp/features/face_detection/face_detector_painter.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'detector_view.dart';

class FaceDetectorView extends StatefulWidget {
  const FaceDetectorView({super.key});

  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification:
          true, // Harus diaktifkan untuk mendeteksi probabilitas mata
      enableContours: true,
      enableLandmarks: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  double? _prevLeftEyeOpen;
  double? _prevRightEyeOpen;
  int _blinkCounter = 0;
  int _moveCounter = 0;
  Rect? _prevBoundingBox;
  var _cameraLensDirection = CameraLensDirection.front;

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      title: 'Face Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final faces = await _faceDetector.processImage(inputImage);
    bool isBlinkDetected = false; // Indikasi apakah wajah hidup

    for (final face in faces) {
      final leftEyeOpen = face.leftEyeOpenProbability ?? 0.0;
      final rightEyeOpen = face.rightEyeOpenProbability ?? 0.0;

      // Pergerakan Wajah (Face Movement)
      final boundingBox = face.boundingBox;
      if (_prevBoundingBox != null) {
        final movementDelta =
            (boundingBox.center - _prevBoundingBox!.center).distance;
        if (movementDelta > 5) {
          // Wajah harus bergerak cukup jauh
          _moveCounter++;
        }
      }

      if (_moveCounter > 4 &&
          _prevLeftEyeOpen != null &&
          _prevRightEyeOpen != null) {
        final leftDelta = (_prevLeftEyeOpen! - leftEyeOpen).abs();
        final rightDelta = (_prevRightEyeOpen! - rightEyeOpen).abs();

        if (leftDelta > 0.2 || rightDelta > 0.2) {
          _blinkCounter++;
          if (_blinkCounter > 4) {
            // Kedipan terdeteksi dalam beberapa frame
            isBlinkDetected = true;
            _blinkCounter = 0; // Reset
            break;
          }
        }
      }

      _prevLeftEyeOpen = leftEyeOpen;
      _prevRightEyeOpen = rightEyeOpen;
      _prevBoundingBox = face.boundingBox;
    }

    if (isBlinkDetected) {
      if (mounted) {
        // Kembalikan nilai true jika deteksi berhasil
        Navigator.pop(context, true);
      }
      _isBusy = false;
      return;
    }

    // jika ingin ada bentuk warnanya pakai ini
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      _text = text;
      // set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
