import 'dart:async';

import 'package:attendance_ktp/core/config/config_resources.dart';
import 'package:attendance_ktp/core/media/media_text.dart';
import 'package:attendance_ktp/core/nfc/nfc_service.dart';
import 'package:attendance_ktp/core/utils/location_service.dart';
import 'package:attendance_ktp/core/utils/snackbar_extension.dart';
import 'package:attendance_ktp/features/face_detection/face_detector_view.dart';
import 'package:attendance_ktp/features/widgets/reading_nfc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;
  String nfcData = 'No Data';
  String nfcDatas = 'No Data';
  bool isListening = false;

  // timer
  String _formattedTime = '';
  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _startTimer(); // Memulai Timer
    getLocation();
    availabilityNfc(context);
  }

  @override
  void dispose() {
    _timer.cancel(); // Membatalkan Timer saat widget dihapus
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: height * 0.1),
            Text(
              'Attendance KTP',
              style: blackTextstyle.copyWith(
                fontSize: 20,
                fontWeight: bold,
              ),
            ),
            Text(
              _formattedTime,
              style: blackTextstyle.copyWith(
                fontSize: 20,
                fontWeight: bold,
              ),
            ),
            SizedBox(height: height * 0.1),
            InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {
                readingNFC(
                  context,
                  size,
                  () {
                    startNFC();
                  },
                  () {
                    stopNFC();
                  },
                );
              },
              child: Container(
                height: height * 0.2,
                margin: const EdgeInsets.only(right: 20, left: 20),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    isListening ? 'Reading NFC' : 'Attendance IN',
                    style: whiteTextstyle.copyWith(
                      fontSize: 25,
                      fontWeight: bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {
                readingNFC(
                  context,
                  size,
                  () {
                    startNFC();
                  },
                  () {
                    stopNFC();
                  },
                );
              },
              child: Container(
                height: height * 0.2,
                margin: const EdgeInsets.only(right: 20, left: 20),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    isListening ? 'Reading NFC' : 'Attendance Out',
                    style: whiteTextstyle.copyWith(
                      fontSize: 25,
                      fontWeight: bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        DateTime now = DateTime.now();
        _currentTime = now;
        String timezone = now.timeZoneName; // Mendapatkan nama timezone
        String time = DateFormat('HH:mm:ss').format(_currentTime);
        _formattedTime = '$time $timezone';
      });
    });
  }

  Future<void> startNFC() async {
    setState(() {
      isListening = true;
    });

    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability == NFCAvailability.available) {
      while (isListening) {
        try {
          final NFCTag tag = await FlutterNfcKit.poll();
          nfcDatas = tag.id;
          setDataNFC(tag);
        } on Exception catch (e) {
          setState(() {
            nfcDatas = 'Error reading NFC: $e';
            isListening = false; // Stop listening if there's an error
          });
        }
      }
    } else {
      setState(() {
        isListening = false;
      });
    }
  }

  void stopNFC() {
    setState(() {
      isListening = false;
    });
    FlutterNfcKit.finish();
  }

  void setDataNFC(NFCTag tag) async {
    int levelChecking = 0;
    bool isChecking = true;
    bool isCheckingID = false;
    bool isCheckingTime = false;
    bool isCheckingLoc = false;
    String success = 'Berhasil';
    String error = 'Error';
    DateTime now = DateTime.now(); // Ambil waktu saat ini
    DateTime targetTime = DateFormat("HH:mm").parse(StringResources.inTimeIn);

    //! Checking id KTP terdaftar atau tidak
    if (StringResources.inIdEmployee == tag.id) {
      isCheckingID = true;
      levelChecking = 1;
    } else {
      isChecking = false;
      error = 'Attandance Gagal KTP tidak terdaftar';
    }

    //! Checking waktu absensi
    if (isCheckingID) {
      if (StringResources.inUseTime) {
        // memeriksa apakah waktu yang dijadwalnya sudah melewati atau belum
        // disini kondisinya adalah harus melewati batas yang di jadwalkan
        if (now.isAfter(targetTime)) {
          levelChecking = 2;
          isCheckingTime = true;
        } else {
          isChecking = false;
          error = 'Attandance Gagal belum waktunya absensi in';
        }
      } else {
        levelChecking = 2;
        isCheckingTime = true;
      }
    }

    //! Checking lokasi dengan jarak maksimal 50 meter
    if (isCheckingTime) {
      int rangeLoc = StringResources.inRangeLocationMeter;
      double defaultLat = StringResources.latitude;
      double defaultLong = StringResources.longitude;
      // Hitung jarak antara lokasi saat ini dan lokasi default
      double distanceInMeters = Geolocator.distanceBetween(
        defaultLat,
        defaultLong,
        currentLatitude,
        currentLongitude,
      );

      // Cek apakah jaraknya lebih dari 20 meter
      if (distanceInMeters <= rangeLoc) {
        isCheckingLoc = true;
        levelChecking = 3;
      } else {
        double checkRangeLoc = distanceInMeters - rangeLoc.toDouble();
        // bisa di sesuaikan berapa digit di belakang koma
        String txtRange = checkRangeLoc.toStringAsFixed(2);
        isChecking = false;
        error = 'Attandance Gagal jarak anda terlalu jauh $txtRange meter';
      }
    }
    // close popup use NFC
    Navigator.pop(context);
    stopNFC();

    //! Checking Liveness Detection
    if (isCheckingLoc) {
      // Tampilkan FaceDetectorView dan tunggu hasilnya
      final result = await Navigator.push(
        context,
        MaterialPageRoute<bool>(
          builder: (context) => const FaceDetectorView(),
        ),
      );
      if (result == true) {
        isChecking = true;
        levelChecking = 4;
      } else {
        isChecking = false;
        error = 'Attandance Gagal Wajah tidak terdeteksi (Live)';
      }
    }

    if (isChecking && levelChecking > 3) {
      isChecking = true;
      success = 'Attandance Berhasil';
    }

    _popUp(isChecking, success, error);
    setState(() {});
  }

  void _popUp(bool isChecking, String success, error) {
    if (isChecking) {
      context.showSuccesSnackBar(
        success,
        onNavigate: () {}, // bottom close
      );
    } else {
      context.showErrorSnackBar(
        error,
        onNavigate: () {}, // bottom close
      );
    }
  }

  void getLocation() async {
    // Memeriksa status GPS dan izin lokasi
    bool isGpsEnabled = await LocationService.isGpsEnabled();
    bool isPermissionGranted = await LocationService.requestPermission();
    // Mendapatkan lokasi menggunakan LocationService
    if (isGpsEnabled && isPermissionGranted) {
      // Jika GPS hidup dan akses diberikan, ambil lokasi
      Position position = await LocationService.getCurrentLocation();
      currentLatitude = position.latitude;
      currentLongitude = position.longitude;
    }
  }
}
