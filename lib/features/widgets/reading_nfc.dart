import 'package:attendance_ktp/core/media/media_colors.dart';
import 'package:attendance_ktp/core/media/media_res.dart';
import 'package:attendance_ktp/core/media/media_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Future<dynamic> readingNFC(
  BuildContext context,
  Size size,
  VoidCallback startNFC,
  VoidCallback stopNFC,
) {
  // Mulai NFC saat modal muncul
  startNFC();

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bgScreen,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      ),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: size.height * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                "Reading NFC",
                style: blackTextstyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                MediaRes.warning,
                width: size.width * 0.25,
                // ignore: deprecated_member_use
                color: AppColors.bgBlack,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      );
    },
  ).whenComplete(() {
    // Hentikan NFC ketika modal selesai
    stopNFC();
  });
}
