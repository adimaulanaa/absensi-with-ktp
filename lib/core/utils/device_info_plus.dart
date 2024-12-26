import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

Future<String> getDeviceId() async {
  final deviceInfoPlugin = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfoPlugin.androidInfo;
    return androidInfo.id; // Device ID untuk Android
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfoPlugin.iosInfo;
    return iosInfo.identifierForVendor ?? 'Unknown'; // Device ID untuk iOS
  } else {
    return 'Platform tidak didukung';
  }
}
