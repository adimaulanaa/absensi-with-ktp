import 'package:attendance_ktp/core/media/media_text.dart';
import 'package:attendance_ktp/core/utils/location_service.dart';
import 'package:attendance_ktp/core/utils/snackbar_extension.dart';
import 'package:attendance_ktp/features/model/absensi_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

Widget historyAttendance(
  Size size,
  AbsensiModel e,
) {
  String time = DateFormat('HH:mm:ss').format(e.createOn!);
  bool inout = false;
  if (e.type == 'OUT') {
    inout = true;
  }
  return Container(
    height: size.height * 0.05,
    padding: const EdgeInsets.only(left: 20, right: 20),
    decoration: BoxDecoration(
      color: inout ? Colors.red : Colors.green,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          e.name.toString(),
          style: whiteTextstyle.copyWith(
            fontSize: 12,
            fontWeight: medium,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(width: 5),
        Text(
          e.type.toString(),
          style: whiteTextstyle.copyWith(
            fontSize: 12,
            fontWeight: medium,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(width: 5),
        Text(
          'Time $time',
          style: whiteTextstyle.copyWith(
            fontSize: 12,
            fontWeight: medium,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    ),
  );
}

void popUp(BuildContext context, bool isChecking, String success, error) {
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

Future<double> getDataLocation(bool type) async {
  // Memeriksa status GPS dan izin lokasi
  double data = 0.0;
  bool isGpsEnabled = await LocationService.isGpsEnabled();
  bool isPermissionGranted = await LocationService.requestPermission();
  // Mendapatkan lokasi menggunakan LocationService
  if (isGpsEnabled && isPermissionGranted) {
    // Jika GPS hidup dan akses diberikan, ambil lokasi
    Position position = await LocationService.getCurrentLocation();
    if (type) {
      data = position.longitude;
    } else {
      data = position.latitude;
    }
  }
  return data;
}
