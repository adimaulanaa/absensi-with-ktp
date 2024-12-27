import 'dart:async';

import 'package:attendance_ktp/core/config/config_resources.dart';
import 'package:attendance_ktp/core/media/media_colors.dart';
import 'package:attendance_ktp/core/media/media_res.dart';
import 'package:attendance_ktp/core/media/media_text.dart';
import 'package:attendance_ktp/core/nfc/nfc_service.dart';
import 'package:attendance_ktp/core/utils/location_service.dart';
import 'package:attendance_ktp/core/utils/snackbar_extension.dart';
import 'package:attendance_ktp/features/data/employee_provider.dart';
import 'package:attendance_ktp/features/face_detection/face_detector_view.dart';
import 'package:attendance_ktp/features/model/absensi_model.dart';
import 'package:attendance_ktp/features/model/employee_model.dart';
import 'package:attendance_ktp/features/model/response_model.dart';
import 'package:attendance_ktp/features/presentation/setting_screen.dart';
import 'package:attendance_ktp/features/widgets/reading_nfc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;
  bool isInListening = false;
  bool isOutListening = false;
  List<EmployeeModel> allEmployee = [];
  List<AbsensiModel> getAllAbsensi = [];
  // AbsensiModel createAb = AbsensiModel();
  ResponseModel response = ResponseModel();

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
    _loadData();
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
      backgroundColor: AppColors.bgScreen,
      appBar: AppBar(
        backgroundColor: AppColors.bgScreen,
        actions: [
          InkWell(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            onTap: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: SvgPicture.asset(
                MediaRes.setting,
                fit: BoxFit.contain,
                width: 25,
                // ignore: deprecated_member_use
                color: AppColors.bgBlack,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * 0.03),
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
              SizedBox(height: height * 0.05),
              InkWell(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                onTap: () {
                  readingNFC(
                    context,
                    size,
                    () {
                      startInNFC();
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
                      isInListening ? 'Reading NFC' : 'Attendance IN',
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
                      startOutNFC();
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
                      isOutListening ? 'Reading NFC' : 'Attendance Out',
                      style: whiteTextstyle.copyWith(
                        fontSize: 25,
                        fontWeight: bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'History Attendance',
                style: blackTextstyle.copyWith(
                  fontSize: 25,
                  fontWeight: bold,
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: getAllAbsensi.map((e) {
                      String time = DateFormat('HH:mm:ss').format(e.createOn!);
                      return Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.idCard.toString(),
                            style: blackTextstyle.copyWith(
                              fontSize: 13,
                              fontWeight: medium,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            e.name.toString(),
                            style: blackTextstyle.copyWith(
                              fontSize: 12,
                              fontWeight: medium,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            e.type.toString(),
                            style: blackTextstyle.copyWith(
                              fontSize: 12,
                              fontWeight: medium,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            time,
                            style: blackTextstyle.copyWith(
                              fontSize: 12,
                              fontWeight: medium,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
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

  Future<void> startInNFC() async {
    setState(() {
      isInListening = true;
    });

    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability == NFCAvailability.available) {
      while (isInListening) {
        try {
          final NFCTag tag = await FlutterNfcKit.poll();
          setDataNFC(tag, false);
        } on Exception catch (e) {
          setState(() {
            // ignore: avoid_print
            print('Error reading NFC: $e');
            // Stop listening if there's an error
            isInListening = false;
          });
        }
      }
    } else {
      setState(() {
        isInListening = false;
      });
    }
  }

  Future<void> startOutNFC() async {
    setState(() {
      isOutListening = true;
    });

    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability == NFCAvailability.available) {
      while (isOutListening) {
        try {
          final NFCTag tag = await FlutterNfcKit.poll();
          setDataNFC(tag, true);
        } on Exception catch (e) {
          setState(() {
            // ignore: avoid_print
            print('Error reading NFC: $e');
            // Stop listening if there's an error
            isOutListening = false;
          });
        }
      }
    } else {
      setState(() {
        isOutListening = false;
      });
    }
  }

  void stopNFC() {
    setState(() {
      isInListening = false;
      isOutListening = false;
    });
    FlutterNfcKit.finish();
  }

  void setDataNFC(NFCTag tag, bool type) async {
    int levelChecking = 0;
    String nameID = '';
    bool isChecking = true;
    bool isCheckingID = false;
    bool isCheckingTime = false;
    bool isCheckingLoc = false;
    String success = 'Berhasil';
    String error = 'Error';
    DateTime now = DateTime.now(); // Ambil waktu saat ini

    //! Checking id KTP terdaftar atau tidak menggunakan ID yang terdaftar
    for (var e in allEmployee) {
      if (e.id == tag.id) {
        nameID = e.name ?? '';
      }
    }
    if (nameID.isNotEmpty) {
      isCheckingID = true;
      levelChecking = 1;
    } else {
      isChecking = false;
      error = StringResources.inErrorKTP;
    }

    //! Checking waktu absensi
    if (isCheckingID) {
      if (type) {
        if (StringResources.outUseTime) {
          // memeriksa apakah waktu yang dijadwalnya sudah melewati atau belum
          // disini kondisinya adalah harus melewati batas yang di jadwalkan
          DateTime targetTime =
              DateFormat("HH:mm").parse(StringResources.outTimeIn);
          targetTime = DateTime(
              now.year, now.month, now.day, targetTime.hour, targetTime.minute);
          if (now.isAfter(targetTime)) {
            levelChecking = 2;
            isCheckingTime = true;
          } else {
            isChecking = false;
            error = StringResources.outErrorTime;
          }
        } else {
          levelChecking = 2;
          isCheckingTime = true;
        }
      } else {
        if (StringResources.inUseTime) {
          // memeriksa apakah waktu yang dijadwalnya sudah melewati atau belum
          // disini kondisinya adalah harus melewati batas yang di jadwalkan
          DateTime targetTime =
              DateFormat("HH:mm").parse(StringResources.inTimeIn);
          targetTime = DateTime(
              now.year, now.month, now.day, targetTime.hour, targetTime.minute);
          if (now.isAfter(targetTime)) {
            levelChecking = 2;
            isCheckingTime = true;
          } else {
            isChecking = false;
            error = StringResources.inErrorTime;
          }
        } else {
          levelChecking = 2;
          isCheckingTime = true;
        }
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
        error = '${StringResources.inErrorLoc} $txtRange meter';
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
        error = StringResources.inErrorFace;
      }
    }

    if (isChecking && levelChecking > 3) {
      isChecking = true;
      createAbsensi(tag, nameID, type);
    } else {
      _popUp(isChecking, success, error);
    }
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

  void _loadData() async {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    allEmployee = await provider.getEmployee();
    getAllAbsensi = await provider.getAbsensi();
    setState(() {});
  }

  void createAbsensi(NFCTag tag, String nameID, bool type) async {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    String types = '';
    if (type) {
      types = 'OUT';
    } else {
      types = 'IN';
    }
    AbsensiModel createAb = AbsensiModel(
      idCard: tag.id,
      name: nameID,
      sak: tag.sak,
      standard: tag.standard,
      type: types,
      createOn: DateTime.now(),
    );
    response = await provider.createAbsensi(createAb);
    // isLoading.value = false;
    if (response.isSucces) {
      // ignore: use_build_context_synchronously
      context.showSuccesSnackBar(
        response.message,
        onNavigate: () {
          _loadData();
        }, // bottom close
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showErrorSnackBar(
        response.message,
        onNavigate: () {}, // bottom close
      );
    }
  }
}
