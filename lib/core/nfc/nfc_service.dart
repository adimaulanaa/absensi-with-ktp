import 'package:attendance_ktp/core/utils/snackbar_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

Future<void> availabilityNfc(BuildContext context) async {
  String nfcData = '';
  bool check = false;
  var availability = await FlutterNfcKit.nfcAvailability;

  if (availability == NFCAvailability.not_supported) {
    nfcData = 'NFC not supported on this device';
  } else if (availability == NFCAvailability.not_supported) {
    nfcData = 'NFC not available';
  } else if (availability == NFCAvailability.disabled) {
    nfcData = 'NFC disabled, please enable NFC';
  } else if (availability == NFCAvailability.available) {
    nfcData = 'NFC available';
    check = true;
  } else {
    nfcData = 'NFC error';
  }

  // Display a snackbar with the NFC status
  if (check) {
    // ignore: use_build_context_synchronously
    context.showSuccesSnackBar(
      nfcData,
      onNavigate: () {}, // bottom close
    );
  } else {
    // ignore: use_build_context_synchronously
    context.showErrorSnackBar(
      nfcData,
      onNavigate: () {}, // bottom close
    );
  }
}
