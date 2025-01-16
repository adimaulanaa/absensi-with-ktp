import 'dart:async';

import 'package:attendance_ktp/core/config/config_resources.dart';
import 'package:attendance_ktp/core/media/media_colors.dart';
import 'package:attendance_ktp/core/media/media_res.dart';
import 'package:attendance_ktp/core/media/media_text.dart';
import 'package:attendance_ktp/core/nfc/nfc_service.dart';
import 'package:attendance_ktp/core/utils/loading.dart';
import 'package:attendance_ktp/core/utils/snackbar_extension.dart';
import 'package:attendance_ktp/features/dashboard/data/models/absensi_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/employee_model.dart';
import 'package:attendance_ktp/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:attendance_ktp/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:attendance_ktp/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:attendance_ktp/features/dashboard/presentation/pages/view_all_employee.dart';
import 'package:attendance_ktp/features/dashboard/presentation/widgets/dashboard_widgets.dart';
import 'package:attendance_ktp/features/dashboard/presentation/widgets/reading_nfc.dart';
import 'package:attendance_ktp/features/face_detection/face_detector_view.dart';
import 'package:attendance_ktp/features/settings/presentation/pages/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:flutter_svg/svg.dart';
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
  bool isInListening = false;
  bool isOutListening = false;
  List<EmployeeModel> allEmployee = [];
  List<AbsensiModel> getAllAbsensi = [];

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
    load();
  }

  @override
  void dispose() {
    _timer.cancel(); // Membatalkan Timer saat widget dihapus
    super.dispose();
  }

  void load() {
    context.read<DashboardBloc>().add(const GetEmployee());
    context.read<DashboardBloc>().add(const GetAbsensi());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgGreySecond,
      body: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is EmployeeError) {
            if (state.error != '') {
              context.showErrorSnackBar(
                state.error,
                onNavigate: () {}, // bottom close
              );
            }
          } else if (state is AbsensiError) {
            if (state.error != '') {
              context.showErrorSnackBar(
                state.error,
                onNavigate: () {}, // bottom close
              );
            }
          } else if (state is CreateAbsensiError) {
            if (state.error != '') {
              context.showErrorSnackBar(
                state.error,
                onNavigate: () {}, // bottom close
              );
            }
          } else if (state is EmployeeLoaded) {
            if (state.data.isNotEmpty) {
              allEmployee = state.data;
            }
          } else if (state is AbsensiLoaded) {
            if (state.data.isNotEmpty) {
              getAllAbsensi = state.data;
            }
          } else if (state is CreateAbsensiSuccess) {
            if (state.success.isSucces) {
              context.showSuccesSnackBar(
                state.success.message,
                onNavigate: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardScreen()),
                  );
                }, // bottom close
              );
            }
          }
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return Stack(
              children: [
                _bodyData(context, size), // Latar belakang utama
                if (state is EmployeeLoading ||
                    state is AbsensiLoading ||
                    state is CreateAbsensiLoading) ...[
                  // Layar semi-transparan gelap
                  Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  // Loading overlay
                  const UIDialogLoading(text: StringResources.loading),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  SafeArea _bodyData(BuildContext context, Size size) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                InkWell(
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
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
            SizedBox(height: size.height * 0.03),
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
            SizedBox(height: size.height * 0.05),
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
                height: size.height * 0.2,
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
                height: size.height * 0.2,
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'History Attendance',
                    style: blackTextstyle.copyWith(
                      fontSize: 15,
                      fontWeight: bold,
                    ),
                  ),
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewAllEmployee(),
                        ),
                      );
                    },
                    child: Text(
                      'View all',
                      style: blueTextstyle.copyWith(
                        fontSize: 13,
                        fontWeight: bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: getAllAbsensi.map((e) {
                    return historyAttendance(size, e);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
      // ignore: use_build_context_synchronously
      popUp(context, isChecking, success, error);
    }
  }

  void createAbsensi(NFCTag tag, String nameID, bool type) {
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
    context.read<DashboardBloc>().add(CreateAbsensi(create: createAb));
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

  void getLocation() async {
    // Memeriksa status GPS dan izin lokasi
    currentLatitude = await getDataLocation(false);
    currentLongitude = await getDataLocation(true);
  }
}
